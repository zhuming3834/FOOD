//
//  FoodListViewController.m
//  CGYFood-v2
//
//  Created by qf on 9/15/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "FoodListViewController.h"
#import "FoodListTableViewCell.h"
#import "FoodListDetailViewController.h"
#import "FoodListModel.h"

@interface FoodListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation FoodListViewController

-(void)viewWillAppear:(BOOL)animated{
    if (_dic.count > 0) {
        NAVIGATION_TITLE(_dic[@"name"])
        NAVIGATION_BACK_BUTTON
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInit];
    [self setTableView];
    [self loadLocalData];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

NAVIGATION_BACK_BUTTON_CLICK

#pragma mark --- 初始化
-(void)setInit{
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
    _page = 1;
    _dataArray = [[NSMutableArray alloc]init];
}

#pragma mark --- 读取本地数据
-(void)loadLocalData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *arr = [LocalData readFoodListData];
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:obj];
            [dic removeObjectForKey:@"sid"];
            [_dataArray addObject:[FoodListModel setObjectWithDictionary:dic]];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
           [_tableView reloadData];
        });
    });
}

#pragma mark --- 获取数据
-(void)getData{
    NSString *keyWords = nil;
    if (_dic.count > 0) {
        keyWords = [NSString stringWithFormat:@"%@=%@", _dic[@"type"], _dic[@"name"]];
    } else {
        keyWords = @"keywords=推荐";
    }
    NSString *page = [NSString stringWithFormat:@"%ld", (long)_page];
    NSString *pageSize = @"20";
    NSString *order = @"addtime";
    [NetWork getFoodListDataWithURL:URL_FOOD_LIST keyWords:keyWords page:page pageSize:pageSize order:order getData:^(NSDictionary *dic) {
        if ([dic[@"results"] count] > 0) {
            //子线程，把数据缓存到本地
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [LocalData writeFoodListDataWithArray:dic[@"results"]];
            });
            
            if (_page == 1) {
                [_dataArray setArray:[FoodListModel setObjectWithArray:dic[@"results"]]];
            } else {
                for (FoodListModel *model in [FoodListModel setObjectWithArray:dic[@"results"]]) {
                    [_dataArray addObject:model];
                }
            }
            //收起下拉刷新
            [_tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
            //收起上拉加载更多
            [_tableView footerEndRefreshing];
            //刷新tableView
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

#pragma mark --- 设置setTableView
-(void)setTableView{
    _tableView = [[UITableView alloc]init];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"FoodListTableViewCell" bundle:nil] forCellReuseIdentifier:@"FoodListCell"];
    [self.view addSubview:_tableView];
    
    //设置约束
    NSString *vStr = nil;
    if (_dic.count > 0) {
        vStr = @"V:|-0-[_tableView]-0-|";
    } else {
        vStr = @"V:|-0-[_tableView]-49-|";
    }
    NSArray *tableViewArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    NSArray *tableViewArray2 = [NSLayoutConstraint constraintsWithVisualFormat:vStr options:0 metrics:nil views:@{@"_tableView":_tableView}];
    [self.view addConstraints:tableViewArray1];
    [self.view addConstraints:tableViewArray2];
    
    //下拉刷新
    __block FoodListViewController *mySelf = self;
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

#pragma mark --- TableView协议方法(显示Cell)
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifir = @"FoodListCell";
    FoodListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifir];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FoodListTableViewCell" owner:self options:nil]firstObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        [cell setCellWithModel:_dataArray[indexPath.row]];
    }
    return cell;
}

#pragma mark --- TableView协议方法(行数)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

#pragma mark --- TableView协议方法(行高)
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark --- TableView协议方法(选中)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FoodListDetailViewController *detailVC = [[FoodListDetailViewController alloc]init];
    detailVC.foodModel = _dataArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
