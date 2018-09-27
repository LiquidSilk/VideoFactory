//
//  EditorAudioCombineViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/13.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "EditorAudioCombineViewController.h"
#import "RecordViewController.h"
#import "AudioVolumeViewController.h"
#import "UIUitls.h"
#import "FileUtils.h"
#import "Utils.h"
#import "LUNSegmentedControl.h"
#import "StickerView.h"
#import "LaterPeriodViewController.h"



#import "VideoPlayViewController.h"

@interface EditorAudioCombineViewController ()
<
    LaterPeriodVideoViewControllerDelegate,
    RecordViewControllerDelegate,
    AudioVolumeViewControllerDelegate,
    LUNSegmentedControlDataSource, LUNSegmentedControlDelegate
>
{
    NSArray* tabNameList;
}

@property(nonatomic, strong)RecordViewController* recordVC;
@property(nonatomic, strong)AudioVolumeViewController* audioVolumeVC;
@property(nonatomic, strong)LUNSegmentedControl* segmentedControl;
@property(nonatomic, strong)UIButton* btnFinish;;

@end

@implementation EditorAudioCombineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.recordVC;
    self.audioVolumeVC;
    tabNameList = @[@"音乐", @"配音", @"音量"];
    
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.btnFinish];
    
//    _laterPeriodVideoVC.delegate = self;
    
    [self showTab:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leftMargin.rightMargin.mas_equalTo(0);
//        make.top.mas_equalTo(310);
//        make.bottom.mas_equalTo(self.parentViewController.view);
//    }];
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_bottom).offset(-40);
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(44);
    }];
    
    [_btnFinish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-10);
        make.centerY.mas_equalTo(_segmentedControl);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    LaterPeriodViewController* vc = [self parentViewController];
    [vc setTabShow:NO];
}

- (void)stopRecord
{
    [_recordVC stopRecord];
    [_laterPeriodVideoVC setControlEnable:YES];
}

#pragma mark - 私有方法
- (void) showTab:(int)num
{
    switch (num) {
        case 0:
            [self.recordVC show:YES];
            [self.audioVolumeVC show:NO];
            break;
        case 1:
            [self.recordVC show:YES];
            [self.audioVolumeVC show:NO];
            break;
        case 2:
            [self.recordVC show:NO];
            [self.audioVolumeVC show:YES];
            break;
        default:
            break;
    }
}

#pragma mark - RecordViewControllerDelegate
- (void)recordViewController:(RecordViewController*)vc onPushButton:(NSInteger)type path:(NSString *)recordPath
{
    if (type == BTN_TYPE_START)
    {
        [_laterPeriodVideoVC restart];
        [_laterPeriodVideoVC setControlEnable:NO];
    }
    else if (type == BTN_TYPE_STOP)
    {
        [_laterPeriodVideoVC pause];
        [_laterPeriodVideoVC addVoiceURL:[NSURL fileURLWithPath:recordPath]];
        [_laterPeriodVideoVC setControlEnable:YES];
    }
    else if (type == BTN_TYPE_DELETE)
    {
        [_laterPeriodVideoVC removeVoice];
    }
}

