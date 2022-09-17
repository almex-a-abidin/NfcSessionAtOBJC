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

    @objc(beginScan:)
    func beginScan(command: CDVInvokedUrlCommand) {
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
        print(tags)
        
        if tags.count > 1 {
            // self.finishScan?(nil, "読み取りに失敗しました。再度お試しください。")
            self.pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "読み取りに失敗しました。再度お試しください。");
            self.commandDelegate!.send(self.pluginResult, callbackId: self.command!.callbackId);
            self.session?.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
        }
        
        // タグがなかった場合
        let tag = tags.first!

        // guard let tag = tags.first! else {
        //     // self.finishScan?(nil, "読み取りに失敗しました。再度お試しください。")
        //     self.session?.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
        // }
        
        if case .miFare(let miFareTag) = tag {
            var tagData = TagData()
            // タグの種類（mifare）確定
            tagData.tagType = tag
            // UID
            tagData.uid = miFareTag.identifier
            // familly
            tagData.miFareFamily = miFareTag.mifareFamily
            
            self.session?.connect(to: tag) { error in
                if error != nil {
                    var result = [
                        "tagType" : tagData.tagType?,
                        "uid" : tagData.uid,
                        "miFareFamily" : tagData.miFareFamily,
                        "message" : "読み取りに失敗しました。再度お試しください。"
                    ]
                    self.pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result);
                    self.commandDelegate!.send(self.pluginResult, callbackId: self.command!.callbackId);
                    self.session?.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
                }
                
        //         miFareTag.queryNDEFStatus { status, capacity, error in
        //             if error != nil {
        //                 self.finishScan?(tagData, "読み取りに失敗しました。再度お試しください。")
        //                 session.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
        //                 return
        //             }
        //             // ロック情報
        //             tagData.isLock = status == .readOnly
                    
        //             miFareTag.readNDEF { message, error in
        //                 // エラーの有無確認
        //                 if let error = error {
        //                     if (error as NSError).code == 403 {
        //                         // 403 はレコードを未編集時のエラーのため正しい
        //                         tagData.recordLength = 0
        //                     } else {
        //                         // 403以外のエラーはエラーとして処理する
        //                         self.finishScan?(tagData, "読み取りに失敗しました。再度お試しください。")
        //                         session.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
        //                         return
        //                     }
        //                 } else {
        //                     // エラーがなかったのでmessageのrecordsを取得
        //                     guard let records = message?.records else {
        //                         // messageオブジェクトがnilのため、エラーとする。
        //                         self.finishScan?(tagData, "読み取りに失敗しました。再度お試しください。")
        //                         session.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
        //                         return
        //                     }
        //                     tagData.recordLength = records.count
        //                 }
                        
        //                 // getVersion
        //                 miFareTag.sendMiFareCommand(commandPacket: Data([0x60])) { data, error in
        //                     if error != nil {
        //                         self.finishScan?(tagData, "読み取りに失敗しました。再度お試しください。")
        //                         session.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
        //                     }
        //                     tagData.getVersion = data
        //                     self.finishScan?(tagData, nil)
        //                     session.invalidate()
        //                 }
        //             }
        //         }
            }
        } else {
            //self.finishScan?(nil, "ハピホテタッチNではありません。")
            self.commandDelegate!.send(self.pluginResult, callbackId: self.command!.callbackId);
            self.session?.invalidate()
        }
    }
}

class TagData {
    var uid: Data = Data()
    var isLock: Bool?
    var tagType: NFCTag?
    var miFareFamily: NFCMiFareFamily = .unknown
    var getVersion: Data = Data()
    var recordLength: Int = -1
}
