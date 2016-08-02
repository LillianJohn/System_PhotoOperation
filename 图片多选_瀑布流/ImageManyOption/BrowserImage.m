//
//  BrowserImage.m
//  ImageManyOption
//
//  Created by Lillian on 16/7/26.
//  Copyright © 2016年 Lillian. All rights reserved.
//

#import "BrowserImage.h"

@interface BrowserImage()
@property (nonatomic,copy)UIScrollView   *scrollView;;
@end

@implementation BrowserImage

- (id)initWithFrame:(CGRect)frame andImageCount:(NSInteger)count andImages:(NSArray *)images{
    if (self = [super initWithFrame: frame]) {
        [self createNavigation:count andImages:images];
    }
    return self;
}
- (void)createNavigation:(NSInteger)count andImages:(NSArray *)imgArr{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH , HEIGHT)];
    self.scrollView.contentSize = CGSizeMake(WIDTH * count, HEIGHT);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = YES;
    for (NSInteger i = 0; i < count; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        iv.image = [UIImage imageNamed:imgArr[i]];
        [self.scrollView addSubview:iv];
    }
    [self addSubview:self.scrollView];
    UIButton    *bgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [bgBtn setBackgroundColor:[UIColor blackColor]];
    bgBtn.alpha = .5;
    [self addSubview:bgBtn];
//    返回
    UIButton *letfBack = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 35, 20)];
    [letfBack setTitle:@"返回" forState:UIControlStateNormal];
    letfBack.titleLabel.font = [UIFont systemFontOfSize:13];
    [letfBack addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn addSubview:letfBack];
//    删除
    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 40, 25, 35, 20)];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    delete.titleLabel.font = [UIFont systemFontOfSize:13];
    [delete addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn addSubview:delete];
    
}
#pragma mark    --返回
- (void)backClick:(UIButton *)btn{
    
}
- (void)deleteClick:(UIButton *)delete{
    
}
@end
