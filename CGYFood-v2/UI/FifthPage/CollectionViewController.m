//
//  CollectionViewController.m
//  CGYFood-v2
//
//  Created by qf on 9/18/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionHealthyTableViewCell.h"
#import "CollectionHealthyDetailViewController.h"
#import "CollectionFoodTableViewCell.h"
#import "FoodListDetailViewController.h"

@interface CollectionViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *tableView;//tableView
@property (nonatomic, strong) UISegmentedControl *segement;//分段控制器
@property (nonatomic, strong) NSMutableArray *healthyArray;//健康常识数据
@property (nonatomic, strong) NSMutableArray *foodArray;//美食
@property (nonatomic, strong) UIButton *deleteButton;//删除按钮
@property (nonatomic, strong) UIAlertView *alert;//提示框
@property (nonatomic, strong) UILabel *emptyLabel;

@end

@implementation CollectionViewController

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBadgeValue) name:@"changeBadgeValue" object:nil];
    [self setSegement];
    [self setDeleteButton];
    [self getData];
    [self dataEmpty];
}

-(void)viewDidDisappear:(BOOL)animated{
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.titleView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- 修改 BadgeValue
-(void)changeBadgeValue{
    self.tabBarItem.badgeValue = @"1";
}

#pragma mark --- 获取数据
-(void)getData{
    _healthyArray = [[NSMutableArray alloc]init];
    _foodArray = [[NSMutableArray alloc]init];
    
    //数据库操作
    CGYDB *db = [[CGYDB alloc]init];
    [db openDatabaseWithName:DB];
    _healthyArray = [db select:TABLE_HEALTHY withWhere:nil];
    _foodArray = [db select:TABLE_FOOD withWhere:nil];
    [db closeDatabase];
    [_tableView reloadData];
}

#pragma mark --- 设置分段控制器
-(void)setSegement{
    _segement = [[UISegmentedControl alloc]initWithItems:@[@"美食",@"常识"]];
    _segement.center = CGPointMake(self.navigationController.navigationBar.frame.size.width/2,
                                   self.navigationController.navigationBar.frame.size.height/2);
    _segement.bounds = CGRectMake(0, 0, 120, 28);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:@"selectedSegmentIndex"];
    if (str.length > 0) {
        _segement.selectedSegmentIndex = [str integerValue];
    } else {
        _segement.selectedSegmentIndex = 0;
    }
    _segement.tintColor = [UIColor whiteColor];
    [_segement addTarget:self action:@selector(segementChange) forControlEvents:UIControlEventValueChanged];
    self.tabBarController.navigationItem.titleView = _segement;
    [_tableView reloadData];
}

#pragma mark --- 分段控制器点击事件
-(void)segementChange{
    //记录当前选中的状态
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[NSString stringWithFormat:@"%ld", _segement.selectedSegmentIndex] forKey:@"selectedSegmentIndex"];
    [user synchronize];
    [self dataEmpty];
    //刷新数据
    [_tableView reloadData];
}

#pragma mark --- 清空按钮
-(void)setDeleteButton{
    _deleteButton = [[UIButton alloc]init];
    _deleteButton.frame = (CGRect){0, 0, 44, 44};
    [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[UIImage imageNamed:@"btn-trash.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _deleteButton.tintColor = [UIColor whiteColor];
    [_deleteButton setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:_deleteButton];
    [self.tabBarController.navigationItem setRightBarButtonItem:barButton];
}

#pragma mark --- 清空按钮点击事件
-(void)deleteButtonClick:(UIButton *)button{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:@"selectedSegmentIndex"];
    NSString *message = nil;
    if ([str isEqualToString:@"0"]) {
        message = @"确认清空美食收藏列表？";
    } else {
        message = @"确认清空常识收藏列表？";
    }
    _alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [_alert show];
}

#pragma mark --- alert协议方法
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *str = [user objectForKey:@"selectedSegmentIndex"];
        CGYDB *db = [[CGYDB alloc]init];
        [db openDatabaseWithName:DB];
        if ([str isEqualToString:@"0"]) {//美食列表
            BOOL del = [db del:TABLE_FOOD withWhere:nil];
            if (del) {
                [_foodArray removeAllObjects];
            }
        } else {//常识列表
            BOOL del = [db del:TABLE_HEALTHY withWhere:nil];
            if (del) {
                [_healthyArray removeAllObjects];
            }
        }
        [_tableView reloadData];
        [db closeDatabase];
    }
    [self dataEmpty];
}

