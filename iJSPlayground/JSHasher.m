//
//  JSHasher.m
//  iJSPlayground
//
//  Created by Taras Kalapun on 31/03/14.
//  Copyright (c) 2014 Kalapun. All rights reserved.
//

#import "JSHasher.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation JSHasher

NSData *dataByIntepretingHexString(NSString *hexString) {
    char const *chars = hexString.UTF8String;
    NSUInteger charCount = strlen(chars);
    if (charCount % 2 != 0) {
        return nil;
    }
    NSUInteger byteCount = charCount / 2;
    uint8_t *bytes = malloc(byteCount);
    for (int i = 0; i < byteCount; ++i) {
        unsigned int value;
        sscanf(chars + i * 2, "%2x", &value);
        bytes[i] = value;
    }
    return [NSData dataWithBytesNoCopy:bytes length:byteCount freeWhenDone:YES];
}

+ (JSContext *)context {
    static JSContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[JSContext alloc] init];
        
        [context evaluateScript:@"var console = {}"];
        context[@"console"][@"log"] = ^(NSString *msg) {
            NSLog(@"JS: %@", msg);
        };
        
        for (NSString *file in @[@"bundle", @"main"]) {
            NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:file ofType:@"js"];
            NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
            if (content) {
                [context evaluateScript:content];
            }
        }
        
        
    });
    return context;
}


+ (NSString *)calculateAuthHeaderWithTokenId:(NSString *)tokenId
                                       token:(NSString *)token
                                   accessKey:(NSString *)accessKey
                                   secretKey:(NSString *)secretKey
                                  apiVersion:(NSString *)apiVersion
                                   timestamp:(NSString *)timestamp
{
    JSValue *func = [self context][@"bl_gen_token"];
    
    //bl_gen_token(token, tokenId, accessKey, secretKey, apiVersion, timestamp)
    NSArray *args = nil;
    if (!timestamp) {
        args = @[token, tokenId, accessKey, secretKey, apiVersion];
    } else {
        args = @[token, tokenId, accessKey, secretKey, apiVersion, timestamp];
    }
    
    JSValue *res = [func callWithArguments:args];
    return [res toString];
}

+ (NSData *)data_hmacsha1:(NSString *)data secret:(NSString *)key
{
    if ([data isKindOfClass:[NSData class]]) {
        data = [NSString stringWithUTF8String:[(NSData *)data bytes]];
    }
    
    JSValue *func = [self context][@"crypto_HmacSHA1"];
    JSValue *res = [func callWithArguments:@[data, key]];
    
    NSData *d = dataByIntepretingHexString([res toString]);
    return d;
}

+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key
{
    return nil;
}

+ (NSString *)customBase64EncodedStringFromData:(id)data
{
    if ([data isKindOfClass:[NSData class]]) {
        data = [NSString stringWithUTF8String:[(NSData *)data bytes]];
    }
    
    JSValue *func = [self context][@"base64_encode"];
    JSValue *res = [func callWithArguments:@[data]];
    return [res toString];
}

@end
