//
//  SelectedCollectionCell.m
//  ImageManyOption
//
//  Created by Lillian on 16/7/26.
//  Copyright © 2016年 Lillian. All rights reserved.
//

#import "SelectedCollectionCell.h"

@implementation SelectedCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)]
    ;
    [self.contentView addSubview:self.imgView];
}

@end
