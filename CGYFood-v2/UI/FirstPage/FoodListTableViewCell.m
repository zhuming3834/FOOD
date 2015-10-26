//
//  FoodListTableViewCell.m
//  CGYFood-v2
//
//  Created by qf on 9/15/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "FoodListTableViewCell.h"

@interface FoodListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *effectLabel;

@end

@implementation FoodListTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCellWithModel:(FoodListModel *)model{
    [_headImageView setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"loading-image.png"]];
     _firstTitleLabel.text = model.title;
     _categoryLabel.text = model.category;
     _peopleLabel.text = model.age;
     _effectLabel.text = model.effect;
}

@end
