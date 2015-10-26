//
//  HealthyListTableViewCell.m
//  CGYFood-v2
//
//  Created by qf on 9/17/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "HealthyListTableViewCell.h"

@interface HealthyListTableViewCell ()
@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) UILabel *myTitleLabel;

@end

@implementation HealthyListTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCellView];
    }
    return self;
}
#pragma mark --- 
-(void)setCellWithModel:(HealthyListModel *)model withNumber:(NSInteger)index{
    _headLabel.text = [NSString stringWithFormat:@"%ld", ++index];
    _myTitleLabel.text = model.title;
}


#pragma mark --- 设置Cell
-(void)setCellView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _headLabel = [[UILabel alloc]init];
    _myTitleLabel = [[UILabel alloc]init];
    _headLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _myTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_headLabel];
    [self addSubview:_myTitleLabel];
    
    //设置headLabel
    _headLabel.layer.masksToBounds = YES;
    _headLabel.layer.cornerRadius = 16;
    _headLabel.backgroundColor = COLOR(69, 188, 51, 1);
    _headLabel.textColor = [UIColor whiteColor];
    _headLabel.font = [UIFont boldSystemFontOfSize:14];
    _headLabel.textAlignment = NSTextAlignmentCenter;
    NSArray *headArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_headLabel(32)]" options:0 metrics:nil views:@{@"_headLabel":_headLabel}];
    NSArray *headArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_headLabel(32)]" options:0 metrics:nil views:@{@"_headLabel":_headLabel}];
    [self addConstraints:headArray1];
    [self addConstraints:headArray2];
    
    //设置titleLabel
    _myTitleLabel.font = [UIFont systemFontOfSize:16];
    NSArray *titleArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_headLabel]-8-[_myTitleLabel]-28-|" options:0 metrics:nil views:@{@"_myTitleLabel":_myTitleLabel,@"_headLabel":_headLabel}];
    NSArray *titleArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_myTitleLabel(20)]" options:0 metrics:nil views:@{@"_myTitleLabel":_myTitleLabel}];
    [self addConstraints:titleArray1];
    [self addConstraints:titleArray2];
}

@end
