//
//  CGYRegex.m
//  CGYFood-v2
//
//  Created by qf on 9/15/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "CGYRegex.h"

@implementation CGYRegex

#pragma mark ----------------------------------------------------------------- 正则提取子串
+(NSString *)subStringWithString:(NSString *)string withRegex:(NSString *)regexString{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:0 error:&error];
    if (error != nil) {
        NSLog(@"%@", error);
        return NULL;
    }
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            //从String当中截取数据
            NSString *result=[string substringWithRange:resultRange];
            //返回结果
            return  result;
        }
    }
    return NULL;
}

#pragma mark ----------------------------------------------------------------- 正则替换
+(NSString *)subStringToString:(NSString *)str withMyStr:(NSString *)str2 withRegex:(NSString *)regexString{
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:0
                                                                             error:&error];
    NSString* result = [regex stringByReplacingMatchesInString:str
                                                       options:0
                                                         range:NSMakeRange(0, str.length)
                                                  withTemplate:str2];
    return result;
}


@end
