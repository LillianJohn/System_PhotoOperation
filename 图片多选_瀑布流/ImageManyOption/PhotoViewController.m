//
//  PhotoViewController.m
//  ImageManyOption
//
//  Created by Lillian on 16/7/26.
//  Copyright © 2016年 Lillian. All rights reserved.
//
#import <Photos/Photos.h>
#import "PhotoViewController.h"
#import "SendController.h"
#import "PhotoCollectionViewCell.h"
#import "AlbumTableViewCell.h"
#import "BrowserAllImageController.h"

@interface PhotoViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray * imageArr;

@property (nonatomic,strong)UIView * tview;

@property (nonatomic,assign)BOOL isup;

@property (nonatomic,strong)UITableView * myTableView;

@property (nonatomic,copy)NSString * identifier;
//相册数组
@property (nonatomic,strong)NSMutableArray * albumArr;

@property (nonatomic,strong)UIView *background;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBackButtonToNavi];
    [self initWithSource];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(popto)];
    self.navigationItem.title = @"所有图片";
    [self getPhotoData];
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
- (void)initWithSource{
    _isup = NO;
    self.imageArr = [[NSMutableArray alloc]init];
    self.albumArr = [[NSMutableArray alloc]init];
    self.selectArr = [[NSMutableArray alloc]init];
}
#pragma mark --- 返回
- (void)popto{
    self.popSelectedArr(self.selectArr);
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark --- 获取所有图片资源
- (void)getPhotoData{
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    for (NSInteger i = 0; i < assetsFetchResults.count; i++) {
        PHAsset *asset = assetsFetchResults[i];
        //资源转图片
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage * image = [UIImage imageWithData:imageData];
            [self.imageArr addObject:image];
            if (self.imageArr.count == assetsFetchResults.count){
                [self.albumArr addObject:assetsFetchResults];
                [self getAlbumData];
                [self createUI];
            }
        }];
    }
}
#pragma mark -- 创建主界面
- (void)createUI{
    UICollectionViewFlowLayout * fl = [[UICollectionViewFlowLayout alloc]init];
    fl.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, WIDTH, HEIGHT-100)collectionViewLayout:fl];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1];
    [self.collectionView registerClass:NSClassFromString(@"PhotoCollectionViewCell")forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    _isup = NO;
    UIToolbar * tool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, HEIGHT-40, WIDTH, 40)];
    UIButton *attentionBar = [[UIButton alloc] initWithFrame:CGRectMake(0, 10.0, 80.0, 30.0)];
    [attentionBar setTitle:@"相册选择" forState:UIControlStateNormal];
    [attentionBar addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [attentionBar setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    UIBarButtonItem *nextStepBarBtn = [[UIBarButtonItem alloc] initWithCustomView:attentionBar];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spaceButtonItem setWidth:10];
    [tool setItems:[NSArray arrayWithObjects:spaceButtonItem,nextStepBarBtn,nil] animated:YES];
    [self.view addSubview:tool];
    //创建tv
    [self createTV];
}
- (void)createTV{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.tview.userInteractionEnabled = YES;
    self.myTableView.backgroundColor = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1];
    self.tview = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-40, WIDTH,0)];
    [self.tview addSubview:self.myTableView];
    self.tview.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tview];
}
#pragma mark --- 获取用户相册资源
- (void)getAlbumData{
    //可以获取所有用户创建的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    for (PHAssetCollection * as in topLevelUserCollections) {
        [self.albumArr addObject:as];
    }
}
#pragma mark --- 相册选择
- (void)btnAction:(UIButton*)sender{
    if (_isup == NO) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.tview.frame = CGRectMake(0, HEIGHT/2, WIDTH, HEIGHT/2 -40);
            self.myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT/2 -40);
        } completion:^(BOOL finished) {
            _isup = YES;
        }];
    }else{
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.tview.frame = CGRectMake(0, HEIGHT-40, WIDTH, 0);
            self.myTableView.frame = CGRectMake(0, 0, WIDTH, 0);
        } completion:^(BOOL finished) {
            _isup = NO;
        }];
    }
}
#pragma mark    ----
#pragma mark    ---- CollectionView协议
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDTH-2)/3, (WIDTH-2)/3);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.imageArr.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageV.image = self.imageArr[indexPath.row];
    cell.imageV.userInteractionEnabled = YES;
    
    
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//    cell.imageV.tag =  100+indexPath.row;
//    [cell.imageV addGestureRecognizer:tapGesture];
    
    
    //使cell.btn的图片在block中可修改
    __block UIButton * btn;
    btn.selected = YES;;
    //判断是否选中
    cell.btnClick = ^{
        if (cell.btn.selected == NO) {
            [btn setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
            [self.selectArr addObject: self.imageArr[indexPath.row]];
            btn.selected = YES;
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
            [self.selectArr removeObject: self.imageArr[indexPath.row]];
            btn.selected = NO;
        }
    };
    btn = cell.btn;
    return cell;
}
#pragma mark    ---点击collection的View
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BrowserAllImageController *bVC = [[BrowserAllImageController alloc]init];
    bVC.index = indexPath.row;
    bVC.ImageArr = [NSArray arrayWithArray:self.imageArr];
    [self.navigationController pushViewController:bVC animated:YES];

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

