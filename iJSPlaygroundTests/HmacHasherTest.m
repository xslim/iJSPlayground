//
//  HmacHasherTest.m
//  iJSPlayground
//
//  Created by Taras Kalapun on 01/04/14.
//  Copyright (c) 2014 Kalapun. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "OCHasher.h"
#include "JSHasher.h"

@interface HmacHasherTest : XCTestCase

@end

@implementation HmacHasherTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (NSString *)timestamp {
    static NSString *t;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //t = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
        t = @"1234567890";
    });
    return t;
}

//- (void)testBase64Equality
//{
//    NSData *data = [@"4b9f8ea7daa03c4ed5c5c15846a73acfd3632cab" dataUsingEncoding:NSASCIIStringEncoding];
//    
//    NSString *b1 = [OCHasher customBase64EncodedStringFromData:data];
//    NSString *b2 = [JSHasher customBase64EncodedStringFromData:data];
//    
//    XCTAssertEqualObjects(b1, b2, @"Base64 should equal: %@ = %@", b1, b2);
//}

- (void)testHmacEquality
{
    NSString *data = @"4b9f8ea7daa03c4ed5c5c15846a73acfd3632cab";
    
    NSData *d1 = [OCHasher data_hmacsha1:data secret:@"secretKey"];
    NSData *d2 = [JSHasher data_hmacsha1:data secret:@"secretKey"];
    
    XCTAssertEqualObjects(d1, d2, @"NmacSha1 should equal");
}

- (void)testJSHasherGeneratesTimestamp
{
    NSString *hash2 = [JSHasher calculateAuthHeaderWithTokenId:@"tokenId"
                                                         token:@"token"
                                                     accessKey:@"accessKey"
                                                     secretKey:@"secretKey"
                                                    apiVersion:@"1"
                                                     timestamp:nil];
    XCTAssertNotNil(hash2, @"Should work");
}

- (void)testHasherEquality
{
    NSString *hash1 = [OCHasher calculateAuthHeaderWithTokenId:@"tokenId"
                                                         token:@"token"
                                                     accessKey:@"accessKey"
                                                     secretKey:@"secretKey"
                                                    apiVersion:@"1"
                                                     timestamp:[self timestamp]];
    
    
    NSString *hash2 = [JSHasher calculateAuthHeaderWithTokenId:@"tokenId"
                                                         token:@"token"
                                                     accessKey:@"accessKey"
                                                     secretKey:@"secretKey"
                                                    apiVersion:@"1"
                                                     timestamp:[self timestamp]];
    
    XCTAssertEqualObjects(hash1, hash2, @"Hashes should equal: %@ = %@", hash1, hash2);
}


@end
