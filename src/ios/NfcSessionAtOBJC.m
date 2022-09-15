//
//  NfcSessionAtOBJC.m
//  nfcchecker
//
//  Created by 渡邊 信也 on 2022/09/02.
//

#import <Foundation/Foundation.h>
// #import "NfcSessionAtOBJC.h"
#import <CoreNFC/CoreNFC.h>

@interface NfcSessionAtOBJC()

@property (strong,nonatomic) NFCTagReaderSession *session API_AVAILABLE(ios(13.0));
// @property (nonatomic) TagDataAtOBJC *tagOBJC;

@end

@implementation NfcSessionAtOBJC
@synthesize delegate;

// セッション開始メソッド
- (void)beginScan {
    // 返却データの初期化
    // self.tagOBJC = [[TagDataAtOBJC alloc] init];
    // セッションの作成
    self.session = [[NFCTagReaderSession new]
                initWithPollingOption: (NFCPollingISO14443 | NFCPollingISO15693)
                delegate: self
                queue:dispatch_get_main_queue()
    ];
    // アラートメッセージの設定
    self.session.alertMessage = @"かざしてください";
    // セッション開始
    [self.session beginSession];
}

// // NFCTagReaderSessionDelegate 終了時
// - (void)tagReaderSession:(nonnull NFCTagReaderSession *)session didInvalidateWithError:(nonnull NSError *)error {
//     // セッションのクリア
//     self.session = nil;
// }

// // NFCTagReaderSessionDelegate タグ取得時
// - (void)tagReaderSession:(NFCTagReaderSession *)session didDetectTags:(NSArray<__kindof id<NFCTag>> *)tags {
    
//     // 複数検出時
//     if (tags.count > 1) {
//         [delegate finishScan: nil text: @"検出数エラー"];
//         [session invalidateSessionWithErrorMessage: @"検出数エラー"];
//         return;
//     }
    
//     // 検出０
//     if (tags.count == 0) {
//         [delegate finishScan: nil text: @"検出数エラー"];
//         [session invalidateSessionWithErrorMessage: @"検出数エラー"];
//         return;
//     }
    
//     // タグの確定
//     id<NFCTag> tag = tags[0];
    
//     id<NFCMiFareTag> miFareTag = [tag asNFCMiFareTag];
    
//     if (miFareTag == nil) {
//         // miFareTagではない
//         [delegate finishScan: nil text: @"MiFareタグではないエラー"];
//         [session invalidateSessionWithErrorMessage: @"MiFareタグではないエラー"];
//         return;
//     }
    
//     self.tagOBJC.tag = tag;
//     self.tagOBJC.uid = miFareTag.identifier;
//     self.tagOBJC.miFareFamily = miFareTag.mifareFamily;
    
//     // タグに接続
//     [session connectToTag: tag completionHandler:^(NSError * _Nullable error) {
//         // 接続失敗
//         if (error != nil) {
//             [self->delegate finishScan: self.tagOBJC text: @"コネクトエラー"];
//             [session invalidateSessionWithErrorMessage: @"コネクトエラー"];
//             return;
//         }
        
//         // タグからステータスを取得
//         [miFareTag queryNDEFStatusWithCompletionHandler:^(NFCNDEFStatus status, NSUInteger capacity, NSError * _Nullable error) {
//             // 接続失敗
//             if (error != nil) {
//                 [self->delegate finishScan: self.tagOBJC text: @"コネクトエラー"];
//                 [session invalidateSessionWithErrorMessage: @"コネクトエラー"];
//                 return;
//             }
//             // ステータスからロック済みからをBoolで保持
//             self.tagOBJC.isLock = status == NFCNDEFStatusReadOnly;
            
//             // NDEFの取得
//             [miFareTag readNDEFWithCompletionHandler:^(NFCNDEFMessage * _Nullable message, NSError * _Nullable error) {
//                 if (error != nil) {
//                     // 403エラーの場合はそのまま0件で続行
//                     if (error.code == 403) {
//                         self.tagOBJC.recordLength = 0;
//                     } else {
//                         [self->delegate finishScan: self.tagOBJC text: @"コネクトエラー"];
//                         [session invalidateSessionWithErrorMessage: @"コネクトエラー"];
//                         return;
//                     }
//                 } else {
//                     if (message == nil) {
//                         [self->delegate finishScan: self.tagOBJC text: @"コネクトエラー"];
//                         [session invalidateSessionWithErrorMessage: @"コネクトエラー"];
//                         return;
//                     } else {
//                         // レコード配列の数を保持
//                         self.tagOBJC.recordLength = (int)message.records.count;
//                     }
//                 }
                
//                 // 空のデータの作成
//                 NSMutableData *data = [[NSMutableData alloc]init];
//                 // ゲットバージョンのコマンド
//                 UInt8 getVersionCommand = 0x60;
//                 // コマンドのデータ化
//                 NSData *getVertionData = [NSData dataWithBytes: &getVersionCommand
//                                               length:sizeof(getVersionCommand)];
//                 // データに追加
//                 [data appendData: getVertionData];
//                 // コマンドの送信
//                 [miFareTag sendMiFareCommand:data completionHandler:^(NSData * _Nonnull response, NSError * _Nullable error) {
//                     // エラー確認
//                     if (error != nil) {
//                         [self->delegate finishScan: self.tagOBJC text: @"コネクトエラー"];
//                         [session invalidateSessionWithErrorMessage: @"コネクトエラー"];
//                         return;
//                     }
//                     // 取得したgetversionを取得
//                     self.tagOBJC.getVersion = response;
//                     [self->delegate finishScan: self.tagOBJC text: nil];
//                     [session invalidateSession];
//                     return;
//                 }];
//             }];
//         }];
//     }];
// }

@end


