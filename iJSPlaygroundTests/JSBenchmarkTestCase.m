//
//  JSBenchmarkTestCase.m
//  iJSPlayground
//
//  Created by Taras Kalapun on 26/03/14.
//  Copyright (c) 2014 Kalapun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AZBenchmarkTestCase.h>

#import <JavaScriptCore/JavaScriptCore.h>

@interface JSBenchmarkTestCase : AZBenchmarkTestCase
@end

@implementation JSBenchmarkTestCase

- (void)benchNSMutableArray
{
    NSMutableArray *array = NSMutableArray.new;
    int n = 500;
    for (int i=0;i<n;i++) {
        NSString *s = [NSString stringWithFormat:@"data #%i", i];
        [array addObject:s];
    }
}

- (void)benchJSMutableArray
{
    JSContext *context = JSContext.new;
    
    [context evaluateScript:
     @"var array = [];"
     @"var n = 500;"
     @"for (var i=0;i<n;i++) {"
     @"  var s = 'data #' + i;"
     @"  array.push(s);"
     @"}"
     ];
}

- (void)benchJSMutableArray2
{
    static JSContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[JSContext alloc] init];
    });
    
    [context evaluateScript:
     @"var array = [];"
     @"var n = 500;"
     @"for (var i=0;i<n;i++) {"
     @"  var s = 'data #' + i;"
     @"  array.push(s);"
     @"}"
     ];
}


@end
