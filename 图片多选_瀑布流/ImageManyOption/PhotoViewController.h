//
//  PhotoViewController.h
//  ImageManyOption
//
//  Created by Lillian on 16/7/26.
//  Copyright © 2016年 Lillian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController
@property (nonatomic,copy) void(^popSelectedArr)(NSMutableArray *arr);

//所选图片数组
@property (nonatomic,strong)NSMutableArray * selectArr;
@end
