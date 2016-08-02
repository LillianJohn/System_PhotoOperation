//
//  PuBuLiuController.m
//  ImageManyOption
//
//  Created by Lillian on 16/7/26.
//  Copyright © 2016年 Lillian. All rights reserved.
//

#define IMAG_WIDTH ((WIDTH - GAP * 2)/3)
#define TableViewTAG    10
#define GAP 10

#import "PuBuLiuController.h"
#import "MyTableViewCell.h"
#import "ImageDetailController.h"

@interface PuBuLiuController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray; //所有图片
    NSMutableArray *threeTableViewDataSource;   //里面有三个数组，每个数组对应一个tableView的数据源
    CGFloat _imageHeight[3];    //保存每个TableView已经显示的图片的高度
    NSMutableArray *_tableViewArray;    //保存所有的tableView
}

@end

@implementation PuBuLiuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"瀑布流";
    [self createBackButtonToNavi];
    //拿到所有图片
    [self createData];
    //配置每个TableView的数据源
    [self initEachTableDataSource];
    //展示
    [self createUI];
}
- (void)createBackButtonToNavi{
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_Btn01"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI{
    _tableViewArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < 3; i++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake((IMAG_WIDTH + GAP) * i, 64, IMAG_WIDTH,HEIGHT) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tag = TableViewTAG + i;
        [self.view addSubview:tableView];
        [_tableViewArray addObject:tableView];
    }
}
- (void)createData{
    _dataArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i <= 200; i++) {
        UIImage *image =  [UIImage imageNamed:[NSString stringWithFormat:@"pubuliu%lu.jpg",i % 15]];
        [_dataArray addObject:image];
    }
}
#pragma mark ---让三个TableView一起滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //拿到要滑动的tableView
    //    NSInteger index = [_tableViewArray indexOfObject:scrollView];
    for (UITableView *tableView in _tableViewArray) {
        if (tableView == scrollView) {
            continue;
        }
        tableView.contentOffset = scrollView.contentOffset;
    }
}
- (void)initEachTableDataSource{
    //1.实例化tableView对应的数据源
    threeTableViewDataSource = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < 3; i++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [threeTableViewDataSource addObject:array];
    }
    //2.给每个数据源发图片
    for (UIImage *image in _dataArray) {
        //2.1按照数据源中所有图片高度最短的那个数据源
        NSMutableArray *array= [self shortDataSource];
        //2.2把图片加到这个数据源中
        [array addObject:image];
        //2.3更新最短数据源的高度
        [self upDateShortDataSourceHeight:array];
        
    }
}

//更新最短数据源的高度
- (void)upDateShortDataSourceHeight:(NSMutableArray *)shortArray{
    //1.最矮的是哪个数据源
    NSInteger index = [threeTableViewDataSource indexOfObject:shortArray];
    //2.先拿到要更新的数据源的之前的高度
    //    CGFloat height = _imageHeight[index];
    //拿到图片
    UIImage *image = [shortArray lastObject];
    
    //3.更新高度
    _imageHeight[index] += [self imageHeightWithImage:image];
}
- (CGFloat)imageHeightWithImage:(UIImage *)image{
    return image.size.height * IMAG_WIDTH / image.size.width;
    
}
//返回图片长度最短的数据源
- (NSMutableArray *)shortDataSource{
    //假设第一个TableView里所有的图片的高度是最低的
    CGFloat shortHeight = _imageHeight[0];
    //记录下标，表示最低的是哪个tableView
    NSInteger min = 0;
    for (NSInteger i = 1; i <= 2; i++) {
        if (_imageHeight[i] < shortHeight) {
            shortHeight = _imageHeight[i];
            min = i;
        }
    }
    return threeTableViewDataSource[min];
}
#pragma mark --TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger index = [_tableViewArray indexOfObject:tableView];
    NSMutableArray *dataSource = threeTableViewDataSource[index];
    return dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = [_tableViewArray indexOfObject:tableView];
    NSMutableArray *dataSource = threeTableViewDataSource[index];
    UIImage *image = dataSource[indexPath.row];
    return [self imageHeightWithImage:image];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSInteger index = [_tableViewArray indexOfObject:tableView];
    NSMutableArray *dataSource = threeTableViewDataSource[index];
    UIImage *image = dataSource[indexPath.row];
    [cell setImage:image width:IMAG_WIDTH height:[self imageHeightWithImage:image]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *image = [[UIImage alloc]init];
    if (tableView.tag == 10) {
//        UIImage *image = threeTableViewDataSource[indexPath.row];
        image = threeTableViewDataSource[0][indexPath.row];
    }
    if (tableView.tag == 11) {
//        UIImage *image = threeTableViewDataSource[indexPath.row];
        image = threeTableViewDataSource[1][indexPath.row];
    }
    if (tableView.tag == 12) {
//        UIImage *image = threeTableViewDataSource[indexPath.row];
        image = [threeTableViewDataSource lastObject][indexPath.row];
    }
    ImageDetailController *detail = [[ImageDetailController alloc]init];
    detail.image = image;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
