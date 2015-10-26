//
//  SubjectListTableViewCell.h
//  CGYFood-v2
//
//  Created by qf on 9/17/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectDetailModel.h"

@interface SubjectListTableViewCell : UITableViewCell
-(void)setCellWithDic:(SubjectDetailModel *)model;
@end
