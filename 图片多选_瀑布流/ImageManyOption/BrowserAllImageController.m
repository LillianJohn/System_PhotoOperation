//
//  BrowserAllImageController.m
//  ImageManyOption
//
//  Created by Lillian on 16/7/27.
//  Copyright © 2016年 Lillian. All rights reserved.
//

#import "BrowserAllImageController.h"

@interface BrowserAllImageController ()<UIScrollViewDelegate>
{
    UIButton        *_selectImageState;
    UIView          *_bottomView;
    BOOL            _hiddenState;
    UIScrollView    *_scrollView;
}

@end

@implementation BrowserAllImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hiddenState = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.index + 1,self.ImageArr.count];
    [self createNavigation];
    [self createScrollView];
    [self createBottomView];
     _scrollView.contentOffset = CGPointMake(WIDTH * (self.index), 0);
}
#pragma mark    --创建导航栏
- (void)createNavigation{
//    创建返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 30, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"back_Btn01"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    创建是否选中按钮
    _selectImageState = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 40, 30, 30, 30)];
//    _selectImageState setImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_selectImageState];
}
#pragma mark    --创建boolBar
- (void)createBottomView{
    _bottomView  = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 40, WIDTH, 40)];
    _bottomView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_bottomView];
    UIButton *finish = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 40, 10, 30, 20)];
    finish.titleLabel.font = [UIFont systemFontOfSize:12];
    [finish addTarget:self action:@selector(finishiClick:) forControlEvents:UIControlEventTouchUpInside];
    [finish setTitle:@"完成" forState:UIControlStateNormal];
    [_bottomView addSubview:finish];
    
}
//toolBar上的完成图片选择
- (void)finishiClick:(UIButton *)finish{
    NSLog(@"该操作未实现，有待开发");
}
//返回到前一个页面
- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH , HEIGHT)];
    _scrollView.contentSize = CGSizeMake(WIDTH * self.ImageArr.count, HEIGHT);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
//    _scrollView.backgroundColor = [UIColor yellowColor];
    //    给ImageView上加手势
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBrowserAction:)];
    [_scrollView addGestureRecognizer:tapGesture];
//    创建图片查看器(UIImageView)
    for (NSInteger i = 0; i < self.ImageArr.count - 1; i++) {
        UIImage *img = self.ImageArr[i];
        CGFloat h = WIDTH * img.size.height/img.size.width;
        //创建显示图像的视图
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, (HEIGHT-h)/2, WIDTH, h)];
//        iv.userInteractionEnabled = YES;
        iv.image = img;
        [_scrollView addSubview:iv];
    }
    [self.view addSubview:_scrollView];
    
}
//点击全屏预览模式
- (void)tapBrowserAction:(UITapGestureRecognizer *)tap{
    if(_hiddenState == YES){
        self.navigationController.navigationBar.hidden = YES;
        _bottomView.hidden = YES;
        _hiddenState = NO;
    }else{
       self.navigationController.navigationBar.hidden = NO;
        _bottomView.hidden = NO;
        _hiddenState = YES;
    }
}
#pragma mark    --<ScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.title = [NSString stringWithFormat:@"%ld/%ld",(NSInteger)(scrollView.contentOffset.x / WIDTH + 1),self.ImageArr.count];
}
- (void)viewDidLayoutSubviews{
    
}
@end
