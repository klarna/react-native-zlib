//
//  ZLibSupport.h
//  RNReactNativeZlib
//
//  Created by Mauro Minoro on 16/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLibSupport : NSObject
+(void) checkZLibHeader:(uint8_t *)data  withLength:(int)datalen;
+(UInt32) getAdlerChecksum:(uint8_t *)data withLength:(int)datalen;
+(UInt32) calcAdlerChecksum:(uint8_t *)data withLength:(int)datalen;
+(uint8_t *) decompressData:(uint8_t *)data withLength:(int)datalen outputLen:(int*)outLen;
+(uint8_t *) compressData:(uint8_t *)data withLength:(int)datalen outputLen:(int*)outLen;
@end

NS_ASSUME_NONNULL_END
