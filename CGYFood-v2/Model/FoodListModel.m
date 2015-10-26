//
//  FoodListModel.m
//  CGYFood-v2
//
//  Created by qf on 9/15/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "FoodListModel.h"

@implementation FoodListModel

+(NSMutableArray *)setObjectWithArray:(NSArray *)array{
    NSMutableArray *modelArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in array) {
        FoodListModel *model = [FoodListModel setObjectWithDictionary:dic];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(FoodListModel *)setObjectWithDictionary:(NSDictionary *)dic{
    FoodListModel *model = [[FoodListModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end
