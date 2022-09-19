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
    var session: NFCTagReaderSession?
    var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "The Plugin Failed");
    var command: CDVInvokedUrlCommand?
    var uid = "0"
    var locked = "false"
    var recordCount = "0"
    var version = ""

    //callback success with data
    func cdvCallbackSuccess() {
        var data = [
            "uid" : uid,
            "locked" : locked,
            "version" : recordCount,
            "recordLength" : version
        ]
        self.pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: data);
        self.commandDelegate!.send(self.pluginResult, callbackId: self.command!.callbackId);
    }

    @objc(beginScan:)
    func beginScan(command: CDVInvokedUrlCommand) {
        print("beginScan")
        self.command = command
        self.session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: self)
        self.session?.alertMessage = "ハピホテタッチNにかざしてください"
        self.session?.begin()

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
        // var sample = [
        //     "name": "Art John Abidin",
        //     "age": "29"
        // ]
        
        if tags.count > 1 {
            self.pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "読み取りに失敗しました。再度お試しください。");
            self.commandDelegate!.send(self.pluginResult, callbackId: self.command!.callbackId);
            self.session?.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
        }
        
        // タグがなかった場合
        let tag = tags.first!
        
        if case .miFare(let miFareTag) = tag {
            
            // UID
            var byteData = [UInt8]()
            miFareTag.identifier.withUnsafeBytes { byteData.append(contentsOf: $0) }
            byteData.forEach {
                uid.append(String($0, radix: 16))
            }
            
            self.session?.connect(to: tag) { error in
                if error != nil {
                    self.cdvCallbackSuccess()
                    self.session?.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
                }
                
                miFareTag.queryNDEFStatus { status, capacity, error in
                    if error != nil {
                        self.cdvCallbackSuccess()
                        self.session?.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
                    }
                    // ロック情報
                    if(status == .readOnly) {
                        self.locked = "true"
                    } else {
                        self.locked = "false"
                    }

                    miFareTag.readNDEF { message, error in
                        // エラーの有無確認
                        if let error = error {
                            if (error as NSError).code == 403 {
                                // 403 はレコードを未編集時のエラーのため正しい
                                self.recordCount = "0"
                            } else {
                                // 403以外のエラーはエラーとして処理する
                                self.cdvCallbackSuccess()
                                self.session?.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
                                // return
                            }
                        } else {
                            // エラーがなかったのでmessageのrecordsを取得
                            // guard let records = message?.records else {
                            //     // messageオブジェクトがnilのため、エラーとする。
                            //     self.cdvCallbackSuccess()
                            //     self.session?.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
                            //     return
                            // }
                            // self.recordCount = String(records.count)
                        }
                        
                        // getVersion
                        miFareTag.sendMiFareCommand(commandPacket: Data([0x60])) { data, error in
                            if error != nil {
                                self.cdvCallbackSuccess()
                                self.session?.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
                            }
               
                            // var result = data as Data
                            // self.version = String(decoding: result, as: UTF8.self)
                            self.cdvCallbackSuccess()
                            self.session?.invalidate()
                        }
                    }
                }
            }
        } else {
            //self.finishScan?(nil, "ハピホテタッチNではありません。")
            self.commandDelegate!.send(self.pluginResult, callbackId: self.command!.callbackId);
            self.session?.invalidate()
        }
    }
}

// struct TagData: Codable {
//     var uid: Data = Data()
//     var isLock: Bool?
//     var tagType: NFCTag?
//     var miFareFamily: NFCMiFareFamily = .unknown
//     var getVersion: Data = Data()
//     var recordLength: Int = -1
// }
