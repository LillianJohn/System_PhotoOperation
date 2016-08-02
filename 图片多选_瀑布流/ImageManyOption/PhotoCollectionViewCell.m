//
//  PhotoCollectionViewCell.m
//  ImageManyOption
//
//  Created by Lillian on 16/7/26.
//  Copyright © 2016年 Lillian. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubView];
    }
    return self;
}
- (void)createSubView{
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (WIDTH - 2 ) / 3,(WIDTH-2)/3)];
    self.imageV.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.imageV];
    CGFloat ivX = self.imageV.frame.size.width;
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(ivX * 3 / 4, 0, ivX / 4,ivX / 4 )];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btn];
}
- (void)touchBtn{
    self.btnClick();
}
@end
