//
//  CoverViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/9/13.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "CoverViewController.h"
#import "UIUitls.h"
#import "Utils.h"
#import "LaterPeriodViewController.h"
#import "TZImagePickerController.h"
#import "PhotoTweaksViewController.h"

@interface CoverViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoTweaksViewControllerDelegate>

@property (nonatomic, strong)UIImageView* cover;
@property (nonatomic, strong)UIButton* btnAlbum;
@property (nonatomic, strong)UIButton* btnCover;
@property (nonatomic, assign)BOOL isCoverSelect;
@end

@implementation CoverViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isCoverSelect = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cover = [[UIImageView alloc] init];
    
    [_cover setImage:_image];
    [self.view addSubview:_cover];
    [_cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(410);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-100);
        make.width.mas_equalTo(self.cover.mas_height).multipliedBy(_image.size.width/_image.size.height);
    }];
    
    _btnAlbum = [[UIButton alloc] init];
    [_btnAlbum setTitle:@"从相册选择" forState:UIControlStateNormal];
    [[_btnAlbum rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.navigationBarHidden = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [self.view addSubview:_btnAlbum];
    [_btnAlbum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_cover.mas_bottom).offset(5);
    }];
    
    _btnCover = [[UIButton alloc] init];
    [_btnCover setTitle:@"点击修改封面" forState:UIControlStateNormal];
    [[_btnCover rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self showCoverSelect:YES];
    }];
    [self.view addSubview:_btnCover];
    [_btnCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_cover.mas_bottom).offset(5);
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    LaterPeriodViewController* vc = [self parentViewController];
    [vc setTabShow:YES];
    

    [self showCoverSelect:NO];
}

- (void)setImage:(UIImage *)image
{
    if (_isCoverSelect)
    {
        [_cover setImage:image];
        _image = nil;
        _image = image;
    }
}

- (void)showCoverSelect:(BOOL)bShow
{
    [_btnCover setHidden:bShow];
    [_btnAlbum setHidden:!bShow];
    _isCoverSelect = bShow;
    if (bShow)
    {
        UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
        [rightButton setImage:[UIImage imageNamed:@"蓝色对号"] forState:UIControlStateNormal];
        [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x)
         {
             [self showCoverSelect:NO];
             self.navigationItem.rightBarButtonItem = nil;
         }];
        UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.parentViewController.navigationItem.rightBarButtonItem = rightItem;
        
        UIButton* leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
        [leftButton setImage:[UIImage imageNamed:@"蓝色返回"] forState:UIControlStateNormal];
        [[leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x)
         {
             [self showCoverSelect:NO];
             self.navigationItem.rightBarButtonItem = nil;
         }];
        UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.parentViewController.navigationItem.leftBarButtonItem = leftItem;
    }
    else
    {
        self.parentViewController.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
    photoTweaksViewController.delegate = self;
    photoTweaksViewController.autoSaveToLibray = NO;
    photoTweaksViewController.maxRotationAngle = M_PI;
    [picker pushViewController:photoTweaksViewController animated:YES];
}

- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage
{
    [controller.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [self setImage:croppedImage];
    [self showCoverSelect:NO];
    
}

- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    [controller.navigationController popViewControllerAnimated:YES];
}
@end
