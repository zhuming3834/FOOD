//
//  HealthyListViewController.m
//  CGYFood-v2
//
//  Created by qf on 9/17/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "HealthyListViewController.h"
#import "HealthyListTableViewCell.h"
#import "HealthyListModel.h"
#import "HealthyDetailViewController.h"

@interface HealthyListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) JHRefreshAmazingAniView *aniView;

@end

@implementation HealthyListViewController

-(void)viewDidDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInit];
    [self getData];
    [self setnavigation];
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark --- 设置导航
-(void)setnavigation{
    NAVIGATION_TITLE(_name)
    NAVIGATION_BACK_BUTTON
}
NAVIGATION_BACK_BUTTON_CLICK

#pragma mark --- 初始化
-(void)setInit{
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
    _dataArray = [[NSMutableArray alloc]init];
    _page = 1;
}

#pragma mark --- 获取数据
-(void)getData{
    NSString *page = [NSString stringWithFormat:@"%ld", _page];
    NSString *pageSize = @"20";
    [NetWork getHealthyListDataWithURL:URL_HEALTHY_LIST tags:_name page:page pageSize:pageSize getData:^(NSDictionary *dic) {
        //当前页
        NSInteger total = _page * [pageSize integerValue];
        if (total > [dic[@"totalCount"] integerValue]) {
            
        }
        
        if (dic.count > 0) {
            if (_page == 1) {
                [_dataArray setArray:[HealthyListModel setObjectWithArray:dic[@"results"]]];
            } else {
                for (HealthyListModel *model in [HealthyListModel setObjectWithArray:dic[@"results"]]) {
                    [_dataArray addObject: model];
                }
            }
            //收起下拉刷新
            [_tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
            //收起上拉加载更多
            [_tableView footerEndRefreshing];
            //刷新tableView
            [_tableView reloadData];
            [SVProgressHUD dismiss];
        }
    } error:^(NSString *str) {
        [_tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        [_tableView footerEndRefreshing];
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败\n请检查网络后重试!" duration:1.5];
    }];
    
}

#pragma mark --- 设置setTableView
-(void)setTableView{
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    
    //设置约束
    NSArray *hArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    NSArray *vArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    [self.view addConstraints:hArray];
    [self.view addConstraints:vArray];
    
    //下拉刷新
    __block HealthyListViewController *mySelf = self;
    [_tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        mySelf.page = 1;
        [mySelf getData];
    }];
    
    //上拉获取更多
    [_tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        mySelf.page ++;
        [mySelf getData];
    }];
}

#pragma mark --- TableView协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifir = @"HealthyListCell";
    HealthyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifir];
    if (!cell) {
        cell = [[HealthyListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifir];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        [cell setCellWithModel:_dataArray[indexPath.row] withNumber:indexPath.row];
    }
    return cell;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
//cell被点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HealthyDetailViewController *hdvc = [[HealthyDetailViewController alloc]init];
    hdvc.model = _dataArray[indexPath.row];
    [self.navigationController pushViewController:hdvc animated:YES];
}



@end
