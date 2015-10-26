//
//  SubjectModel.m
//  CGYFood-v2
//
//  Created by qf on 9/16/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "SubjectModel.h"

@implementation SubjectModel
+(NSMutableArray *)setObjectWithArray:(NSArray *)array{
    NSMutableArray *modelArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in array) {
        SubjectModel *model = [SubjectModel setObjectWithDictionary:dic];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(SubjectModel *)setObjectWithDictionary:(NSDictionary *)dic{
    SubjectModel *model = [[SubjectModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
@end
