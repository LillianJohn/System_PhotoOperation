//
//  SendController.m
//  ImageManyOption
//
//  Created by Lillian on 16/7/26.
//  Copyright © 2016年 Lillian. All rights reserved.
//

#import "SendController.h"
#import "PhotoViewController.h"
#import "SelectedCollectionCell.h"
#import "BrowserImage.h"

@interface SendController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate>
@property   (nonatomic,strong)UITextView    *mesTextView;
@property   (nonatomic,strong)UIButton        *addButton;
@property   (nonatomic,strong)NSMutableArray  *imgArr;
@property   (nonatomic,strong)UICollectionView    *collectionView;
@property   (nonatomic,strong)UIView              *background;

@end

@implementation SendController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackButtonToNavi];
    self.imgArr = [[NSMutableArray alloc]init];
    UIImage * img = [UIImage imageNamed:@"add-img.png"];
    [self.imgArr addObject:img];
    self.view.backgroundColor= [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(shangchuan)];
    [self createUI];
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
-(void)shangchuan{
    NSLog(@"没服务器!!");
}
- (void)createUI{
    self.mesTextView=[[UITextView alloc]initWithFrame:CGRectMake(20, 70, WIDTH-40, 80)];
    self.mesTextView.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.mesTextView];
    UICollectionViewFlowLayout * fl = [[UICollectionViewFlowLayout alloc]init];
    fl.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 160, WIDTH -40,HEIGHT- 160 ) collectionViewLayout:fl];
    self.collectionView.backgroundColor= self.view.backgroundColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:NSClassFromString(@"SelectedCollectionCell")forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = (WIDTH-40)/4-5;
    return CGSizeMake(w, w);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelectedCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imgView.image = self.imgArr[indexPath.row];
    if (indexPath.row != self.imgArr.count-1 && indexPath.row != 1) {
        cell.imgView.userInteractionEnabled = YES;
//        给图片添加手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionSend:)];
        cell.imgView.tag =  100 + indexPath.row;
        [cell.imgView addGestureRecognizer:tapGesture];
    }
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.imgArr.count -1) {
        [self toChoose];
    }
}
- (void)toChoose{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择类型" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PhotoViewController * photo = [[PhotoViewController alloc]init];
        photo.popSelectedArr = ^(NSMutableArray*arr ){
            self.imgArr = arr;
            UIImage * img = [UIImage imageNamed:@"add-img.png"];
            [self.imgArr addObject:img];
            [self.collectionView reloadData];
        };
        [self.navigationController pushViewController:photo animated:NO];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        相机
//        [self isCameraAlertWithUser];
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction: action1];
    [alert addAction: action2];
    [alert addAction: action3];
    [self presentViewController:alert animated:NO completion:nil];
}
// 判断设备是否有摄像头
- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
- (void)isCameraAlertWithUser{
    if (![self isCameraAvailable]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:0 handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
//        拍照
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //初始化
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        //进入照相界面
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark    -点击图片预览
- (void)tapActionSend:(UITapGestureRecognizer*)sender{
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
//    BrowserImage *browser = [[BrowserImage alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andImageCount:self.imgArr.count - 1 andImages:self.imgArr];
//    [self.view addSubview:browser];
    
    
}
-(void)closeView{
    self.navigationController.navigationBarHidden = NO;
    [_background removeFromSuperview];
}
//放大过程中出现的缓慢动画
- (void) shakeToShow:(UIView*)aView{
    self.navigationController.navigationBarHidden = YES;
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.1;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
#pragma mark    ---拍摄完成后要执行的方法
#pragma mark    <代理方法>
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imgArr addObject:image];
    UIImage * img = [UIImage imageNamed:@"add-img.png"];
    [self.imgArr addObject:img];
    [self.collectionView reloadData];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
