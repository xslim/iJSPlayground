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

#import "BLCProduct.h"

@interface JSONParsingBenchmarkTestCase : AZBenchmarkTestCase

@end

@implementation JSONParsingBenchmarkTestCase

static NSData *jsonData;
static NSString *jsonString;
static NSData *jsonDataA;
static NSString *jsonStringA;
static JSContext *context;


+ (void)setUp {
    NSString *path =[[NSBundle bundleForClass:[self class]] pathForResource:@"product" ofType:@"json"];
    jsonData = [NSData dataWithContentsOfFile:path];
    jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSString *pathA =[[NSBundle bundleForClass:[self class]] pathForResource:@"products" ofType:@"json"];
    jsonDataA = [NSData dataWithContentsOfFile:pathA];
    jsonStringA = [NSString stringWithContentsOfFile:pathA encoding:NSUTF8StringEncoding error:nil];
    
    context = [[JSContext alloc] init];
    [context evaluateScript:@"function parser(str){ return JSON.parse(str); }"];
    
    [context evaluateScript:@"var console = {}"];
    context[@"console"][@"log"] = ^(NSString *msg) {
        NSLog(@"JS: %@", msg);
    };
    
    for (NSString *file in @[@"mapper"]) {
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:file ofType:@"js"];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        if (content) {
            [context evaluateScript:content];
        }
    }
    
    context[@"BLCProduct"] = BLCProduct.class;
}

- (void)benchOCParser
{
    NSError *error = nil;
    id parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    XCTAssertNotNil(parsedData, @"Should not be nil");
}

- (void)benchJSParser
{
    JSValue *func = context[@"parser"];
    JSValue *res = [func callWithArguments:@[jsonString]];
    NSDictionary *parsedData = [res toDictionary];
    
    XCTAssertNotNil(parsedData[@"name"], @"Should not be nil");
}

- (void)benchM1_Mantle
{
    NSError *error = nil;
    NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    BLCProduct *product = [MTLJSONAdapter modelOfClass:[BLCProduct class] fromJSONDictionary:parsedData error:&error];
    XCTAssertNotNil(product.name, @"Should not be nil");
}

- (void)benchM1_JS
{
    JSValue *func = context[@"mapJSON2Object"];
    JSValue *res = [func callWithArguments:@[jsonString, @"BLCProduct", [BLCProduct JSONKeyPathsByPropertyKey]]];
    BLCProduct *product = [res toObject];
    
    XCTAssertNotNil(product.name, @"Should not be nil");
}

- (void)benchMA_Mantle
{
    NSError *error = nil;
    NSArray *parsedArray = [NSJSONSerialization JSONObjectWithData:jsonDataA options:kNilOptions error:&error];
    NSMutableArray *objects = [NSMutableArray array];
    for (NSDictionary *parsedData in parsedArray) {
        id parsedObject = [MTLJSONAdapter modelOfClass:[BLCProduct class] fromJSONDictionary:parsedData error:&error];
        [objects addObject:parsedObject];
    }
    XCTAssertNotNil(objects[1], @"Should not be nil");
}

- (void)benchMA_JS
{
    JSValue *func = context[@"mapJSON2Object"];
    JSValue *res = [func callWithArguments:@[jsonStringA, @"BLCProduct", [BLCProduct JSONKeyPathsByPropertyKey]]];
    NSArray *parsedObject = [res toArray];
    
    XCTAssertNotNil(parsedObject[1], @"Should not be nil");
}

@end
