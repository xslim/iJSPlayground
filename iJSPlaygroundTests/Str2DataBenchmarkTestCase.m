//
//  Str2DataBenchmarkTestCase.m
//  iJSPlayground
//
//  Created by Taras Kalapun on 01/04/14.
//  Copyright (c) 2014 Kalapun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AZBenchmarkTestCase.h>

@interface Str2DataBenchmarkTestCase : AZBenchmarkTestCase

@end

@implementation Str2DataBenchmarkTestCase

static NSString *testString = @"f783bb53da69c9b5d533a9a5ad921a58e2ad9cdf";

- (void)benchAppend
{
    NSMutableData *d= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [testString length]/2; i++) {
        byte_chars[0] = [testString characterAtIndex:i*2];
        byte_chars[1] = [testString characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [d appendBytes:&whole_byte length:1];
    }
    
    NSData *data = d;
    if (data.length == 0) {
        NSLog(@"problem.");
    }
}

- (void)benchScan
{
    char const *chars = testString.UTF8String;
    NSUInteger charCount = strlen(chars);
    if (charCount % 2 != 0) {
        return;
    }
    NSUInteger byteCount = charCount / 2;
    uint8_t *bytes = malloc(byteCount);
    for (int i = 0; i < byteCount; ++i) {
        unsigned int value;
        sscanf(chars + i * 2, "%2x", &value);
        bytes[i] = value;
    }
    
    NSData *data = [NSData dataWithBytesNoCopy:bytes length:byteCount freeWhenDone:YES];
    if (data.length == 0) {
        NSLog(@"problem.");
    }
}

@end
