//
//  ZLibSupport.m
//  RNReactNativeZlib
//
//  Created by Mauro Minoro on 16/11/20.
//

#import "ZLibSupport.h"
#include "compression.h"


#define ADLER_BASE 0xFFF1
#define ADLER_START 0x0001
@implementation ZLibSupport


+(uint8_t *) decompressData:(uint8_t *)data withLength:(int)datalen outputLen:(int*)outLen {
    [ZLibSupport checkZLibHeader:data withLength:datalen];
    UInt32 checksum = [ZLibSupport getAdlerChecksum:data withLength:datalen];

    for (int att = 1; att < 6; att++) {
        size_t dstSize = datalen << att;
        size_t outSize;
        uint8_t *dstBuffer = (uint8_t*)malloc(dstSize);
        outSize = compression_decode_buffer(dstBuffer, dstSize, data + 2, datalen-6, nil, COMPRESSION_ZLIB);
        if (outSize == dstSize) {
            free(dstBuffer);
            continue;
        }
        if (outSize == 0) {
            free(dstBuffer);
            NSException *e = [NSException
                   exceptionWithName:@"Zlib compression error"
                   reason:@"error decompressing data"
                   userInfo:nil];

            @throw e;
        }

        UInt32 realChecksum = [ZLibSupport calcAdlerChecksum:dstBuffer withLength:outSize];
        if (realChecksum != checksum) {
            free(dstBuffer);
            NSException *e = [NSException
                   exceptionWithName:@"Zlib compression error"
                   reason:@"cheksum mismatch"
                   userInfo:nil];

            @throw e;
        }
        *outLen = (int) outSize;
        return dstBuffer;
    }
    NSException *e = [NSException
           exceptionWithName:@"Zlib compression error"
           reason:@"insufficent memory"
           userInfo:nil];

    @throw e;

}

+(uint8_t *) compressData:(uint8_t *)data withLength:(int)datalen outputLen:(int*)outLen {
    size_t dstSize = datalen + 16384;
    size_t outSize;
    uint8_t *dstBuffer = (uint8_t*)malloc(dstSize);

    //compression library only supports LEVEL 5 so we write the default header for level 5
    dstBuffer[0] = 0x78;
    dstBuffer[1] = 0x5E;

    outSize = compression_encode_buffer(dstBuffer + 2, dstSize - 6, data, datalen, nil, COMPRESSION_ZLIB);

    if (outSize == 0) {
        free(dstBuffer);
        NSException *e = [NSException
               exceptionWithName:@"Zlib compression error"
               reason:@"Error compressing data (not enough memory)"
               userInfo:nil];

        @throw e;
    }

    UInt32 realChecksum = [ZLibSupport calcAdlerChecksum:data withLength:datalen];
    for (int i = 0; i < 4; i++) {
        dstBuffer[2+outSize + i] = (realChecksum >> (8 * (3-i))) & 0xFF;
    }

    *outLen = (int) outSize + 6;
    return dstBuffer;
}



+(void) checkZLibHeader:(uint8_t *)data  withLength:(int)datalen {
    if (datalen < 2) {
        NSException *e = [NSException
               exceptionWithName:@"Invalid Header"
               reason:@"data to short"
               userInfo:nil];

        @throw e;
    }

    UInt8 CMF = data[0];
    UInt8 FLG = data[1];
    if ((CMF & 0x0F) != 8) {
        NSException *e = [NSException
               exceptionWithName:@"Invalid Header"
               reason:@"Compression method not supported"
               userInfo:nil];

        @throw e;
    }
    if ((FLG & 0x20) != 0) {
        NSException *e = [NSException
               exceptionWithName:@"Invalid Header"
               reason:@"ZLib DICTID is not supported"
               userInfo:nil];

        @throw e;
    }
    UInt16 test = CMF;
    test <<= 8;
    test |= FLG;
    if (test % 31 != 0) {
        NSException *e = [NSException
               exceptionWithName:@"Invalid Header"
               reason:@"Header checksum mismatch"
               userInfo:nil];

        @throw e;
    }

}

+(UInt32) calcAdlerChecksum:(uint8_t *)data withLength:(int)datalen {
    if (data == nil || datalen <= 0)
        return 0;

    UInt32 unSum1 =ADLER_START; //unAdlerCheckSum & 0xFFFF;
    UInt32 unSum2 = 0; //(unAdlerCheckSum >> 16) & 0xFFFF;

    for (int  i = 0; i < datalen; i++) {
        unSum1 = (unSum1 + data[i]) % ADLER_BASE;
        unSum2 = (unSum1 + unSum2) % ADLER_BASE;
    }

    return (unSum2 << 16) + unSum1;
}
+(UInt32) getAdlerChecksum:(uint8_t *)data withLength:(int)datalen {
    if (datalen < 6) {
        NSException *e = [NSException
               exceptionWithName:@"Invalid Zlib checksum"
               reason:@"data to short"
               userInfo:nil];

        @throw e;
    }

    UInt32 checksum = 0;
    for (int i = 4; i > 0; i--) {
        checksum <<= 8;
        checksum |= data[datalen - i];
    }
    return checksum;

}


@end
