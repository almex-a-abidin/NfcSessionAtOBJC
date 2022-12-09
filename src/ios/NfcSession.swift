//
//  NfcSession.swift
//  nfcchecker
//
//  Created by 渡邊 信也 on 2022/09/15.
//

// callback用NFCセッション
import Foundation
import UIKit
import CoreNFC

@available(iOS 13, *)
@objc(NfcSession) class NfcSession: CDVPlugin, NFCTagReaderSessionDelegate {
    // エラー時の返却テキスト
    static let connectError: String = "読み取りに失敗しました。再度お試しください。"
    static let noMiFare: String = "ハピホテタッチNではありません。"
    // システムで表示するテキスト
    static let startMessage: String = "ハピホテタッチNにかざしてください"
    static let errorMessage: String = "読み取れませんでした"
    var session: NFCTagReaderSession?
    var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "読み取れませんでした");
    var command: CDVInvokedUrlCommand?
    var uid : String = ""
    var locked : String = ""
    var recordCount : String = ""
    var nfcVersion : String = ""
    var recordData: String = ""
    var recordedData: [UInt8] = [UInt8]()

    //callback success with data
    func cdvCallbackSuccess(message: String = "") {
        var result = [String: String]()

        result["status"] = "true"
        
        if(!message.isEmpty) {
            result["message"] = message
        }

        if(!self.recordData.isEmpty) {
            result["recordData"] = self.recordData
        }

        if(!self.locked.isEmpty) {
            result["locked"] = self.locked
        }

        if(!self.recordCount.isEmpty) {
            result["recordCount"] = self.recordCount
        }

        if(!self.uid.isEmpty) {
            result["uid"] = self.uid
        }

        if(!self.nfcVersion.isEmpty) {
            result["version"] = self.nfcVersion 
        }

        self.pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result);
        self.commandDelegate!.send(self.pluginResult, callbackId: self.command!.callbackId);
    }

    func cdvCallbackError(message: String = "") {
        var result = [String: String]()
        result["status"] = "false"
        if message.isEmpty {
            result["message"] = NfcSession.connectError
        } else {
            result["message"] = message
        }
            
        self.pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result);
        self.commandDelegate!.send(self.pluginResult, callbackId: self.command!.callbackId);
    }

    @objc(beginScan:)
    func beginScan(command: CDVInvokedUrlCommand) {
        // タグ情報の初期化
        uid = ""
        locked = ""
        recordCount = ""
        nfcVersion = ""
        recordData = ""
        recordedData = [UInt8]()
        
        self.command = command
        self.session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: self)
        self.session?.alertMessage = NfcSession.startMessage
        self.session?.begin()
    }

    @objc(getRecordedData:)
    func getRecordedData(command: CDVInvokedUrlCommand) {
        let cdvResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: self.recordedData);
        self.commandDelegate!.send(cdvResult, callbackId: command.callbackId);
    }


    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // 何もしない
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // 画面を閉じる
        self.session = nil
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        // 複数検出した場合
        
        if tags.count > 1 {
            self.cdvCallbackError()
            self.session?.invalidate(errorMessage: NfcSession.errorMessage)
            return
        }
        
        // タグがなかった場合
        guard let tag = tags.first else {
            self.cdvCallbackError()
            self.session?.invalidate(errorMessage: NfcSession.errorMessage)
            return
        }

        if case .miFare(let miFareTag) = tag {
            
            // UID
            self.uid = miFareTag.identifier.map{ String(format:"%.2hhx", $0)}.joined()

            self.session?.connect(to: tag) { error in
                if error != nil {
                    self.cdvCallbackError()
                    self.session?.invalidate(errorMessage: NfcSession.errorMessage)
                    return
                }
                
                miFareTag.queryNDEFStatus { status, capacity, error in
                    if error != nil {
                        self.cdvCallbackError()
                        self.session?.invalidate(errorMessage: NfcSession.errorMessage)
                        return
                    }
                    // ロック情報
                    self.locked = status == .readOnly ? "true" : "false"

                    miFareTag.readNDEF { message, error in
                        // エラーの有無確認
                        if let error = error {
                            if (error as NSError).code == 403 {
                                // 403 はレコードを未編集時のエラーのため正しい
                                self.recordCount = String(0)
                            } else {
                                // 403以外のエラーはエラーとして処理する
                                self.cdvCallbackError()
                                self.session?.invalidate(errorMessage: NfcSession.errorMessage)
                                return
                            }
                        } else {
                            // エラーがなかったのでmessageのrecordsを取得
                            if( message?.records != nil) {
                                let records = message!.records
                                self.recordCount = String(records.count)
                                
                                if(records.count > 0) {
                                    if records[0].payload.count > 0 {
                                        self.recordData = records[0].payload.hexEncodedString()
                                    }
                                }

                            } else {
                                self.cdvCallbackError()
                                self.session?.invalidate(errorMessage: NfcSession.errorMessage)
                                return
                            }

                        }
                        
                        // getVersion
                        miFareTag.sendMiFareCommand(commandPacket: Data([0x60])) { data, error in
                            if error != nil {
                                self.cdvCallbackError()
                                self.session?.invalidate(errorMessage: NfcSession.errorMessage)
                                return
                            }
                            self.recordedData = data.bytes()
                            //convert data to hex string
                            self.nfcVersion = data.hexEncodedString()
                            self.cdvCallbackSuccess()
                            self.session?.invalidate()
                        }
                    }
                }
            }
        } else {
            self.cdvCallbackError(message: NfcSession.noMiFare)
            self.session?.invalidate(errorMessage: NfcSession.noMiFare)
        }
    }
}

extension Data {
    
    func hexEncodedString() -> String {
        let format = "%02hhX"
        return map { String(format: format, $0) }.joined()
    }

    func bytes() -> [UInt8] {
        return [UInt8](self)
    }
}
