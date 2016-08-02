//
//  MyTableViewCell.m
//  ImageManyOption
//
//  Created by Lillian on 16/7/26.
//  Copyright © 2016年 Lillian. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell
{
    UIImageView *_imageView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addImageView];
    }
    return self;
}
- (void)addImageView{
    _imageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_imageView];
}
- (void)setImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height{
    _imageView.image = image;
    _imageView.frame = CGRectMake(0, 0, width, height);
}
@end
