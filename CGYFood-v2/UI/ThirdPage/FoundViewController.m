//
//  FoundViewController.m
//  CGYFood-v2
//
//  Created by qf on 9/15/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "FoundViewController.h"
#import "FoundTableViewCell.h"
#import "FoodListViewController.h"

@interface FoundViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *titleForHeaderArray;//组头数据
@end

@implementation FoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- 获取数据
-(void)getData{
    _dataArray = [[NSMutableArray alloc]init];
    _titleForHeaderArray = [[NSMutableArray alloc]init];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"findFood" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil][0];
    for (NSDictionary *key in dic) {
        [_titleForHeaderArray addObject:key];
        [_dataArray addObject:dic[key]];
    }
}

#pragma mark --- 设置setTableView
-(void)setTableView{
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"FoundTableViewCell" bundle:nil] forCellReuseIdentifier:@"FoundCell"];
    [self.view addSubview:_tableView];
    
    //设置约束
    NSArray *hArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    NSArray *vArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-49-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    [self.view addConstraints:hArray];
    [self.view addConstraints:vArray];
}

#pragma mark --- TableView协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifir = @"FoundCell";
    FoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifir];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FoundTableViewCell" owner:self options:nil]firstObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellWithDic:_dataArray[indexPath.section][indexPath.row]];
    return cell;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section] count];
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
//组头
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _titleForHeaderArray[section];
}
//cell被点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FoodListViewController *fvc = [[FoodListViewController alloc]init];
    fvc.dic = _dataArray[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:fvc animated:YES];
}


@end
