//
//  HealthyDetailViewController.m
//  CGYFood-v2
//
//  Created by qf on 9/17/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "HealthyDetailViewController.h"

@interface HealthyDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *rightbutton;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL isCollection;//是否已经收藏

@end

@implementation HealthyDetailViewController

-(void)viewDidDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_TITLE(_model.title)
    NAVIGATION_BACK_BUTTON
}

NAVIGATION_BACK_BUTTON_CLICK

TIME_NOW

#pragma mark --- 重写收藏按钮点击事件
-(void)collectionButtonClick:(UIButton *)button{
    CGYDB *db = [[CGYDB alloc]init];
    [db openDatabaseWithName:DB];
    NSArray *array = [db select:TABLE_HEALTHY withWhere:[NSDictionary dictionaryWithObject:_model.ID forKey:@"ID"]];
    if (array.count > 0) {
        _rightbutton.tintColor = [UIColor whiteColor];
        [db del:TABLE_HEALTHY withWhere:[NSDictionary dictionaryWithObject:_model.ID forKey:@"ID"]];
        [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
    } else {
        _rightbutton.tintColor = [UIColor yellowColor];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:_model.ID forKey:@"ID"];
        [dic setObject:_model.title forKey:@"title"];
        [dic setObject:_content forKey:@"content"];
        [dic setObject:[self getTime] forKey:@"createTime"];
        [db insertInto:TABLE_HEALTHY WithDictionary:dic];
        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
    }
    [db closeDatabase];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- 数据库操作
-(void)dbAction{
    CGYDB *db = [[CGYDB alloc]init];
    [db openDatabaseWithName:DB];
    NSArray *array = [db select:TABLE_HEALTHY withWhere:[NSDictionary dictionaryWithObject:_model.ID forKey:@"ID"]];
    if (array.count > 0) {
        _rightbutton.tintColor = [UIColor yellowColor];
        _isCollection = YES;
    } else {
        _rightbutton.tintColor = [UIColor whiteColor];
        _isCollection = NO;
    }
    [db closeDatabase];
}

#pragma mark --- 获取数据
-(void)getData{
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];    
    [NetWork getHealthyDetailDataWithURL:URL_HEALTHY_DETAIL ID:_model.ID getData:^(NSString *str) {
        NSString *string = [str componentsSeparatedByString:@"<div style='margin:10px 20px;'>"][1];
        _content = [NSString stringWithFormat:@"%@%@%@", WEB_HEAD,WEB_TITLE(_model.title),string];
        [self setWebViewWithString:_content];
    } error:^(NSString *str) {
        [SVProgressHUD dismissWithError:@"加载失败\n请检查网络后重试!" afterDelay:1.5];
    }];
}

#pragma mark --- webview
-(void)setWebViewWithString:(NSString *)str{
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
    [[_webView subviews][0] setBounces:NO];//关闭弹簧
    _webView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [_webView loadHTMLString:str baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]resourcePath]]];
    [self.view addSubview:_webView];
}

#pragma mark --- 设置webView协议
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    [_webView stringByEvaluatingJavaScriptFromString: @"document.documentElement.style.webkitUserSelect='none';"];
    
    //************************************************************************
    //          数据加载完成后再显示收藏按钮，防止程序闪退
    NAVIGATION_COLLECTION_BUTTON(_rightbutton)
    [self dbAction];
    //************************************************************************
}
@end
