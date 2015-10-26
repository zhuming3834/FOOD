//
//  SubjectDetailModel.h
//  CGYFood-v2
//
//  Created by qf on 9/21/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectDetailModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *edittime;
@property (nonatomic, copy) NSString *effect;
@property (nonatomic, copy) NSString *likes;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *thumb_2;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *views;

+(NSMutableArray *)setObjectWithArray:(NSArray *)array;
+(SubjectDetailModel *)setObjectWithDictionary:(NSDictionary *)dic;
@end
