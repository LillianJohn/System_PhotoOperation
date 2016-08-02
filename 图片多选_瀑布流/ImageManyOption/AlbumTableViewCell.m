//
//  AlbumTableViewCell.m
//  ImageManyOption
//
//  Created by Lillian on 16/7/26.
//  Copyright © 2016年 Lillian. All rights reserved.
//

#import "AlbumTableViewCell.h"

@implementation AlbumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 100 , 100)];
    [self.contentView addSubview:self.imgView];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(140, 50 ,100, 30)];
    [self.contentView addSubview:self.label];
}
@end
