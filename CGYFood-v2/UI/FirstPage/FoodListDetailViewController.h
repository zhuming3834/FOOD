//
//  FoodListDetailViewController.h
//  CGYFood-v2
//
//  Created by qf on 9/15/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodListModel.h"
#import "SubjectDetailModel.h"

@interface FoodListDetailViewController : UIViewController
@property (nonatomic, strong) FoodListModel *foodModel;
@property (nonatomic, strong) SubjectDetailModel *subjectDetailModel;
@property (nonatomic, strong) NSDictionary *contentDic;//详情页的内容

@end
