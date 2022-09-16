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
class NfcSession: NSObject, NFCTagReaderSessionDelegate {
    var session: NFCTagReaderSession?
    
    func beginScan() {
        // self.finishScan = finishScan
        session = NFCTagReaderSession(pollingOption: NFCTagReaderSession.PollingOption.iso14443, delegate: self)
        session?.alertMessage = "ハピホテタッチNにかざしてください"
        session?.begin()
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // 何もしない
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // 画面を閉じる
        self.session = nil
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        // // 複数検出した場合
        // if tags.count > 1 {
        //     self.finishScan?(nil, "読み取りに失敗しました。再度お試しください。")
        //     session.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
        //     return
        // }
        
        // // タグがなかった場合
        // guard let tag = tags.first else {
        //     self.finishScan?(nil, "読み取りに失敗しました。再度お試しください。")
        //     session.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
        //     return
        // }
        
        // if case .miFare(let miFareTag) = tag {
        //     let tagData = TagData()
        //     // タグの種類（mifare）確定
        //     tagData.tagType = tag
        //     // UID
        //     tagData.uid = miFareTag.identifier
        //     // familly
        //     tagData.miFareFamily = miFareTag.mifareFamily
            
        //     session.connect(to: tag) { error in
        //         if error != nil {
        //             self.finishScan?(tagData, "読み取りに失敗しました。再度お試しください。")
        //             session.invalidate(errorMessage: "読み取りに失敗しました。再度お試しください。")
        //             return
        //         }
                
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
        //     }
        // } else {
        //     self.finishScan?(nil, "ハピホテタッチNではありません。")
        //     session.invalidate()
        // }
    }
}

// class TagData {
//     var uid: Data = Data()
//     var isLock: Bool?
//     var tagType: NFCTag?
//     var miFareFamily: NFCMiFareFamily = .unknown
//     var getVersion: Data = Data()
//     var recordLength: Int = -1
// }
