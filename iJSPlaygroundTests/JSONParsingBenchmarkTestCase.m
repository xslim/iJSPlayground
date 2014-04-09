//
//  JSONParsingBenchmarkTestCase.m
//  iJSPlayground
//
//  Created by Taras Kalapun on 09/04/14.
//  Copyright (c) 2014 Kalapun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AZBenchmarkTestCase.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSONParsingBenchmarkTestCase : AZBenchmarkTestCase

@end

@implementation JSONParsingBenchmarkTestCase

- (void)benchOCParser
{
    static NSData *jsonData;
    static dispatch_once_t onceTokenD;
    dispatch_once(&onceTokenD, ^{
        NSString *path =[[NSBundle bundleForClass:[self class]] pathForResource:@"product" ofType:@"json"];
        jsonData = [NSData dataWithContentsOfFile:path];
    });
    
    NSError *error = nil;
    NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    XCTAssertNotNil(parsedData[@"name"], @"Should have name");
}

- (void)benchJSParser
{
    static JSContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[JSContext alloc] init];
        [context evaluateScript:@"function parser(str){ return JSON.parse(str); }"];
    });
    
    static NSString *jsonString;
    static dispatch_once_t onceTokenD;
    dispatch_once(&onceTokenD, ^{
        NSString *path =[[NSBundle bundleForClass:[self class]] pathForResource:@"product" ofType:@"json"];
        jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    });
    
    JSValue *func = context[@"parser"];
    JSValue *res = [func callWithArguments:@[jsonString]];
    NSDictionary *parsedData = [res toDictionary];
    
    XCTAssertNotNil(parsedData[@"name"], @"Should have name");
}

@end