#pragma mark    --预览选中图片
/*
- (void)tapAction:(UITapGestureRecognizer*)sender{
    UIImageView * iv = (UIImageView*)[sender view];
    UIImage * img = iv.image;
    //创建一个黑色背景
    _background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH , HEIGHT)];
    [ _background setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview: _background];
    CGFloat h = WIDTH*img.size.height/img.size.width;
    //创建显示图像的视图
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (HEIGHT-h)/2, WIDTH, h)];
    //要显示的图片，即要放大的图片
    imgView.image = img;
    [ _background addSubview:imgView];
    imgView.userInteractionEnabled = YES;
    //添加点击手势（即点击图片后退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [imgView addGestureRecognizer:tapGesture];
    [self shakeToShow: _background];//放大过程中的动画
}
-(void)closeView{
    self.navigationController.navigationBarHidden = NO;
    [_background removeFromSuperview];
}
//放大过程中出现的缓慢动画
- (void) shakeToShow:(UIView*)aView{
    self.navigationController.navigationBarHidden = YES;
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
 */
#pragma mark    -----
#pragma mark    ---- <tableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"album";
    AlbumTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AlbumTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        PHFetchResult *assetsFetchResults = self.albumArr[0];
        //第一张图的资源
        PHAsset *asset = assetsFetchResults[0];
        //资源转图片
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage * image = [UIImage imageWithData:imageData];
            cell.imgView.image = image;
            cell.label.text = @"所有图片";
        }];
    }else{
        PHAssetCollection * as = self.albumArr[indexPath.row];
        cell.label.text = as.localizedTitle;
        PHFetchResult * fetchResult = [PHAsset fetchAssetsInAssetCollection:as options:nil];
        //获取相册集合中的每个相册的第一个资源，形成缩略图
        PHAsset *asset = nil;
        if (fetchResult.count != 0) {
            asset = fetchResult[0];
        }
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage * image = [UIImage imageWithData:imageData];
            cell.imgView.image = image;
        }];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.imageArr removeAllObjects];
    [self.selectArr removeAllObjects];
    //所有图片
    if (indexPath.row == 0) {
        PHFetchResult *assetsFetchResults = self.albumArr[0];
        self.navigationItem.title = @"所有图片";
        for (NSInteger i = 0; i < assetsFetchResults.count; i++) {
            PHAsset *asset = assetsFetchResults[i];
            //资源转图片
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                UIImage * image = [UIImage imageWithData:imageData];
                [self.imageArr addObject:image];
                if (self.imageArr.count == assetsFetchResults.count){
                    //不能写reloadData，应该写[self createUI]
                    [self createUI];
                }
            }];
        }
    }else{//用户相册
        PHAssetCollection * as = self.albumArr[indexPath.row];
        self.navigationItem.title = as.localizedTitle;
        PHFetchResult * fetchResult = [PHAsset fetchAssetsInAssetCollection:as options:nil];
        for (PHAsset * asset in fetchResult) {
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                UIImage * image = [UIImage imageWithData:imageData];
                [self.imageArr addObject:image];
                if (self.imageArr.count == fetchResult.count) {
                    //不能写reloadData，应该写[self createUI]
                    [self createUI];
                }
            }];
        }
    }
}
@end
