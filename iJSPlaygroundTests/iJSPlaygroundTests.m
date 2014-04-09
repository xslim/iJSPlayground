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
#import "BLCProduct.h"

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

- (void)testObject
{
    JSContext *context = JSContext.new;
    [context evaluateScript:@"var console = {}"];
    context[@"console"][@"log"] = ^(NSString *msg) {
        NSLog(@"JS: %@", msg);
    };
    
    
    BLCProduct *product = BLCProduct.new;
    product.name = @"I'm product";
    
    [context evaluateScript:@"function dumpp(p){ console.log('Product name: '+p.name);}"];
    JSValue *func = context[@"dumpp"];
    [func callWithArguments:@[product]];
}

extern void RHJSContextMakeClassAvailable(JSContext *context, Class class){
    NSString *className = NSStringFromClass(class);
    context[className] = class;
    //[context evaluateScript:[NSString stringWithFormat:@"console.log(%@.constructor+' - '+%@.prototype +' - '+%@.prototype.constructor);", className, className, className]];
    //context[[NSString stringWithFormat:@"__%@", className]] = (id) ^(void){ return [[class alloc] init]; };
    //[context evaluateScript:[NSString stringWithFormat:@"var %@ = function (){ this.prototype = %@.prototype; return __%@();};", className, className, className]];
    
    //[context evaluateScript:[NSString stringWithFormat:@"var %@ = function(){ return __%@();};", className, className]];
    
    //allow a class to perform other setup upon being loaded into a context.
//    SEL selector = NSSelectorFromString(@"classWasMadeAvailableInContext:");
//    if ([class respondsToSelector:selector]){
//        ((void (*)(id, SEL, JSContext*))[class methodForSelector:selector])(class, selector, context);
//    }
}

- (void)testObject2
{
    JSContext *context = JSContext.new;
    [context evaluateScript:@"var console = {}"];
    context[@"console"][@"log"] = ^(NSString *msg) {
        NSLog(@"JS: %@", msg);
    };
    
    
    BLCProduct *product = BLCProduct.new;
    product.name = @"I'm product";
    
    RHJSContextMakeClassAvailable(context, BLCProduct.class);
    
    
    [context evaluateScript:@"function dumpo(o){ var x = BLCProduct.new(); console.log(Object.getOwnPropertyNames(x.prototype)); }"];
    [context evaluateScript:@"function createo(o){ var x; try{x = BLCProduct.new();}catch(err){console.log(err)} x.name='xxx'; console.log(x.detail); return x; }"];
    JSValue *func = context[@"dumpo"];
    [func callWithArguments:@[BLCProduct.class]];
    
    
    
    JSValue *func2 = context[@"createo"];
    JSValue *res = [func2 callWithArguments:@[BLCProduct.class]];
    NSLog(@"res: %@", res);
}

@end
