//
//  HealthyViewController.m
//  CGYFood-v2
//
//  Created by qf on 9/17/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "HealthyViewController.h"
#import "HealthyListViewController.h"

@interface HealthyViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *search;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *itemFlagArray;//标识当前的item是否展开
@property (nonatomic, strong) NSArray *itemImageArray;//图片
@property (nonatomic, strong) UIImageView *tempImageView;//角标

@end

@implementation HealthyViewController

-(void)viewWillAppear:(BOOL)animated{
    //[self setSearch];
}

-(void)viewDidDisappear:(BOOL)animated{
    //self.tabBarController.navigationItem.titleView = nil;
}

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
    _itemFlagArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 22; i ++) {
        [_itemFlagArray addObject:@"0"];
    }
    _itemImageArray = ITEM_ARRAY;
    
    _dataArray = [[NSMutableArray alloc]init];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"healthy" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (dic.count > 0) {
        [_dataArray setArray: dic[@"items"]];
    }
}

#pragma mark --- 设置搜索框
-(void)setSearch{
    //搜索框
    _search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    _search.delegate = self;
    _search.placeholder = @"搜一搜健康常识";
    self.tabBarController.navigationItem.titleView = _search;
}

#pragma mark --- 设置setTableView
-(void)setTableView{
    _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,0,0,0} style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.backgroundView = nil;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    
    //设置约束
    NSArray *hArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    NSArray *vArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-20-|" options:0 metrics:nil views:@{@"_tableView":_tableView}];
    [self.view addConstraints:hArray];
    [self.view addConstraints:vArray];
}

#pragma mark --- TableView协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifir = @"HealthyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifir];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifir];
    }
    cell.clipsToBounds = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataArray[indexPath.section][@"items"][indexPath.row];
    cell.textLabel.textColor = COLOR(124, 183, 70, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section][@"items"] count];
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_itemFlagArray[indexPath.section] isEqualToString:@"0"])
        return 0;
    else
        return 44;
}
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
//组头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //UIImage *image = [[UIImage imageNamed:@"itembg.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *image = [UIImage imageNamed:@"itembg.png"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.tag = 100 + section;
    headImageView.frame = (CGRect){0, 0, self.view.frame.size.width, 44};
    headImageView.image = image;
    //headImageView.tintColor = [UIColor colorWithRed:245/255.0 green:243/255.0 blue:227/255.0 alpha:1];
    headImageView.userInteractionEnabled = YES;
    
    //图标
    UIImageView *logoImageView = [[UIImageView alloc]init];
    logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    logoImageView.clipsToBounds = YES;
    logoImageView.frame = (CGRect){10, 10, 24, 24};
    logoImageView.image = [UIImage imageNamed:_itemImageArray[section]];
    [headImageView addSubview:logoImageView];

    //标题
    UILabel *label = [[UILabel alloc]init];
    label.frame = (CGRect){50, 10, 200, 24};
    label.font = [UIFont systemFontOfSize:16];
    label.text = _dataArray[section][@"title"];
    [headImageView addSubview:label];
    
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)];
    [headImageView addGestureRecognizer:tap];
    return headImageView;
}
//组高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
//cell被点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HealthyListViewController *hVC = [[HealthyListViewController alloc]init];
    hVC.name = _dataArray[indexPath.section][@"items"][indexPath.row];
    [self.navigationController pushViewController:hVC animated:YES];
}
//单点手势
-(void)itemClick:(UITapGestureRecognizer *)tap{
    int index = tap.view.tag % 100;
    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [_dataArray[index][@"items"] count]; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:index];
        [indexArray addObject:path];
    }
    if ([_itemFlagArray[index] isEqualToString:@"0"]) {
        _itemFlagArray[index] = @"1";
        [_tableView reloadData];
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
    } else {
        _itemFlagArray[index] = @"0";
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];
    }
}


@end



















