//
//  ViewController.m
//  ImageManyOption
//
//  Created by Lillian on 16/7/26.
//  Copyright © 2016年 Lillian. All rights reserved.
//

#import "ViewController.h"
#import "SendController.h"
#import "PuBuLiuController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property   (nonatomic,copy)UITableView *tableView;
@property   (nonatomic,copy)NSMutableArray  *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"图片操作";
    [self createSource];
    [self createTableView];
}
- (void)createSource{
    _dataSource = [[NSMutableArray alloc]initWithArray:@[@"图片多选",@"瀑布流"]];
}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark    <TableView代理方法>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            SendController *send = [[SendController alloc]init];
            [self.navigationController pushViewController:send animated:YES];
        }
            break;
        case 1:
        {
            PuBuLiuController *pbl = [[PuBuLiuController alloc]init];
            [self.navigationController pushViewController:pbl animated:YES];
        }
            break;
    }
}

@end
