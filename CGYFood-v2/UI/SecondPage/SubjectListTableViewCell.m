//
//  SubjectListTableViewCell.m
//  CGYFood-v2
//
//  Created by qf on 9/17/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "SubjectListTableViewCell.h"

@interface SubjectListTableViewCell ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *firstTitleLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *effectLabel;

@end

@implementation SubjectListTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setInitView];
    }
    return self;
}

#pragma mark --- 给Cell赋值
-(void)setCellWithDic:(SubjectDetailModel *)model{
    [_headImageView setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"loading-image.png"]];
    _firstTitleLabel.text = model.title;
    _categoryLabel.text = model.category;
    _ageLabel.text = model.age;
    _effectLabel.text = model.effect;
}

#pragma mark --- 设置UI
-(void)setInitView{
     self.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    _headImageView = [[UIImageView alloc]init];
    _firstTitleLabel = [[UILabel alloc]init];
    _categoryLabel = [[UILabel alloc]init];
    _ageLabel = [[UILabel alloc]init];
    _effectLabel = [[UILabel alloc]init];
    _headImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _firstTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _ageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _effectLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_headImageView];
    [self addSubview:_firstTitleLabel];
    [self addSubview:_categoryLabel];
    [self addSubview:_ageLabel];
    [self addSubview:_effectLabel];
    
    //图片约束
    NSArray *headArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_headImageView(100)]" options:0 metrics:nil views:@{@"_headImageView":_headImageView}];
    NSArray *headArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_headImageView(60)]" options:0 metrics:nil views:@{@"_headImageView":_headImageView}];
    [self addConstraints:headArray1];
    [self addConstraints:headArray2];
    
    //标题约束
    _firstTitleLabel.font = [UIFont systemFontOfSize:14];
    _firstTitleLabel.textColor = COLOR(124, 183, 70, 1);
    NSArray *titleArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_headImageView]-10-[_firstTitleLabel]-26-|" options:0 metrics:nil views:@{@"_firstTitleLabel":_firstTitleLabel,@"_headImageView":_headImageView}];
    NSArray *titleArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_firstTitleLabel(18)]" options:0 metrics:nil views:@{@"_firstTitleLabel":_firstTitleLabel}];
    [self addConstraints:titleArray1];
    [self addConstraints:titleArray2];
    
    //类型约束
    _categoryLabel.font = [UIFont systemFontOfSize:12];
    _categoryLabel.textColor = [UIColor grayColor];
    NSArray *categoryArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_headImageView]-10-[_categoryLabel]-26-|" options:0 metrics:nil views:@{@"_categoryLabel":_categoryLabel,@"_headImageView":_headImageView}];
    NSArray *categoryArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_firstTitleLabel]-0-[_categoryLabel(14)]" options:0 metrics:nil views:@{@"_categoryLabel":_categoryLabel,@"_firstTitleLabel":_firstTitleLabel}];
    [self addConstraints:categoryArray1];
    [self addConstraints:categoryArray2];
    
    //年龄约束
    _ageLabel.font = [UIFont systemFontOfSize:12];
    _ageLabel.textColor = [UIColor grayColor];
    NSArray *ageArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_headImageView]-10-[_ageLabel]-26-|" options:0 metrics:nil views:@{@"_ageLabel":_ageLabel,@"_headImageView":_headImageView}];
    NSArray *ageArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_categoryLabel]-0-[_ageLabel(14)]" options:0 metrics:nil views:@{@"_categoryLabel":_categoryLabel,@"_ageLabel":_ageLabel}];
    [self addConstraints:ageArray1];
    [self addConstraints:ageArray2];
    
    //功效约束
    _effectLabel.font = [UIFont systemFontOfSize:12];
    _effectLabel.textColor = [UIColor grayColor];
    NSArray *effectArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_headImageView]-10-[_effectLabel]-26-|" options:0 metrics:nil views:@{@"_effectLabel":_effectLabel,@"_headImageView":_headImageView}];
    NSArray *effectArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_ageLabel]-0-[_effectLabel(14)]" options:0 metrics:nil views:@{@"_ageLabel":_ageLabel,@"_effectLabel":_effectLabel}];
    [self addConstraints:effectArray1];
    [self addConstraints:effectArray2];
}

@end
