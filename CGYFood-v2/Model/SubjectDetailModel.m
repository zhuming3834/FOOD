//
//  SubjectDetailModel.m
//  CGYFood-v2
//
//  Created by qf on 9/21/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "SubjectDetailModel.h"

@implementation SubjectDetailModel

+(NSMutableArray *)setObjectWithArray:(NSArray *)array{
    NSMutableArray *modelArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in array) {
        SubjectDetailModel *model = [SubjectDetailModel setObjectWithDictionary:dic];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(SubjectDetailModel *)setObjectWithDictionary:(NSDictionary *)dic{
    SubjectDetailModel *model = [[SubjectDetailModel alloc]init];
    model.ID = dic[@"ID"];
    model.age = dic[@"age"];
    model.category = dic[@"category"];
    model.edittime = dic[@"edittime"];
    model.effect = dic[@"effect"];
    model.likes = dic[@"likes"];
    model.thumb = dic[@"thumb"];
    model.title = dic[@"title"];
    model.views = dic[@"views"];
    return model;
}

@end
