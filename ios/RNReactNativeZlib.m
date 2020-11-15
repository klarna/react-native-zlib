
#import "RNReactNativeZlib.h"
#import "ZLibSupport.h"



@implementation RNReactNativeZlib


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(inflate: (NSArray *) data
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject) {


    unsigned long dataSize = data.count;

    uint8_t *srcBuffer = (uint8_t*)malloc(dataSize);
    for (unsigned long i = 0; i < dataSize; i++) {
        srcBuffer[i] = (uint8_t) [[data objectAtIndex:i] longValue];
    }
    @try {
        int outLen = 0;
        uint8_t *dstBuffer = [ZLibSupport decompressData:srcBuffer withLength:dataSize outputLen:&outLen];
        free(srcBuffer);
        srcBuffer = nil;

        NSMutableArray* result = [[NSMutableArray alloc] init];
        for (int i = 0; i < outLen; i++) {
            [result addObject:[[NSNumber alloc] initWithLong:(long) dstBuffer[i]]];
        }
        free(dstBuffer);
        resolve(result);
    }
    @catch (NSException * ex) {
        if (srcBuffer) {
            free (srcBuffer);
        }
        NSMutableDictionary * info = [NSMutableDictionary dictionary];
        [info setValue:ex.name forKey:@"ExceptionName"];
        [info setValue:ex.reason forKey:@"ExceptionReason"];
        [info setValue:ex.callStackReturnAddresses forKey:@"ExceptionCallStackReturnAddresses"];
        [info setValue:ex.callStackSymbols forKey:@"ExceptionCallStackSymbols"];
        [info setValue:ex.userInfo forKey:@"ExceptionUserInfo"];

        NSError *error = [[NSError alloc] initWithDomain:@"RNReactNativeZlib" code:-1 userInfo:info];
        reject(@"Error", @"An error occurred while inflating data", error);
    }

}

RCT_EXPORT_METHOD(deflate: (NSArray *) data
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject) {


    unsigned long dataSize = data.count;

    uint8_t *srcBuffer = (uint8_t*)malloc(dataSize);
    for (unsigned long i = 0; i < dataSize; i++) {
        srcBuffer[i] = (uint8_t) [[data objectAtIndex:i] longValue];
    }
    @try {
        int outLen = 0;
        uint8_t *dstBuffer = [ZLibSupport compressData:srcBuffer withLength:dataSize outputLen:&outLen];
        free(srcBuffer);
        srcBuffer = nil;

        NSMutableArray* result = [[NSMutableArray alloc] init];
        for (int i = 0; i < outLen; i++) {
            [result addObject:[[NSNumber alloc] initWithLong:(long) dstBuffer[i]]];
        }
        free(dstBuffer);
        resolve(result);
    }
    @catch (NSException * ex) {
        if (srcBuffer) {
            free (srcBuffer);
        }
        NSMutableDictionary * info = [NSMutableDictionary dictionary];
        [info setValue:ex.name forKey:@"ExceptionName"];
        [info setValue:ex.reason forKey:@"ExceptionReason"];
        [info setValue:ex.callStackReturnAddresses forKey:@"ExceptionCallStackReturnAddresses"];
        [info setValue:ex.callStackSymbols forKey:@"ExceptionCallStackSymbols"];
        [info setValue:ex.userInfo forKey:@"ExceptionUserInfo"];

        NSError *error = [[NSError alloc] initWithDomain:@"RNReactNativeZlib" code:-1 userInfo:info];
        reject(@"Error", @"An error occurred deflating data", error);
    }

}


RCT_EXPORT_METHOD(inflateBase64: (NSString *) data64
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject) {

    NSData* nsdata =  [[NSData alloc]initWithBase64EncodedString:data64 options:0];

    unsigned long dataSize = nsdata.length;

    uint8_t *srcBuffer = (uint8_t *)[nsdata bytes];
    @try {
        int outLen = 0;
        uint8_t *dstBuffer = [ZLibSupport decompressData:srcBuffer withLength:dataSize outputLen:&outLen];

        nsdata = [[NSData alloc] initWithBytes:dstBuffer length:outLen];
        NSString* result = [nsdata base64EncodedStringWithOptions:0];
        free(dstBuffer);
        resolve(result);
    }
    @catch (NSException * ex) {
        NSMutableDictionary * info = [NSMutableDictionary dictionary];
        [info setValue:ex.name forKey:@"ExceptionName"];
        [info setValue:ex.reason forKey:@"ExceptionReason"];
        [info setValue:ex.callStackReturnAddresses forKey:@"ExceptionCallStackReturnAddresses"];
        [info setValue:ex.callStackSymbols forKey:@"ExceptionCallStackSymbols"];
        [info setValue:ex.userInfo forKey:@"ExceptionUserInfo"];

        NSError *error = [[NSError alloc] initWithDomain:@"RNReactNativeZlib" code:-1 userInfo:info];
        reject(@"Error", @"An error occurred while inflating data", error);
    }

}

RCT_EXPORT_METHOD(deflateBase64: (NSString *) data64
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject) {

    NSData* nsdata =  [[NSData alloc]initWithBase64EncodedString:data64 options:0];
    unsigned long dataSize = nsdata.length;


    uint8_t *srcBuffer = (uint8_t *)[nsdata bytes];
    @try {
        int outLen = 0;
        uint8_t *dstBuffer = [ZLibSupport compressData:srcBuffer withLength:dataSize outputLen:&outLen];

        nsdata = [[NSData alloc] initWithBytes:dstBuffer length:outLen];
        NSString* result = [nsdata base64EncodedStringWithOptions:0];
        free(dstBuffer);
        resolve(result);
    }
    @catch (NSException * ex) {
        if (srcBuffer) {
            free (srcBuffer);
        }
        NSMutableDictionary * info = [NSMutableDictionary dictionary];
        [info setValue:ex.name forKey:@"ExceptionName"];
        [info setValue:ex.reason forKey:@"ExceptionReason"];
        [info setValue:ex.callStackReturnAddresses forKey:@"ExceptionCallStackReturnAddresses"];
        [info setValue:ex.callStackSymbols forKey:@"ExceptionCallStackSymbols"];
        [info setValue:ex.userInfo forKey:@"ExceptionUserInfo"];

        NSError *error = [[NSError alloc] initWithDomain:@"RNReactNativeZlib" code:-1 userInfo:info];
        reject(@"Error", @"An error occurred deflating data", error);
    }

}


@end

