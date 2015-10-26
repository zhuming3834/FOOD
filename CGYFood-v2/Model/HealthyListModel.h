//
//  HealthyListModel.h
//  CGYFood-v2
//
//  Created by qf on 9/17/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthyListModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *tags;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *views;

+(NSMutableArray *)setObjectWithArray:(NSArray *)array;
+(HealthyListModel *)setObjectWithDictionary:(NSDictionary *)dic;
@end