#pragma mark --- 设置tableView
-(void)settableview{
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    
    //设置约束
    NSArray *tableviewArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    [self.view addConstraints:tableviewArray];
    tableviewArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-49-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    [self.view addConstraints:tableviewArray];
}

#pragma mark --- tableView协议方法（显示Cell）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //美食收藏
    if (_segement.selectedSegmentIndex == 0) {
        static NSString *identifir = @"CollectionFoodCell";
        CollectionFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifir];
        if (!cell) {
            cell = [[CollectionFoodTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifir];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_foodArray.count > 0) {
            [cell setCellWithDic:_foodArray[indexPath.row]];
        }
        return cell;
    } else {
    //常识收藏
        static NSString *identifir = @"CollectionHealthyCell";
        CollectionHealthyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifir];
        if (!cell) {
            cell = [[CollectionHealthyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifir];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_healthyArray.count > 0) {
            [cell setCellWithTitle:_healthyArray[indexPath.row][@"title"] index:indexPath.row];
        }
        return cell;
    }
}

#pragma mark --- tableView协议方法（行数）
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _segement.selectedSegmentIndex == 0 ? _foodArray.count : _healthyArray.count;
}

#pragma mark --- tableView协议方法（行高）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _segement.selectedSegmentIndex == 0 ? 70 : 48;
}

#pragma mark --- tableView协议方法（点击）
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segement.selectedSegmentIndex == 0) {
        FoodListDetailViewController *detail = [[FoodListDetailViewController alloc]init];
        detail.contentDic = _foodArray[indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    } else if (_segement.selectedSegmentIndex == 1) {
        CollectionHealthyDetailViewController *detail = [[CollectionHealthyDetailViewController alloc]init];
        detail.html = _healthyArray[indexPath.row][@"content"];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark --- tableView协议方法（编辑状态）
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark --- tableView协议方法（删除操作）
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_segement.selectedSegmentIndex == 0) {//删除收藏的美食
            CGYDB *db = [[CGYDB alloc]init];
            BOOL open = [db openDatabaseWithName:DB];
            if (open) {
                BOOL del = [db del:TABLE_FOOD withWhere:[NSDictionary dictionaryWithObject:_foodArray[indexPath.row][@"ID"] forKey:@"ID"]];
                [db closeDatabase];
                if (del) {
                    [_foodArray removeObjectAtIndex:indexPath.row];
                    [_tableView reloadData];
                    [SVProgressHUD showSuccessWithStatus:@"删除成功!" duration:1.3];
                }
            }
            
        } else if (_segement.selectedSegmentIndex == 1) {//删除收藏的常识
            CGYDB *db = [[CGYDB alloc]init];
            [db openDatabaseWithName:DB];
            BOOL ret = [db del:TABLE_HEALTHY withWhere:[NSDictionary dictionaryWithObject:_healthyArray[indexPath.row][@"ID"] forKey:@"ID"]];
            [db closeDatabase];
            if (ret){
                [_healthyArray removeObjectAtIndex:indexPath.row];
                [_tableView reloadData];
                [SVProgressHUD showSuccessWithStatus:@"删除成功!" duration:1.3];
            }
        }
        [self dataEmpty];
    }
}

#pragma mark --- 判断当前数据是否为空
-(void)dataEmpty{
    if (_segement.selectedSegmentIndex == 0) {
        if (_foodArray.count == 0) {
            _tableView.hidden = YES;
            [self showEmptyMessage];
        } else {
            if (_emptyLabel) {
                [_emptyLabel removeFromSuperview];
            }
            _tableView.hidden = NO;
        }
    }
    if (_segement.selectedSegmentIndex == 1) {
        if (_healthyArray.count == 0) {
            _tableView.hidden = YES;
            [self showEmptyMessage];
        } else {
            if (_emptyLabel) {
                [_emptyLabel removeFromSuperview];
            }
            _tableView.hidden = NO;
        }
    }
}

#pragma mark --- 数据为空显示的图片
-(void)showEmptyMessage{
    if (_emptyLabel) {
        [_emptyLabel removeFromSuperview];
    }
    _emptyLabel = [[UILabel alloc]init];
    _emptyLabel.text = @"没有任何数据!";
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    _emptyLabel.font = [UIFont systemFontOfSize:20];
    _emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_emptyLabel];
    NSArray *emptyArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_emptyLabel]-0-|" options:0 metrics:nil views:@{@"_emptyLabel":_emptyLabel}];
    [self.view addConstraints:emptyArray];
    emptyArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_emptyLabel(30)]" options:0 metrics:nil views:@{@"_emptyLabel":_emptyLabel}];
    [self.view addConstraints:emptyArray];
}
@end
