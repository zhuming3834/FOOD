//
//  CGYLoading.m
//  CGYFood-v2
//
//  Created by qf on 9/28/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "CGYLoading.h"

@interface CGYLoading ()
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, assign) CGPoint mainPoint;

@end

@implementation CGYLoading

+(CGYLoading *)defaultLoadingWithCenter:(CGPoint)point{
    static CGYLoading *loading = nil;
    if (!loading) {
        loading = [[CGYLoading alloc]init];
        loading.mainPoint = point;
    }
    [loading show];
    return loading;
}

-(void)show{
    _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activity.center = _mainPoint;
    [_activity startAnimating];
    [self addSubview:_activity];
}

+(void)dismiss{
    CGYLoading *load = [CGYLoading defaultLoadingWithCenter:(CGPoint){0,0}];
    load.activity.hidden = YES;
    [load.activity stopAnimating];
    [load.activity removeFromSuperview];
}

@end
