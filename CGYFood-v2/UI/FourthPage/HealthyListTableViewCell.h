//
//  HealthyListTableViewCell.h
//  CGYFood-v2
//
//  Created by qf on 9/17/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthyListModel.h"

@interface HealthyListTableViewCell : UITableViewCell
-(void)setCellWithModel:(HealthyListModel *)model withNumber:(NSInteger)index;
@end
