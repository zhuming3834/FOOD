//
//  FoodListTableViewCell.h
//  CGYFood-v2
//
//  Created by qf on 9/15/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodListModel.h"

@interface FoodListTableViewCell : UITableViewCell
-(void)setCellWithModel:(FoodListModel *)model;
@end
