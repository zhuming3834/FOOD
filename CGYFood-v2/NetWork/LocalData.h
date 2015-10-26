//
//  LocalData.h
//  CGYFood-v2
//
//  Created by qf on 9/23/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalData : NSObject

#pragma mark --- 保存美食列表数据
+(void)writeFoodListDataWithArray:(NSArray *)array;
#pragma mark --- 读取美食列表数据
+(NSArray *)readFoodListData;


#pragma mark --- 保存专题数据
+(void)writeSubjectDataWithArray:(NSArray *)array;
#pragma mark --- 读取专题数据
+(NSArray *)readSubjectData;

@end
