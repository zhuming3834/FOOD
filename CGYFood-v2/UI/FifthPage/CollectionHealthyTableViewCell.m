//
//  CollectionHealthyTableViewCell.m
//  CGYFood-v2
//
//  Created by qf on 9/19/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "CollectionHealthyTableViewCell.h"

@interface CollectionHealthyTableViewCell ()
@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) UILabel *firstTitleLabel;

@end

@implementation CollectionHealthyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCellView];
    }
    return self;
}

#pragma mark --- 设置值
-(void)setCellWithTitle:(NSString *)title index:(NSInteger)index{
    _headLabel.text = [NSString stringWithFormat:@"%ld",++index];
    _firstTitleLabel.text = title;
}

#pragma mark --- 设置UI
-(void)setCellView{
    _headLabel = [[UILabel alloc]init];
    _headLabel.layer.masksToBounds = YES;
    _headLabel.layer.cornerRadius = 16;
    _headLabel.backgroundColor = COLOR(69, 188, 51, 1);
    _headLabel.textColor = [UIColor whiteColor];
    _headLabel.font = [UIFont boldSystemFontOfSize:14];
    _headLabel.textAlignment = NSTextAlignmentCenter;
    _headLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_headLabel];
    NSArray *headArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_headLabel(32)]" options:0 metrics:nil views:@{@"_headLabel":_headLabel}];
    NSArray *headArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_headLabel(32)]" options:0 metrics:nil views:@{@"_headLabel":_headLabel}];
    [self addConstraints:headArray1];
    [self addConstraints:headArray2];
    
    //标题
    _firstTitleLabel = [[UILabel alloc]init];
    _firstTitleLabel.font = [UIFont systemFontOfSize:16];
    _firstTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_firstTitleLabel];
    NSArray *titleArray_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_headLabel]-10-[_firstTitleLabel]-20-|" options:0 metrics:nil views:@{@"_headLabel":_headLabel,@"_firstTitleLabel":_firstTitleLabel}];
    NSArray *titleArray_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_firstTitleLabel(20)]" options:0 metrics:nil views:@{@"_firstTitleLabel":_firstTitleLabel}];
    [self addConstraints:titleArray_H];
    [self addConstraints:titleArray_V];
}

@end
