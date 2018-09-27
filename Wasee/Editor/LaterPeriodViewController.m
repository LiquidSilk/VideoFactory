//
//  EditorAudioCombineViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/13.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "LaterPeriodViewController.h"
#import "LaterPeriodVideoViewController.h"
#import "EditorAudioCombineViewController.h"
#import "UIUitls.h"
#import "FileUtils.h"
#import "Utils.h"
#import "StickerView.h"
#import "StickerViewController.h"
#import "FilterViewController.h"
#import "CoverViewController.h"

#import "VideoPlayViewController.h"

@interface LaterPeriodViewController ()
<
LaterPeriodVideoViewControllerDelegate,
StickerViewControllerDelegate,
FilterViewControllerDelegate
>
{
}

@property(nonatomic, strong)LaterPeriodVideoViewController* laterPeriodVideoVC;
@property(nonatomic, strong)EditorAudioCombineViewController* editorAudioCombineVC;

@property(nonatomic, strong)StickerViewController* stickerVC;
@property(nonatomic, strong)FilterViewController* filterVC;
@property(nonatomic, strong)CoverViewController* coverVC;
//@property(nonatomic, strong)StickerView* stickerView;

@end

@implementation LaterPeriodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* audioPath = [FileUtils getFileProjPath:@"1108" fileName:@"backgroundAudio.mp3"];
    _videoPath = [FileUtils getFileProjPath:@"1108" fileName:@"backgroundVideo.mp4"];
    _projName = @"1108";

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *bundlePathAudio = [[NSBundle mainBundle] pathForResource:@"backgroundAudio" ofType:@"mp3"];
    NSString *bundlePathVideo = [[NSBundle mainBundle] pathForResource:@"backgroundVideo" ofType:@"mp4"];

    [FileUtils createDir:_projName];
    [FileUtils deleteFile:@"1108" fileName:@"backgroundAudio.mp3"];
    [FileUtils deleteFile:@"1108" fileName:@"backgroundVideo.mp4"];
    NSError *error;
    BOOL success1 = [fileManager copyItemAtPath:bundlePathAudio toPath:audioPath error:&error];
    BOOL success2 = [fileManager copyItemAtPath:bundlePathVideo toPath:_videoPath error:&error];
    if(!success2)
        NSLog(@"文件从 app 包里拷贝到 Documents 目录，失败:%@", error);
    else
        NSLog(@"文件从 app 包里已经成功拷贝到了 Documents 目录。");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    UIButton* btnStopRecord = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 59, 80)];
    [btnStopRecord setImage:[UIImage imageNamed:@"停止录音"] forState:UIControlStateNormal];
    [[btnStopRecord rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {


        //        [self.laterPeriodVideoVC addFilter];
        //        return;



        //        [_laterPeriodVideoVC addMusicURL:[NSURL URLWithString:@"http://192.168.31.132:8001/123.mp3"]];
        NSMutableDictionary* map = [self.laterPeriodVideoVC getRangeMap];
        [self.laterPeriodVideoVC.videoFactory removeAllSubLayer];
        for(id key in map)
        {
            NSArray* item = [map objectForKey: key];
            Sticker* view = (Sticker*)[self.stickerVC getStickerWithKey:key];
            CGFloat t1 = [[item objectAtIndex:0] floatValue];
            CGFloat t2 = [[item objectAtIndex:1] floatValue];
            [view setMode:2 ratio:4];
            [view setStartTime:t1];
            [view setEndTime:t2];
            [self.laterPeriodVideoVC.videoFactory addWater:view startTime:t1 endTime:t2 ratio:4 originHeight:960];
        }

        //        StickerView* sticker = [[StickerView alloc] initWithFrame:CGRectMake(0, 0, 540, 960)];
        //        [sticker addSticker];
        //        [sticker addSticker];
        //        [sticker addSticker];
        //        sticker.backgroundColor  = [UIColor redColor];
        //        [self.view addSubview:sticker];
        //        [sticker mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.mas_equalTo(100);
        //            make.top.mas_equalTo(64);
        //            make.height.mas_equalTo(300);
        //            make.width.mas_equalTo(168);
        //        }];
        //        [_laterPeriodVideoVC.videoFactory addWater:sticker];

        [FileUtils deleteFile:@"1108/draft" fileName:@"out_withAudio.mp4"];
        [_laterPeriodVideoVC.videoFactory exportToPath:[FileUtils getFileURLProjPath:@"1108/draft" fileName:@"out_withAudio.mp4"]
                                            complition:^(NSURL *outputPath, BOOL isSucceed) {
                                                NSLog(@"export finish");
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    VideoPlayViewController *vce = [[VideoPlayViewController alloc] init];
                                                    vce.videoPath = [FileUtils getFileProjPath:@"1108/draft" fileName:@"out_withAudio.mp4"];
                                                    [self.navigationController pushViewController:vce animated:NO];
                                                });
                                            }];


    }];
    [self.view addSubview:btnStopRecord];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.laterPeriodVideoVC;
    NSMutableArray * controllerArray = [[NSMutableArray alloc] init];
    
    EditorAudioCombineViewController* audioCombineVC = self.editorAudioCombineVC;
    audioCombineVC.tabBarItem.image = [UIImage imageNamed:@"音效选中"];
    audioCombineVC.tabBarItem.title = NSLocalizedString(@"音效", "音效");
    [controllerArray addObject:audioCombineVC];
    
    StickerViewController* stickerVC = self.stickerVC;
    stickerVC.tabBarItem.image = [UIImage imageNamed:@"贴图"];
    stickerVC.tabBarItem.title = NSLocalizedString(@"贴图", "贴图");
    [controllerArray addObject:stickerVC];
    
    FilterViewController* filterVC = self.filterVC;
    filterVC.tabBarItem.image = [UIImage imageNamed:@"滤镜"];
    filterVC.tabBarItem.title = NSLocalizedString(@"滤镜", "滤镜");
    [controllerArray addObject:filterVC];
    
    CoverViewController* coverVC = self.coverVC;
    coverVC.tabBarItem.image = [UIImage imageNamed:@"封面"];
    coverVC.tabBarItem.title = NSLocalizedString(@"封面", "封面");
    [controllerArray addObject:coverVC];
    
    self.viewControllers = controllerArray;
    
    
}
#pragma mark - 私有方法
- (void)setTabShow:(BOOL)bShow
{
    CGRect rect = self.tabBar.frame;
    if (bShow)
    {
        [UIView animateWithDuration:0.1 animations:^{
            [self.tabBar setFrame:CGRectMake(rect.origin.x, kScreenH - rect.size.height,
                                             rect.size.width, rect.size.height)];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.tabBar setFrame:CGRectMake(rect.origin.x, kScreenH,
                                             rect.size.width, rect.size.height)];
        }];
    }
}

