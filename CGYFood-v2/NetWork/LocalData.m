//
//  LocalData.m
//  CGYFood-v2
//
//  Created by qf on 9/23/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "LocalData.h"

@implementation LocalData

#pragma mark --- 美食列表数据
+(void)writeFoodListDataWithArray:(NSArray *)array{
    if (array.count == 0) {
        return;
    }
    CGYDB *db = [[CGYDB alloc]init];
    BOOL open = [db openDatabaseWithName:DB];
    if (open) {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *arr = [db select:TABLE_FOODDATA withWhere:[NSDictionary dictionaryWithObject:obj[@"ID"] forKey:@"ID"]];
            if (arr.count > 0) {
                [db update:TABLE_FOODDATA WithSetValue:obj withWhere:[NSDictionary dictionaryWithObject:obj[@"ID"] forKey:@"ID"]];
            } else {
                [db insertInto:TABLE_FOODDATA WithDictionary:obj];
            }
        }];
        [db closeDatabase];
    }
}

#pragma mark --- 读取美食列表数据
+(NSArray *)readFoodListData{
    NSArray *array = nil;
    CGYDB *db = [[CGYDB alloc]init];
    [db openDatabaseWithName:DB];
    array = [db select:TABLE_FOODDATA withWhere:nil page:@"" pageSize:@"" orderBy:@"sid" desc:YES];
    [db closeDatabase];
    return array;
}

#pragma mark --- 保存专题数据
+(void)writeSubjectDataWithArray:(NSArray *)array{
    if (array.count == 0) return;
    CGYDB *db = [[CGYDB alloc]init];
    BOOL open = [db openDatabaseWithName:DB];
    if (open) {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *selectArray = [db select:TABLE_SUBJECT withWhere:[NSDictionary dictionaryWithObject:obj[@"ID"] forKey:@"ID"]];
            if (selectArray.count > 0) {
                [db update:TABLE_SUBJECT WithSetValue:obj withWhere:[NSDictionary dictionaryWithObject:obj[@"ID"] forKey:@"ID"]];
            } else {
                [db insertInto:TABLE_SUBJECT WithDictionary:obj];
            }
        }];
        [db closeDatabase];
    }
}

#pragma mark --- 读取专题数据
+(NSArray *)readSubjectData{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    CGYDB *db = [[CGYDB alloc]init];
    BOOL open = [db openDatabaseWithName:DB];
    if (open) {
        [array setArray:[db select:TABLE_SUBJECT withWhere:nil page:@"" pageSize:@"" orderBy:@"sid" desc:YES]];
        [db closeDatabase];
    }
    return array;
}

@end
