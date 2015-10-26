//
//  SubjectTableViewCell.m
//  CGYFood-v2
//
//  Created by qf on 9/16/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "SubjectTableViewCell.h"

@interface SubjectTableViewCell ()
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *myTitleLabel;

@end

@implementation SubjectTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //获取屏幕尺寸
        CGRect mainFrame = [[UIScreen mainScreen] bounds];
        
        //大图
        _myImageView = [[UIImageView alloc]init];
        _myImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        //背景图1
        _bgView= [[UIImageView alloc]init];
        _bgView.backgroundColor = [UIColor redColor];
        _bgView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.65];
        _bgView.translatesAutoresizingMaskIntoConstraints = NO;
        
        //标题
        _myTitleLabel = [[UILabel alloc]init];
        _myTitleLabel.font = [UIFont systemFontOfSize:14];
        _myTitleLabel.textColor = [UIColor whiteColor];
        _myTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_myImageView];
        [_myImageView addSubview:_bgView];
        [_bgView addSubview:_myTitleLabel];
        
        //给imageview设置约束
        NSString *hStr = [NSString stringWithFormat:@"H:|-8-[_myImageView(%f)]", mainFrame.size.width - 16];
        NSString *vStr = [NSString stringWithFormat:@"V:|-8-[_myImageView(%d)]", 180 - 16];
        NSArray *imageArray1 = [NSLayoutConstraint constraintsWithVisualFormat:hStr options:0 metrics:nil views:@{@"_myImageView":_myImageView}];
        NSArray *imageArray2 = [NSLayoutConstraint constraintsWithVisualFormat:vStr options:0 metrics:nil views:@{@"_myImageView":_myImageView}];
        [self addConstraints:imageArray1];
        [self addConstraints:imageArray2];
    
        
        //背景图
        NSArray *bgArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bgView]-0-|" options:0 metrics:nil views:@{@"_bgView":_bgView}];
        NSArray *bgArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bgView(30)]-0-|" options:0 metrics:nil views:@{@"_bgView":_bgView}];
        [_myImageView addConstraints:bgArray1];
        [_myImageView addConstraints:bgArray2];
        
        //标题
        NSArray *titleArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[_myTitleLabel]-6-|" options:0 metrics:nil views:@{@"_myTitleLabel":_myTitleLabel}];
        NSArray *titleArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_myTitleLabel(18)]" options:0 metrics:nil views:@{@"_myTitleLabel":_myTitleLabel}];
        [_bgView addConstraints:titleArray1];
        [_bgView addConstraints:titleArray2];
    }
    return self;
}

-(void)setCellWithModel:(SubjectModel *)model{
    [_myImageView setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"loading-image.png"]];
    _myTitleLabel.text = model.title;
}

@end