#pragma mark - LaterPeriodViewControllerDelegate
- (void)laterPeriodViewController:(LaterPeriodVideoViewController*)vc onStatus:(NSInteger)status
{
    if (status == PLAYER_STATUS_START)
    {
    }
    else if(status == PLAYER_STATUS_PAUSE)
    {
    }
    else if(status == PLAYER_STATUS_FINISH)
    {
//        //停止录音
        [_editorAudioCombineVC stopRecord];
        [_laterPeriodVideoVC setControlEnable:YES];
    }
}

- (void)laterPeriodViewController:(LaterPeriodVideoViewController*)vc inRangeWithKey:(NSString*)key
{
    [_stickerVC setStickerWithKey:key show:YES];
}

- (void)laterPeriodViewController:(LaterPeriodVideoViewController*)vc outRangeWithKey:(NSString*)key
{
    [_stickerVC setStickerWithKey:key show:NO];
}

- (void)laterPeriodViewController:(LaterPeriodVideoViewController*)vc onSelecedImage:(UIImage*)image
{
    [_coverVC setImage:image];
}

#pragma mark - StickerViewControllerDelegate
- (void)stickerViewController:(StickerViewController*)vc addSticker:(Sticker*)sticker
{
    NSString* key = [NSString stringWithFormat:@"%d", sticker.tag];
    [_laterPeriodVideoVC addVideoRangeSelector:key];
}

- (void)stickerViewController:(StickerViewController*)vc removeSticker:(Sticker*)sticker
{
    NSString* key = [NSString stringWithFormat:@"%d", sticker.tag];
    [_laterPeriodVideoVC removeRangeSelectorWithKey:key];
}

#pragma mark - FilterViewControllerDelegate
- (void)filterViewController:(FilterViewController*)vc addFilter:(NSString*)filterName
{
    [_laterPeriodVideoVC addFilter:filterName];
}

#pragma mark - getter
- (LaterPeriodVideoViewController*)laterPeriodVideoVC
{
    if (!_laterPeriodVideoVC)
    {
        _laterPeriodVideoVC = [[LaterPeriodVideoViewController alloc] init];
        _laterPeriodVideoVC.delegate = self;
        _laterPeriodVideoVC.videoPath = _videoPath;
        _laterPeriodVideoVC.projName = _projName;
        //        _laterPeriodVC.playerMode = PLAYER_MODE_RESTART;
        [self addChildViewController:_laterPeriodVideoVC];
        [self.view addSubview:_laterPeriodVideoVC.view];
        [_laterPeriodVideoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.view);
            make.height.mas_equalTo(410);
        }];
    }
    return _laterPeriodVideoVC;
}

- (EditorAudioCombineViewController*)editorAudioCombineVC
{
    if (!_editorAudioCombineVC)
    {
        _editorAudioCombineVC = [[EditorAudioCombineViewController alloc] init];
        _editorAudioCombineVC.laterPeriodVideoVC = _laterPeriodVideoVC;
        _editorAudioCombineVC.projName = _projName;
    }
    return _editorAudioCombineVC;
}

- (StickerViewController*)stickerVC
{
    if (!_stickerVC)
    {
        _stickerVC = [[StickerViewController alloc] init];
        _stickerVC.delegate = self;
        [_stickerVC addSubviewTo:self.view];
    }
    return _stickerVC;
}

- (FilterViewController*)filterVC
{
    if (!_filterVC)
    {
        _filterVC = [[FilterViewController alloc] init];
        _filterVC.delegate = self;
    }
    return _filterVC;
}

- (CoverViewController*)coverVC
{
    if (!_coverVC)
    {
        _coverVC = [[CoverViewController alloc] init];
        _coverVC.image = [_laterPeriodVideoVC getScreenShotImageAt:5];
    }
    return _coverVC;
}
@end
