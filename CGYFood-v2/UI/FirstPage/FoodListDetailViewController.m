//
//  FoodListDetailViewController.m
//  CGYFood-v2
//
//  Created by qf on 9/15/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "FoodListDetailViewController.h"

@interface FoodListDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *rightButton;//收藏按钮
@property (nonatomic, copy) NSMutableString *htmlString;//显示的网页
@property (nonatomic, assign) BOOL isCollection;//是否处于收藏状态

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *myTitle;
@property (nonatomic, copy) NSString *effect;
@property (nonatomic, copy) NSString *image;

@end

@implementation FoodListDetailViewController

-(void)viewDidDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInit];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- 初始化
-(void)setInit{
    self.view.backgroundColor = [UIColor whiteColor];
    _htmlString = [[NSMutableString alloc]init];
    if (_foodModel) {
        _ID = _foodModel.ID;
        _myTitle = _foodModel.title;
        _effect = _foodModel.effect;
        _image = _foodModel.thumb;
    } else if (_subjectDetailModel) {
        _ID = _subjectDetailModel.ID;
        _myTitle = _subjectDetailModel.title;
        _effect = _subjectDetailModel.effect;
        _image = _subjectDetailModel.thumb;
    } else if (_contentDic) {
        _ID = _contentDic[@"ID"];
        _myTitle = _contentDic[@"title"];
        _effect = _contentDic[@"effect"];
        _image = _contentDic[@"image"];
    }
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
    NAVIGATION_TITLE(@"详细做法")
    NAVIGATION_BACK_BUTTON
    NAVIGATION_COLLECTION_BUTTON(_rightButton)
    //判断当前是否属于收藏状态
    CGYDB *db = [[CGYDB alloc]init];
    [db openDatabaseWithName:DB];
    NSArray *array = [db select:TABLE_FOOD withWhere:[NSDictionary dictionaryWithObject:_ID forKey:@"ID"]];
    [db closeDatabase];
    if (array.count > 0) {
        _rightButton.tintColor = [UIColor yellowColor];
        _isCollection = YES;
    } else {
        _rightButton.tintColor = [UIColor whiteColor];
        _isCollection = NO;
    }
}

//获取当前时间
TIME_NOW

//返回
NAVIGATION_BACK_BUTTON_CLICK

#pragma mark --- 收藏点击事件
-(void)collectionButtonClick:(UIButton *)button{
    CGYDB *db = [[CGYDB alloc]init];
    [db openDatabaseWithName:DB];
    NSArray *array = [db select:TABLE_FOOD withWhere:[NSDictionary dictionaryWithObject:_ID forKey:@"ID"]];
    if (_isCollection) {
        if (array.count > 0) {
            [db del:TABLE_FOOD withWhere:[NSDictionary dictionaryWithObject:_ID forKey:@"ID"]];
            _isCollection = NO;
            [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
        }
        _rightButton.tintColor = [UIColor whiteColor];
    } else {
        if (array.count == 0) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:_ID forKey:@"ID"];
            [dic setObject:_myTitle forKey:@"title"];
            [dic setObject:_image forKey:@"image"];
            [dic setObject:_effect forKey:@"effect"];
            [dic setObject:_htmlString forKey:@"content"];
            [dic setObject:[self getTime] forKey:@"createTime"];
            [db insertInto:TABLE_FOOD WithDictionary:dic];
            _isCollection = YES;
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        }
        _rightButton.tintColor = [UIColor yellowColor];
    }
    [db closeDatabase];
}

#pragma mark --- 获取数据
-(void)getData{
    [NetWork getDetailDataWithURL:URL_DETAIL withID:_ID getData:^(NSString *str) {
        if (str.length > 0) {
            [self setContentWithString:str];
            NSLog(@"%@", str);
        }
    } error:^(NSString *str) {
        [SVProgressHUD dismissWithError:@"加载失败\n请检查网络后重试!" afterDelay:1.5];
    }];
}

#pragma mark --- 内容字符串处理
-(void)setContentWithString:(NSString *)content{

    //分割字符串得到内容
    NSArray *array1 = [content componentsSeparatedByString:@"<div data-role=\"content\">"];
    NSArray *array2 = [array1[1] componentsSeparatedByString:@"<div class=\"dtit\">相关菜谱"];
    NSString *contentStr = array2[0];
    
    //去掉收藏按钮
    contentStr = [CGYRegex subStringToString:contentStr withMyStr:@"" withRegex:@"<a[\\s\\S]*?href=\"bookmark://.*?收藏</a>"];
    contentStr = [CGYRegex subStringToString:contentStr withMyStr:@"<img class=\"lazy\" src=\"loading-image.png\" data-original" withRegex:@"<img[\\s\\S]*?src"];
    
    //拼接显示的HTML
    [_htmlString appendString:WEB_HEAD];
    [_htmlString appendString:contentStr];
    [_htmlString appendString:WEB_FOOT];
    
    //设置webView
    if (_contentDic) {
        [self setWebViewWithString:_contentDic[@"content"]];
    } else {
        [self setWebViewWithString:_htmlString];
    }
}

#pragma mark --- 设置webview
-(void)setWebViewWithString:(NSString *)str{
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
    [[_webView subviews][0] setBounces:NO];//关闭弹簧
    [[_webView subviews][0] setShowsHorizontalScrollIndicator:NO];//关闭横向
    _webView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [_webView loadHTMLString:str baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]resourcePath]]];
    [self.view addSubview:_webView];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_webView stringByEvaluatingJavaScriptFromString: @"document.documentElement.style.webkitUserSelect='none';"];
    [SVProgressHUD dismiss];
}

@end
