//
//  HealthyDetailViewController.m
//  CGYFood-v2
//
//  Created by qf on 9/19/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "CollectionHealthyDetailViewController.h"

@interface CollectionHealthyDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CollectionHealthyDetailViewController

-(void)viewDidDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

-(void)viewWillAppear:(BOOL)animated{
    NAVIGATION_BACK_BUTTON
}

-(void)buttonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
    if (_html.length > 0) {
        [self setWebViewWithString:_html];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- webview
-(void)setWebViewWithString:(NSString *)str{
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
    _webView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [_webView loadHTMLString:str baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]resourcePath]]];
    [self.view addSubview:_webView];
}

#pragma mark --- 设置webView协议
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}

@end
