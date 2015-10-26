//
//  SubjectModel.h
//  CGYFood-v2
//
//  Created by qf on 9/16/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *jianjie;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,copy) NSString *views;
@property (nonatomic,copy) NSString *likes;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *edittime;

+(NSMutableArray *)setObjectWithArray:(NSArray *)array;
+(SubjectModel *)setObjectWithDictionary:(NSDictionary *)dic;
@end
