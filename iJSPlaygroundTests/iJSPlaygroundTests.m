//
//  iJSPlaygroundTests.m
//  iJSPlaygroundTests
//
//  Created by Taras Kalapun on 26/03/14.
//  Copyright (c) 2014 Kalapun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "JSHasher.h"

@interface iJSPlaygroundTests : XCTestCase

@end

@implementation iJSPlaygroundTests

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

- (void)testConsoleLog
{
    JSContext *context = JSContext.new;
    
    [context evaluateScript:@"var console = {}"];
    context[@"console"][@"log"] = ^(NSString *msg) {
        NSLog(@"JS: %@", msg);
    };
    
    [context evaluateScript:@"console.log('message!');"];
    
}

- (void)testBrowserify
{
    JSContext *context = [JSHasher context];
    
    JSValue *ping = context[@"ping"];
    JSValue *pingResult = [ping callWithArguments:@[]];
    NSLog(@"Ping: %@", [pingResult toString]);
    
    
    //bl_gen_token(token, tokenId, accessKey, secretKey, apiVersion)
    JSValue *bl_gen_token = context[@"bl_gen_token"];
    NSArray *args = @[@"token", @"tokenId", @"accessKey", @"secretKey", @"1", @"1234567890"];
    JSValue *res = [bl_gen_token callWithArguments:args];
    NSLog(@"bl_gen_token: %@", [res toString]);
}

@end
