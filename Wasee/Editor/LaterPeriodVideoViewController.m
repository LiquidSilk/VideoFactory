//
//  LaterPeriodViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/10.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "LaterPeriodVideoViewController.h"
//#import <LanSongEditorFramework/LanSongEditor.h>
#import "FileUtils.h"
#import "UIUitls.h"
#import "KVOController.h"
#import "StickerView.h"

@interface LaterPeriodVideoViewController ()<VideoRangeDelegate, VideoFactoryDelegate>
{
    AVPlayerLayer *playerLayer;
    id _notificationToken;
}
@property(nonatomic,strong)AVPlayer *player;
//监控进度
@property(nonatomic, strong)NSTimer *avTimer;
@property(nonatomic, strong)UIButton *btnPlay;
@property(nonatomic, strong)UIButton *btnPause;
@property(nonatomic, assign)BOOL isPlaying;
@property(nonatomic, strong)UIView* viewOverlay;
//@property(nonatomic, strong)MediaInfo* mInfo;
@end

@implementation LaterPeriodVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    //  [LanSongUtils setViewControllerPortrait];
    _projName = @"1108";
    self.videoPath = [FileUtils getFileProjPath:_projName fileName:@"backgroundVideo.mp4"];
    
    if (_videoPath!=nil)
    {
        
       
        //进度条
        [self.view addSubview:self.videoRange];
        
        //播放暂停
        [self.view addSubview:self.btnPlay];
        [self.view addSubview:self.btnPause];
        
        [self initPlayer];
        [self pause];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (self.avTimer!=NULL) {
        [self.avTimer invalidate];
        self.avTimer=NULL;
    }
    if (self.isPlaying) {
        [self.player replaceCurrentItemWithPlayerItem:nil];
    }
    if (_notificationToken) {
        [[NSNotificationCenter defaultCenter] removeObserver:_notificationToken name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        _notificationToken = nil;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(_videoRange.mas_centerY);
        make.size.mas_equalTo(30);
    }];
    
    [_btnPause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(_btnPlay);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - method
- (void)play
{
    if (_playerMode == PLAYER_MODE_RESTART)
    {
        //从头开始播放
        float time = CMTimeGetSeconds(self.player.currentItem.duration) * 0;
        [_player seekToTime:CMTimeMakeWithSeconds(time, 15) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        [_player play];
        
        self.isPlaying = YES;
        [_btnPause setHidden:NO];
        [_btnPlay setHidden:YES];
    }
    else if (_playerMode == PLAYER_MODE_NORMAL)
    {
        //从暂停位置开始播放
        [_player play];
        self.isPlaying = YES;
        [_btnPause setHidden:NO];
        [_btnPlay setHidden:YES];
    }
    if (_delegate)
    {
        [_delegate laterPeriodViewController:self onStatus:PLAYER_STATUS_START];
    }
}

- (void)restart
{
    float time = CMTimeGetSeconds(self.player.currentItem.duration) * 0;
    [_player seekToTime:CMTimeMakeWithSeconds(time, 15) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self play];
}

- (void)pause
{
    [_player pause];
    self.isPlaying = NO;
    [_btnPause setHidden:YES];
    [_btnPlay setHidden:NO];
    
    if (_delegate)
    {
        [_delegate laterPeriodViewController:self onStatus:PLAYER_STATUS_PAUSE];
    }
}

- (void)setVideoVolume:(CGFloat)volume musicVolume:(CGFloat)musicVolume voiceVolume:(CGFloat)voiceVolume
{
    [_videoFactory setVideoVolume:volume musicVolume:musicVolume voiceVolume:voiceVolume];
//    [_player replaceCurrentItemWithPlayerItem:[_videoFactory playerItem]];
}

- (void)addMusicURL:(NSURL*)musicURL
{
    [_videoFactory addMusicAssets:musicURL];
    [self refreshPlayerItem:[_videoFactory playerItem]];
}

- (void)addVoiceURL:(NSURL*)voiceURL
{
    [_videoFactory addVoiceAssets:voiceURL];
    [self refreshPlayerItem:[_videoFactory playerItem]];
}

- (void)addFilter:(NSString*)filterName
{
    [_videoFactory addFilter:filterName];
    [self refreshPlayerItem:[_videoFactory playerItem]];
}

- (void)setControlEnable:(BOOL)bEnable
{
    if (!bEnable)
    {
        _viewOverlay = [[UIView alloc] init];
        [self.view addSubview:_viewOverlay];
        [_viewOverlay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(325);
            make.bottom.mas_equalTo(90);
        }];
        _viewOverlay.backgroundColor = [UIColor clearColor];
    }
    else
    {
        [_viewOverlay removeFromSuperview];
        _viewOverlay = nil;
    }
}

- (void)removeVoice
{
    [_videoFactory removeVoice];
}

- (UIImage *)getScreenShotImageAt:(float)time
{
    AVAsset *videoAsset = _videoFactory.composition;
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:videoAsset];
    CMTime cmtime = CMTimeMakeWithSeconds(time, videoAsset.duration.timescale);
    NSError *error = nil;
    CMTime actualTime;
    imageGenerator.videoComposition = _videoFactory.videoComposition;
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.appliesPreferredTrackTransform = YES;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:cmtime actualTime:NULL error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
        
    }
    UIImage *image = [UIImage imageWithCGImage:cgImage];//转化为UIImage
    
    return image;
}

