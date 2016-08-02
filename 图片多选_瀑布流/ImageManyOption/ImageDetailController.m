//
//  ImageDetailController.m
//  ImageManyOption
//
//  Created by Lillian on 16/7/26.
//  Copyright © 2016年 Lillian. All rights reserved.
//

#import "ImageDetailController.h"

@interface ImageDetailController ()

@property   (nonatomic,copy)UIScrollView    *scrollView;

@end

@implementation ImageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackButtonToNavi];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    [self createImageView];
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
- (void)createImageView{
    CGFloat width = self.image.size.width;
    CGFloat height = self.image.size.height;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    if (self.image.size.width > WIDTH && self.image.size.height >HEIGHT) {
        imageView.frame = CGRectMake(0, 0, width / 3,height / 3 );
    }
    imageView.image = self.image;
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
}

@end