#pragma mark - LUNSegmentedControlDataSource, LUNSegmentedControlDelegate
- (NSArray<UIColor *> *)segmentedControl:(LUNSegmentedControl *)segmentedControl gradientColorsForStateAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @[UIColorFromRGB(0x628bff), UIColorFromRGB(0x50c4ff)];
            break;
        case 1:
            return @[UIColorFromRGB(0x628bff), UIColorFromRGB(0x50c4ff)];
            break;
        case 2:
            return @[UIColorFromRGB(0x628bff), UIColorFromRGB(0x50c4ff)];
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)numberOfStatesInSegmentedControl:(LUNSegmentedControl *)segmentedControl {
    return 3;
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForStateAtIndex:(NSInteger)index {
    return [[NSAttributedString alloc] initWithString:tabNameList[index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForSelectedStateAtIndex:(NSInteger)index {
    return [[NSAttributedString alloc] initWithString:tabNameList[index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:16]}];
}

- (void)segmentedControl:(LUNSegmentedControl *)segmentedControl didChangeStateFromStateAtIndex:(NSInteger)fromIndex toStateAtIndex:(NSInteger)toIndex
{
    NSLog(@"fromIndex = %d toIndex = %d", fromIndex, toIndex);
    if (toIndex == 0) {
        [self showTab:0];
    }
    else if (toIndex == 1) {
        [self showTab:1];
    }
    else
    {
        [self showTab:2];
        [_audioVolumeVC setSlider:1 enable:[_laterPeriodVideoVC.videoFactory musicTrackExists]];
        [_audioVolumeVC setSlider:2 enable:[_laterPeriodVideoVC.videoFactory voiceTrackExists]];
    }
}

#pragma mark - AudioVolumeViewControllerDelegate
- (void)recordViewController:(AudioVolumeViewController*)vc
                originVolume:(float)originVolume
                 musicVolume:(float)musicVolume
                 voiceVolume:(float)voiceVolume
{
    [_laterPeriodVideoVC setVideoVolume:originVolume musicVolume:musicVolume voiceVolume:voiceVolume];
}

#pragma mark - getter
//- (LaterPeriodVideoViewController*)laterPeriodVC
//{
//    if (!_laterPeriodVC)
//    {
//        _laterPeriodVC = [[LaterPeriodVideoViewController alloc] init];
//        _laterPeriodVC.delegate = self;
////        _laterPeriodVC.playerMode = PLAYER_MODE_RESTART;
//        [self addChildViewController:_laterPeriodVC];
//        [self.view addSubview:_laterPeriodVC.view];
//        [_laterPeriodVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.mas_equalTo(self.view);
//            make.height.mas_equalTo(460);
//        }];
//    }
//    return _laterPeriodVC;
//}

- (RecordViewController*)recordVC
{
    if (!_recordVC)
    {
        _recordVC = [[RecordViewController alloc] init];
        _recordVC.delegate = self;
        _recordVC.projName = _projName;
        [self addChildViewController:_recordVC];
        [self.view addSubview:_recordVC.view];
        [_recordVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(self.view);
            make.top.mas_equalTo(410);
        }];
    }
    return _recordVC;
}

- (AudioVolumeViewController*)audioVolumeVC
{
    if (!_audioVolumeVC)
    {
        _audioVolumeVC = [[AudioVolumeViewController alloc] init];
        _audioVolumeVC.delegate = self;
        [self addChildViewController:_audioVolumeVC];
        [self.view addSubview:_audioVolumeVC.view];
        [_audioVolumeVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(self.view);
            make.top.mas_equalTo(410);
        }];
    }
    return _audioVolumeVC;
}

- (LUNSegmentedControl*)segmentedControl
{
    if (_segmentedControl == nil)
    {
        _segmentedControl = [[LUNSegmentedControl alloc] init];
        _segmentedControl.delegate = self;
        _segmentedControl.dataSource = self;
        _segmentedControl.backgroundColor = UIColorFromRGB(BG_WHITE);
        _segmentedControl.selectorViewColor = UIColorFromRGB(0x50b4ff);
        _segmentedControl.cornerRadius = 23;
        _segmentedControl.transitionStyle = LUNSegmentedControlTransitionStyleSlide;
        _segmentedControl.transform = CGAffineTransformScale(_segmentedControl.transform, 0.8, 0.8);
    }
    return _segmentedControl;
}

- (UIButton*)btnFinish
{
    if (_btnFinish == nil)
    {
        _btnFinish = [[UIButton alloc] init];
        [_btnFinish setTitle:@"完成" forState:UIControlStateNormal];
        [_btnFinish setTitleColor:UIColorFromRGB(BG_WHITE) forState:UIControlStateNormal];
        [_btnFinish setTitleColor:UIColorFromRGB(TEXT_GRAY) forState:UIControlStateHighlighted];
        _btnFinish.titleLabel.font = [UIFont systemFontOfSize: 16.0];
        [[_btnFinish rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            LaterPeriodViewController* tabVC = self.parentViewController;
            [tabVC setTabShow:YES];
            tabVC.selectedIndex = 1;
            
            
//            [_laterPeriodVideoVC.videoFactory exportToPath:[FileUtils getFileURLProjPath:@"1108/draft" fileName:@"out_withAudio.mp4"]
//                                                complition:^(NSURL *outputPath, BOOL isSucceed) {
//                                                   NSLog(@"export finish");
//                                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                                       VideoPlayViewController *vce = [[VideoPlayViewController alloc] init];
//                                                       vce.videoPath = [FileUtils getFileProjPath:@"1108/draft" fileName:@"out_withAudio.mp4"];
//                                                       [self.navigationController pushViewController:vce animated:NO];
//                                                   });
//                                               }];
        }];
    }
    return _btnFinish;
}
@end