- (void)addVideoRangeSelector:(NSString*)key {
    [_videoRange addRangeSelector:key];
}

- (void)removeRangeSelectorWithKey:(NSString*)key
{
    [_videoRange removeRangeSelectorWithKey:key];
}

- (NSMutableDictionary*)getRangeMap
{
    NSMutableDictionary* rangeMap = [NSMutableDictionary dictionaryWithCapacity:5];
    NSMutableDictionary* map = [_videoRange getRangeMap];
    
    CMTime   time = [_videoFactory.composition duration];
    int seconds = ceil(time.value/time.timescale);
    for (id key in map)
    {
        NSArray* item = [map objectForKey:key];
        float t1 = [[item objectAtIndex:0] floatValue] * seconds;
        float t2 = [[item objectAtIndex:1] floatValue] * seconds;
        NSLog(@"%.2f------%.2f", t1, t2);
        
        NSArray* newItem = [NSArray arrayWithObjects:[NSNumber numberWithFloat:t1], [NSNumber numberWithFloat:t2], nil];
        [rangeMap setObject:newItem forKey:key];
    }
    return rangeMap;
}

#pragma mark - 私有方法
-(void)initPlayer
{
    
    _videoFactory = [[VideoFactory alloc] initWithName:@"1108" view:nil path:_videoPath];
    _videoFactory.delegate = self;
    
    //设置播放的项目
    self.player = [[AVPlayer alloc] init];
    [self.player replaceCurrentItemWithPlayerItem:[_videoFactory playerItem]];  //初始化player对象
    
    //设置播放页面
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    
    playerLayer.frame = CGRectMake(0, XFHeadViewMinH, kScreenW, 240);
    playerLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];
    
    //进度条
    [self.KVOController observe:_player.currentItem keyPath:@"status" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
        if (status == AVPlayerStatusReadyToPlay)
        {
            self.avTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        }
        else if (status == AVPlayerStatusFailed)
        {
            NSLog(@"AVPlayerStatusFailed == %@", playerItem.error);
            return;
        }
        else if (status == AVPlayerStatusUnknown)
        {
            return;
        }
    }];
    
    [self setPlayerLoop];
    //设置最大值最小值音量
    //    self.volume.maximumValue =10.0f;
    //    self.volume.minimumValue =0.0f;
    
}

- (void)setPlayerLoop
{
    if (_notificationToken)
        _notificationToken = nil;
    
    //设置播放结束后的动作
    _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    _notificationToken = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [_player.currentItem seekToTime:kCMTimeZero];  //这个是循环播放的.
        [self pause];
        if (_delegate)
        {
            [_delegate laterPeriodViewController:self onStatus:PLAYER_STATUS_FINISH];
        }
        
    }];
    
    
//    [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
   
}

- (void)refreshPlayerItem:(AVPlayerItem*)playerItem
{
    [_avTimer invalidate];
    _avTimer = nil;
    
    if (_notificationToken) {
        [[NSNotificationCenter defaultCenter] removeObserver:_notificationToken name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        _notificationToken = nil;
    }
    
    //添加观察者
    [self.KVOController observe:playerItem keyPath:@"status" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
        if (status == AVPlayerStatusReadyToPlay)
        {
            self.avTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        }
        else if (status == AVPlayerStatusFailed)
        {
            NSLog(@"AVPlayerStatusFailed == %@", playerItem.error);
            return;
        }
        else if (status == AVPlayerStatusUnknown)
        {
            return;
        }
    }];
    //播放当前资源
    [_player replaceCurrentItemWithPlayerItem:playerItem];
    
    [self setPlayerLoop];
}


