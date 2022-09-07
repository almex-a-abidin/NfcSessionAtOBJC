//
//  NfcSessionAtOBJC.h
//  nfcchecker
//
//  Created by 渡邊 信也 on 2022/09/02.
//

#ifndef NfcSessionArOBJC_h
#define NfcSessionArOBJC_h

#import <CoreNFC/CoreNFC.h>
#import "TagDataAtOBJC.h"

@protocol NfcSessionAtOBJCDelegate;

@interface NfcSessionAtOBJC : NSObject <NFCTagReaderSessionDelegate> {
    id<NfcSessionAtOBJCDelegate> delegate;
}

//@property(nonatomic, retain) id<NfcSessionAtOBJCDelegate> delegate;
@property(nonatomic, retain) id<NfcSessionAtOBJCDelegate> _Nullable delegate;
@property (nonatomic, assign) BOOL writeMode;

-(void)beginScan;

@end

@protocol NfcSessionAtOBJCDelegate <NSObject>
- (void)finishScan: (TagDataAtOBJC*_Nullable)tagData text:(NSString *_Nullable)errorText;

@end


#endif /* NfcSessionArOBJC_h */
