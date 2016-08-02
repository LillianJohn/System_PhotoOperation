//
//  PhotoCollectionViewCell.h
//  ImageManyOption
//
//  Created by Lillian on 16/7/26.
//  Copyright © 2016年 Lillian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property   (nonatomic,strong)UIImageView *imageV;
@property   (nonatomic,strong)UIButton    *btn;
@property   (nonatomic,strong)void (^btnClick)();

@end
