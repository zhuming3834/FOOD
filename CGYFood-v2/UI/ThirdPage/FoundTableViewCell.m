//
//  FoundTableViewCell.m
//  CGYFood-v2
//
//  Created by qf on 9/15/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "FoundTableViewCell.h"

@interface FoundTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstTitleLabel;

@end

@implementation FoundTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCellWithDic:(NSDictionary *)dic{
    [_headImageView setImage:[UIImage imageNamed:dic[@"image"]]];
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height/2;
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.borderColor = [COLOR(240, 240, 240, 1)CGColor];
    _headImageView.layer.masksToBounds = YES;
    _firstTitleLabel.text = dic[@"name"];
}

@end
