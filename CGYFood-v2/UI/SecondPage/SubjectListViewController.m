//
//  SubjectListViewController.m
//  CGYFood-v2
//
//  Created by qf on 9/16/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "SubjectListViewController.h"
#import "SubjectListTableViewCell.h"
#import "FoodListDetailViewController.h"
#import "SubjectDetailModel.h"

@interface SubjectListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *mainView;//headerView
@property (nonatomic, strong) UIImageView *myImageView;//大图
@property (nonatomic, strong) UILabel *myTitleLabel;//标题
@property (nonatomic, strong) TQRichTextView *descLabel;//简介

@end

@implementation SubjectListViewController

-(void)viewDidDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInit];
    [self getData];
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- 初始化
-(void)setInit{
    NAVIGATION_BACK_BUTTON
    NAVIGATION_TITLE(@"列表")
    _dataArray = [[NSMutableArray alloc]init];
}

NAVIGATION_BACK_BUTTON_CLICK

#pragma mark --- 获取数据
-(void)getData{
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
    [NetWork getSubjectListWithURL:URL_SUBJECT_LIST ID:_ID getData:^(NSDictionary *dic) {
        if (dic.count > 0) {
            [self setHeadView];
            
            //大图
            [_myImageView setImageWithURL:[NSURL URLWithString:dic[@"thumb"]] placeholderImage:[UIImage imageNamed:@""]];
            //标题
            _myTitleLabel.text = dic[@"title"];
            //描述
            _descLabel.text = dic[@"jianjie"];
            
            CGRect r = _descLabel.frame;
            r.size.height = _descLabel.drawheigth;
            _descLabel.frame = r;
            CGRect r2 = _mainView.frame;
            r2.size.height += _descLabel.drawheigth + 6;
            _mainView.frame = r2;
            _tableView.tableHeaderView = _mainView;
            
            
            if ([dic[@"tlist"] count] > 0 ) {
                if ([dic[@"tlist"][0] count] > 0) {
                    if ([dic[@"tlist"][0][@"list"] count] > 0) {
                        [_dataArray setArray:[SubjectDetailModel setObjectWithArray:dic[@"tlist"][0][@"list"]]];
                    }
                }
            }
            [_tableView reloadData];
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD dismissWithError:@"加载失败\n请检查网络后重试!" afterDelay:1.5];
        }
    } error:^(NSString *str) {
        [_tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        [_tableView footerEndRefreshing];
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败\n请检查网络后重试!" duration:1.5];
    }];
}

#pragma mark --- 设置tableView
-(void)setTableView{
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    
    //设置约束
    NSArray *tableViewArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    NSArray *tableViewArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    [self.view addConstraints:tableViewArray1];
    [self.view addConstraints:tableViewArray2];
}

#pragma mark --- 设置headerView
-(void)setHeadView{
    //headerView
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 180)];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, WIDTH, 30)];
    _myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 180)];
    _myTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, WIDTH-20, 20)];
    _descLabel = [[TQRichTextView alloc]initWithFrame:CGRectMake(10, 184, WIDTH-20, 0)];
    
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.textColor = [UIColor grayColor];
    _descLabel.font = [UIFont systemFontOfSize:14];
    _myTitleLabel.font = [UIFont systemFontOfSize:14];
    _myTitleLabel.textColor = [UIColor whiteColor];
    bgView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.65];
    [bgView addSubview:_myTitleLabel];
    [_myImageView addSubview:bgView];
    [_mainView addSubview:_myImageView];
    [_mainView addSubview:_descLabel];

}

#pragma mark --- tableView协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SubjectListCell";
    SubjectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SubjectListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        [cell setCellWithDic:_dataArray[indexPath.row]];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FoodListDetailViewController *fvc = [[FoodListDetailViewController alloc]init];
    fvc.subjectDetailModel = _dataArray[indexPath.row];
    [self.navigationController pushViewController:fvc animated:YES];
}


@end
