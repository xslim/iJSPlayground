//
//  OCHasher.m
//  iJSPlayground
//
//  Created by Taras Kalapun on 31/03/14.
//  Copyright (c) 2014 Kalapun. All rights reserved.
//

#import "OCHasher.h"

#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>


@implementation OCHasher

+ (NSString *)calculateAuthHeaderWithTokenId:(NSString *)tokenId
                                       token:(NSString *)token
                                   accessKey:(NSString *)accessKey
                                   secretKey:(NSString *)secretKey
                                  apiVersion:(NSString *)apiVersion
                                   timestamp:(NSString *)timestamp
{
    NSString *baseSignature = [secretKey stringByAppendingString:timestamp];
    
    //Generate base header
    NSString *header = [NSString stringWithFormat:@"%@ k=\"%@\",tm=\"%@\"", tokenId, accessKey, timestamp];
    if (token.length > 0) {
        header = [header stringByAppendingFormat:@",t=\"%@\"", token];
        baseSignature = [baseSignature stringByAppendingString:token];
    }
    
    //Calculate signature
    NSString *signature = [self hmacsha1:baseSignature secret:secretKey];
    
    //Add signature to header
    header = [header stringByAppendingFormat:@",s=\"%@\"", signature];
    
    
    //Add API version
    header = [header stringByAppendingFormat:@",v=\"%@\"", apiVersion];
    
    return header;
}


+ (NSString *)calculateAuthHeaderWithTokenId:(NSString *)tokenId
                                       token:(NSString *)token
                                   accessKey:(NSString *)accessKey
                                   secretKey:(NSString *)secretKey
                                  apiVersion:(NSString *)apiVersion
{
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    return [self calculateAuthHeaderWithTokenId:tokenId token:token accessKey:accessKey secretKey:secretKey apiVersion:apiVersion timestamp:timestamp];
}

+ (NSData *)data_hmacsha1:(NSString *)data secret:(NSString *)key
{
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];;
}

+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key
{
    NSData *HMAC = [self data_hmacsha1:data secret:key];
    
    NSString *hash = [self customBase64EncodedStringFromData:HMAC];
    
    return hash;
}


+ (NSString *)customBase64EncodedStringFromData:(NSData *)data
{
    NSInteger wrapWidth = 0;
    //ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;
    
    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
    
    NSUInteger inputLength = [data length];
    const unsigned char *inputBytes = [data bytes];
    
    NSUInteger maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) * 2: 0;
    unsigned char *outputBytes = (unsigned char *)malloc(maxOutputLength);
    
    NSUInteger i;
    NSUInteger outputLength = 0;
    for (i = 0; i < inputLength - 2; i += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
        {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        //outputBytes[outputLength++] =   '=';
    }
    else if (i == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        //outputBytes[outputLength++] = '=';
        //outputBytes[outputLength++] = '=';
    }
    
    if (outputLength >= 4)
    {
        //truncate data to match actual output length
        outputBytes = realloc(outputBytes, outputLength);
        return [[NSString alloc] initWithBytesNoCopy:outputBytes
                                              length:outputLength
                                            encoding:NSASCIIStringEncoding
                                        freeWhenDone:YES];
    }
    else if (outputBytes)
    {
        free(outputBytes);
    }
    return nil;
}

@end
