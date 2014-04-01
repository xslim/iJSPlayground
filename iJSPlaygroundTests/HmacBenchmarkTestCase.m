//
//  HmacBenchmarkTestCase.m
//  iJSPlayground
//
//  Created by Taras Kalapun on 31/03/14.
//  Copyright (c) 2014 Kalapun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AZBenchmarkTestCase.h>

#import <JavaScriptCore/JavaScriptCore.h>

#include "OCHasher.h"
#include "JSHasher.h"

@interface HmacBenchmarkTestCase : AZBenchmarkTestCase

@end

@implementation HmacBenchmarkTestCase

- (NSString *)timestamp {
    static NSString *t;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //t = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
        t = @"1234567890";
    });
    return t;
}

static NSString *testDataString = @"4b9f8ea7daa03c4ed5c5c15846a73acfd3632cab";


- (void)benchOCHmac
{
    NSData *d = [OCHasher data_hmacsha1:testDataString secret:@"secretKey"];
    XCTAssertNotNil(d, @"Should hmac");
}

- (void)benchJSHmac
{
    NSData *d = [JSHasher data_hmacsha1:testDataString secret:@"secretKey"];
    XCTAssertNotNil(d, @"Should hmac");
}


- (void)benchOCHasher
{
    NSString *hash = [OCHasher calculateAuthHeaderWithTokenId:@"tokenId"
                                                        token:@"token"
                                                    accessKey:@"accessKey"
                                                    secretKey:@"secretKey"
                                                   apiVersion:@"1"
                                                    timestamp:[self timestamp]];
    
    if (hash.length == 0) {
        NSLog(@"Problem :(");
    }
}

- (void)benchJSHasher
{
    NSString *hash = [JSHasher calculateAuthHeaderWithTokenId:@"tokenId"
                                                        token:@"token"
                                                    accessKey:@"accessKey"
                                                    secretKey:@"secretKey"
                                                   apiVersion:@"1"
                                                    timestamp:[self timestamp]];
    
    if (hash.length == 0) {
        NSLog(@"Problem :(");
    }
}


- (void)benchJSHmacDyn
{
    JSContext *context = [JSHasher context];
    JSValue *func = context[@"base64_encode"];
    
    [func callWithArguments:@[testDataString]];
}

- (void)benchJSHmacStat
{
    static JSValue *func;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JSContext *context = [JSHasher context];
        func = context[@"base64_encode"];
    });
    
    [func callWithArguments:@[testDataString]];
}

@end