//监控播放进度方法
- (void)timer
{
    if (self.isPlaying) {
        float  timepos= (float)self.player.currentItem.currentTime.value;
        timepos/=(float)self.player.currentItem.currentTime.timescale;  //timescale, 时间刻度.
        float progress = CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);

        [_videoRange setSliderPercent:progress];
    }
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    AVPlayerItem *playerItem = (AVPlayerItem *)object;
//    if ([keyPath isEqualToString:@"status"])
//    {
//        AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
//        if (status == AVPlayerStatusReadyToPlay)
//        {
//            // 停止缓存动画，开始播放
//            // 设置视频的总时长
//            self.avTimer=[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timer) userInfo:nil repeats:YES];
//        } else if (status == AVPlayerStatusFailed)
//        {
//            NSLog(@"AVPlayerStatusFailed == %@", playerItem.error);
//            return;
//        }
//        else if (status == AVPlayerStatusUnknown)
//        {
//            return;
//        }
//    }
//    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
//    {
//        // 处理缓冲进度条
//    }
//    else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
//    {
//
//    }
//}

#pragma mark - videoRangeDelegate

- (void)videoRangeOnMoveSlider:(float)percent
{
    if (self.isPlaying)
    {
        [self pause];
    }
    float time = CMTimeGetSeconds(self.player.currentItem.duration) * percent;
    [_player seekToTime:CMTimeMakeWithSeconds(time, 15) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)videoRangeOnSelectedEndSlider:(float)percent
{
    float videoTime = CMTimeGetSeconds(self.player.currentItem.duration) * percent;
    
    AVAsset *videoAsset = _videoFactory.composition;
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:videoAsset];
    CMTime time = CMTimeMakeWithSeconds(videoTime, videoAsset.duration.timescale);
    NSError *error = nil;
    CMTime actualTime;
    imageGenerator.videoComposition = _videoFactory.videoComposition;
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.appliesPreferredTrackTransform = YES;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:NULL error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return;
        
    }
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];//转化为UIImage
    
    if (_delegate) {
        [_delegate laterPeriodViewController:self onSelecedImage:image];
    }
//    UIImageView* bb = [[UIImageView alloc] initWithImage:image];
//    [self.view addSubview:bb];
//    [bb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(65);
//        make.width.mas_equalTo(135);
//        make.height.mas_equalTo(240);
//    }];
}

- (void)videoRangeInRangeWithKey:(NSString*)key
{
    if (_delegate) {
        [_delegate laterPeriodViewController:self inRangeWithKey:key];
    }
}

- (void)videoRangeOutRangeWithKey:(NSString*)key
{
    if (_delegate) {
        [_delegate laterPeriodViewController:self outRangeWithKey:key];
    }
}

- (void)onFilterComplete
{
    [self refreshPlayerItem:[_videoFactory playerItem]];
    float time = CMTimeGetSeconds(self.player.currentItem.duration) * 0;
    [_player seekToTime:CMTimeMakeWithSeconds(time, 15) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self play];
}

#pragma mark - getter
- (VideoRange*)videoRange
{
    if (!_videoRange)
    {
        _videoRange = [[VideoRange alloc] initWithFrame:CGRectMake(30, 325, self.view.frame.size.width - 30, 70) fileURL:[NSURL fileURLWithPath:_videoPath]  useProgress:YES];
        _videoRange.projName = _projName;
        _videoRange.rangeDelegate = self;
        [_videoRange setSliderPercent:0];
    }
    return _videoRange;
}

- (UIButton*)btnPlay
{
    if (!_btnPlay)
    {
        _btnPlay = [[UIButton alloc] init];
        [_btnPlay setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [[_btnPlay rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self play];
        }];
    }
    return _btnPlay;
}

- (UIButton*)btnPause
{
    if (!_btnPause)
    {
        _btnPause = [[UIButton alloc] init];
        [_btnPause setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [[_btnPause rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self pause];
        }];
    }
    return _btnPause;
}

@end
