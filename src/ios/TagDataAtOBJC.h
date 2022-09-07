//
//  TagDataAtOBJC.h
//  nfcchecker
//
//  Created by 渡邊 信也 on 2022/09/02.
//

#ifndef TagDataAtOBJC_h
#define TagDataAtOBJC_h

#import <CoreNFC/CoreNFC.h>

@interface TagDataAtOBJC : NSObject

@property (nonatomic) NSData *uid;
@property (nonatomic) bool isLock;
@property (nonatomic) id<NFCTag> tag;
@property (nonatomic) NFCMiFareFamily miFareFamily;
@property (nonatomic) NSData *getVersion;
@property (nonatomic) int recordLength;

@end


#endif /* TagDataAtOBJC_h */
