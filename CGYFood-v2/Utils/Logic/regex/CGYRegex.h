//
//  CGYRegex.h
//  CGYFood-v2
//
//  Created by qf on 9/15/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGYRegex : NSObject
//提取字符串
+(NSString *)subStringWithString:(NSString *)string withRegex:(NSString *)regexString;
//替换字符串
+(NSString *)subStringToString:(NSString *)str withMyStr:(NSString *)str2 withRegex:(NSString *)regexString;
@end
