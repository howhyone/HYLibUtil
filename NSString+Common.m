//
//  NSString+Common.m
//  HYOCoding
//
//  Created by mob on 2019/4/14.
//  Copyright © 2019年 mob. All rights reserved.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Common)

-(BOOL)isPhoneNum
{
    NSString *phoneNum = @"[0-8]{1,15}";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNum];
    return [phonePredicate evaluateWithObject:phoneNum];
}

- (NSString*) sha1Str
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
