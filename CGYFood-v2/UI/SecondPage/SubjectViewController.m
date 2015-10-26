//
//  SubjectViewController.m
//  CGYFood-v2
//
//  Created by qf on 9/16/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "SubjectViewController.h"
#import "SubjectTableViewCell.h"
#import "SubjectListViewController.h"
#import "SubjectModel.h"

@interface SubjectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
//@property (nonatomic, assign) BOOL reloadData;

@end

@implementation SubjectViewController

-(void)viewWillAppear:(BOOL)animated{
    
}

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
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
    _page = 1;
    _dataArray = [[NSMutableArray alloc]init];
    
    //发送网络请求之前、读取本地数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [LocalData readSubjectData];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:obj];
            [dic removeObjectForKey:@"sid"];
            [_dataArray addObject:[SubjectModel setObjectWithDictionary:dic]];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

#pragma mark --- 获取数据
-(void)getData{
    NSString *page = [NSString stringWithFormat:@"%ld", (long)_page];
    NSString *pageSize = @"20";
    NSString *order = @"views";
    [NetWork getSubjectDataWithURL:URL_SUBJECT page:page pageSize:pageSize order:order getData:^(NSDictionary *dic){
        if ([dic[@"results"] count] > 0) {
            if ([dic[@"results"][0] count] > 0) {
                //-----------------------------数据保存到本地-----------------------------
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [LocalData writeSubjectDataWithArray:dic[@"results"]];
                });
                
                if (_page == 1) {
                    [_dataArray setArray:[SubjectModel setObjectWithArray:dic[@"results"]]];
                } else {
                    for (SubjectModel *model in [SubjectModel setObjectWithArray:dic[@"results"]]) {
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    
    //设置约束
    NSArray *tableViewArray1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    NSArray *tableViewArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-49-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    [self.view addConstraints:tableViewArray1];
    [self.view addConstraints:tableViewArray2];
 
    //下拉刷新
    __block SubjectViewController *mySelf = self;
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

#pragma mark --- tableView协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    SubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SubjectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        [cell setCellWithModel:_dataArray[indexPath.row]];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SubjectListViewController *slvc = [[SubjectListViewController alloc]init];
    slvc.ID = [_dataArray[indexPath.row] ID];
    [self.navigationController pushViewController:slvc animated:YES];
}


@end
