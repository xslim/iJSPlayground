//
//  JSHasher.h
//  iJSPlayground
//
//  Created by Taras Kalapun on 31/03/14.
//  Copyright (c) 2014 Kalapun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSContext;
@interface JSHasher : NSObject

+ (JSContext *)context;

+ (NSString *)calculateAuthHeaderWithTokenId:(NSString *)tokenId
                                       token:(NSString *)token
                                   accessKey:(NSString *)accessKey
                                   secretKey:(NSString *)secretKey
                                  apiVersion:(NSString *)apiVersion
                                   timestamp:(NSString *)timestamp;

+ (NSData *)data_hmacsha1:(NSString *)data secret:(NSString *)key;
+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key;
+ (NSString *)customBase64EncodedStringFromData:(id)data;

@end
