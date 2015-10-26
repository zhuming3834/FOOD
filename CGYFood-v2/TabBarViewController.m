//
//  TabBarViewController.m
//  CGYFood-v2
//
//  Created by qf on 9/12/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = COLOR(118, 183, 87, 1);
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"热门美食";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag%100) {
        case 1:
        {
            self.navigationItem.title = @"美食推荐";
        }
            break;
            
        case 2:
        {
            self.navigationItem.title = @"美食分类";
        }
            break;
            
        case 3:
        {
            self.navigationItem.title = @"美食专题";
        }
            break;
        case 4:
        {
            self.navigationItem.title = @"健康常识";
        }
            break;
            
        case 5:
        {
            self.navigationItem.title = @"我的收藏";
        }
            break;
            
        default:
            break;
    }
}


@end
