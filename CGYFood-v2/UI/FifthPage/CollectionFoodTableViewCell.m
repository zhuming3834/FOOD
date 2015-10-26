//
//  CollectionFoodTableViewCell.m
//  CGYFood-v2
//
//  Created by qf on 9/21/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "CollectionFoodTableViewCell.h"

@interface CollectionFoodTableViewCell()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *myTitleLabel;
@property (nonatomic, strong) UILabel *effectLabel;

@end

@implementation CollectionFoodTableViewCell

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

#pragma mark --- 设置CellView
-(void)setCellView{
    //图片
    _headImageView = [[UIImageView alloc]init];
    _headImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_headImageView];
    NSArray *headArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[_headImageView(100)]" options:0 metrics:nil views:@{@"_headImageView":_headImageView}];
    [self addConstraints:headArray];
    headArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_headImageView(60)]" options:0 metrics:nil views:@{@"_headImageView":_headImageView}];
    [self addConstraints:headArray];
    
    //标题
    _myTitleLabel = [[UILabel alloc]init];
    _myTitleLabel.font = [UIFont systemFontOfSize:16];
    _myTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_myTitleLabel];
    NSArray *titleArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_headImageView]-8-[_myTitleLabel]-20-|" options:0 metrics:nil views:@{@"_headImageView":_headImageView,@"_myTitleLabel":_myTitleLabel}];
    [self addConstraints:titleArray];
    titleArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_myTitleLabel(20)]" options:0 metrics:nil views:@{@"_myTitleLabel":_myTitleLabel}];
    [self addConstraints:titleArray];
    
    //功效
    _effectLabel = [[UILabel alloc]init];
    _effectLabel.font = [UIFont systemFontOfSize:14];
    _effectLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_effectLabel];
    NSArray *errectArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_headImageView]-8-[_effectLabel]-20-|" options:0 metrics:nil views:@{@"_headImageView":_headImageView,@"_effectLabel":_effectLabel}];
    [self addConstraints:errectArray];
    errectArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_myTitleLabel]-10-[_effectLabel(20)]" options:0 metrics:nil views:@{@"_effectLabel":_effectLabel,@"_myTitleLabel":_myTitleLabel}];
    [self addConstraints:errectArray];
}

#pragma mark --- 绑定Cell数据
-(void)setCellWithDic:(NSDictionary *)dic{
    [_headImageView setImageWithURL:[NSURL URLWithString:dic[@"image"]] placeholderImage:[UIImage imageNamed:@"loading-image.png"]];
    _myTitleLabel.text = dic[@"title"];
    _effectLabel.text = dic[@"effect"];
}

@end
