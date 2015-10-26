//
//  HealthyListModel.m
//  CGYFood-v2
//
//  Created by qf on 9/17/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "HealthyListModel.h"

@implementation HealthyListModel
+(NSMutableArray *)setObjectWithArray:(NSArray *)array{
    NSMutableArray *modelArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in array) {
        HealthyListModel *model = [HealthyListModel setObjectWithDictionary:dic];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(HealthyListModel *)setObjectWithDictionary:(NSDictionary *)dic{
    HealthyListModel *model = [[HealthyListModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
@end
