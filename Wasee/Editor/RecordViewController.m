//
//  RecordViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/13.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "RecordViewController.h"
#import "Utils.h"
#import "UIUitls.h"
#import <AVFoundation/AVFoundation.h>
#import "MediaUtil.h"

static const NSString* RECORD_FILE_NAME = @"record.wav";

@interface RecordViewController ()

@property(nonatomic, strong)UIButton* btnStartRecord;
@property(nonatomic, strong)UIButton* btnStopRecord;
@property(nonatomic, strong)UIButton* btnDeleteRecord;
@property(nonatomic, strong)AVAudioRecorder* recorder;
//@property(nonatomic, strong)LanSongAudioRecorder* lansongRecorder;
@property(nonatomic, strong)AVAudioPlayer* recorderPlayer;
@property(nonatomic, assign)BOOL bIsRecording;
@property(nonatomic, assign)BOOL bHasRecorder;
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.btnStartRecord];
    [self.view addSubview:self.btnStopRecord];
    [self.view addSubview:self.btnDeleteRecord];
    
    [self initRecord];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_btnStartRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(106, 106));
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-20);
    }];
    
    [_btnStopRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(_btnStartRecord);
    }];
    
    [_btnDeleteRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(_btnStartRecord);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - method
- (void)startRecord
{
    [_btnStartRecord setHidden:YES];
    [_btnStopRecord setHidden:NO];
    [_btnDeleteRecord setHidden:YES];
    
    if (_delegate)
    {
        [_delegate recordViewController:self onPushButton:BTN_TYPE_START path:@""];
    }
    [self doStartRecord];
}

- (void)stopRecord
{
    if (_bIsRecording)
    {
        [_btnStartRecord setHidden:YES];
        [_btnStopRecord setHidden:YES];
        [_btnDeleteRecord setHidden:NO];
        
        NSString* recordPath = [self doStopRecord];
        NSString* draftPath = [NSString stringWithFormat:@"%@", _projName];
        NSString* recordOutPath = [FileUtils getFileProjPath:draftPath fileName:RECORD_FILE_NAME];
//        [LanSongFileUtil copyFile:recordPath toPath: recordOutPath];
//        [LanSongFileUtil deleteFile:recordPath];
        if (_delegate)
        {
            [_delegate recordViewController:self onPushButton:BTN_TYPE_STOP path:recordOutPath];
        }
//        _recorder ;
    }
}

- (void)initRecord
{
    [_btnStartRecord setHidden:NO];
    [_btnStopRecord setHidden:YES];
    [_btnDeleteRecord setHidden:YES];
    
    _bHasRecorder = NO;
    
    NSString* path = [NSString stringWithFormat:@"%@/draft", _projName];
    [FileUtils deleteFile:path fileName:RECORD_FILE_NAME];
    [self setRecorderPlayer:nil];
    
    if (_delegate)
    {
        [_delegate recordViewController:self onPushButton:BTN_TYPE_DELETE path:@""];
    }
}

- (void)doStartRecord
{
    NSLog(@"开始录音");
    
//        self.session = session;
    
    if (self.recorder)
    {
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        _bIsRecording = YES;
    }
//    if (self.lansongRecorder)
//    {
//        [_lansongRecorder startRecord];
//        _bIsRecording = YES;
//    }
//    else
//    {
//        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
//    }
}

- (NSString*)doStopRecord
{
    if (_recorder) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
        _bHasRecorder = YES;
        _bIsRecording = NO;
        [_recorder stop];
        NSString* path = [NSString stringWithFormat:@"%@", _projName];
        NSString* recordFile = [FileUtils getFileProjPath:path fileName:@"record.wav"];
        //2.设置参数
        return recordFile;
    }
//    if (_lansongRecorder)
//    {
//        _bHasRecorder = YES;
//        _bIsRecording = NO;
//        NSString* recordPath = [_lansongRecorder stopRecord];
//        [self setLansongRecorder:nil];
//
//        return recordPath;
////        NSString* videoFile = [FileUtils getFileProjPath:@"1108" fileName:@"backgroundVideo.mp4"];
////        NSString* outFile = [FileUtils getFileProjPath:@"1108" fileName:@"out.mp4"];
////        NSString* audioFile = [FileUtils getFileProjPath:@"1108/draft" fileName:recordFileName];
////        [VideoEditor executeVideoMergeAudio:videoFile audioFile:audioFile dstFile:outFile audioStartS:1.0];
////        executeVideoMergeAudio:(NSString*)videoFile audioFile:(NSString *)audioFile dstFile:(NSString *)dstFile audioStartS:(float)audiostartS;
//    }
    return @"";
}

- (void)show:(BOOL)bShow
{
    self.view.hidden = !bShow;
}

#pragma mark - 音频播放器
- (void)startRecordPalyer
{
    if(_bHasRecorder == YES)
    {
        //有录音才播放
//        [self.recorderPlayer setCurrentTime:0.0];
//        [self.recorderPlayer prepareToPlay];
//        [self.recorderPlayer play];
    }
}

- (void)pauseRecordPalyer
{
    if(_bHasRecorder == YES)
    {
        //有录音才播放
        [self.recorderPlayer pause];
    }
}

#pragma mark - getter
- (UIButton*)btnStartRecord
{
    if (!_btnStartRecord)
    {
        _btnStartRecord = [[UIButton alloc] init];
        [_btnStartRecord setImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
        [[_btnStartRecord rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self startRecord];
        }];
    }
    return _btnStartRecord;
}

- (UIButton*)btnStopRecord
{
    if (!_btnStopRecord)
    {
        _btnStopRecord = [[UIButton alloc] init];
        [_btnStopRecord setImage:[UIImage imageNamed:@"停止录音"] forState:UIControlStateNormal];
        [[_btnStopRecord rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self stopRecord];
        }];
        
        UIButton* btnStopRecord = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 59, 80)];
        [btnStopRecord setImage:[UIImage imageNamed:@"停止录音"] forState:UIControlStateNormal];
        [[btnStopRecord rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
//            [FileUtils deleteFile:@"1108" fileName:@"backgroundVideo2.mp4"];
////            [MediaUtil editVideoSynthesizeVieoPath:[FileUtils getFileURLProjPath:@"1108" fileName:@"backgroundVideo.mp4"]
////                                           BGMPath:[FileUtils getFileURLProjPath:@"1108/draft" fileName:RECORD_FILE_NAME]
////                                 needOriginalVoice:NO
////                                       videoVolume:0.1
////                                         BGMVolume:0.9
////                                        outputPath:[FileUtils getFileURLProjPath:@"1108" fileName:@"backgroundVideo2.mp4"]
////                                        complition:^(NSURL *outputPath, BOOL isSucceed) {
////                                            NSLog(@"isSucceed = %d, outputPath = %@", isSucceed, outputPath);
////                                        }];
//            [MediaUtil editVideoSynthesizeVieoPath:[FileUtils getFileURLProjPath:@"1108" fileName:@"backgroundVideo.mp4"]
//                originBGMPath:[FileUtils getFileURLProjPath:@"1108" fileName:@"backgroundAudio.mp3"]
//                originBGMVolume:0.1
//                voicePath:[FileUtils getFileURLProjPath:@"1108/draft" fileName:RECORD_FILE_NAME]
//                voiceVolume:0.9
//                videoVolume:0.9
//                outputPath:[FileUtils getFileURLProjPath:@"1108" fileName:@"backgroundVideo2.mp4"]
//                complition:^(NSURL *outputPath, BOOL isSucceed) {
//                    NSLog(@"isSucceed = %d, outputPath = %@", isSucceed, outputPath);
//                }];
//
//            [FileUtils deleteFile:@"1108" fileName:@"backgroundVideo3.mp4"];
//            [MediaUtil editVideoSynthesizeVieoPath:[FileUtils getFileURLProjPath:@"1108" fileName:@"backgroundVideo.mp4"]
//                                     originBGMPath:[FileUtils getFileURLProjPath:@"1108" fileName:@"backgroundAudio.mp3"]
//                                   originBGMVolume:0.9
//                                         voicePath:[FileUtils getFileURLProjPath:@"1108/draft" fileName:RECORD_FILE_NAME]
//                                       voiceVolume:0.1
//                                       videoVolume:0.9
//                                        outputPath:[FileUtils getFileURLProjPath:@"1108" fileName:@"backgroundVideo3.mp4"]
//                                        complition:^(NSURL *outputPath, BOOL isSucceed) {
//                                            NSLog(@"isSucceed = %d, outputPath = %@", isSucceed, outputPath);
//                                        }];
        }];
//        [self.view addSubview:btnStopRecord];
    }
    return _btnStopRecord;
}

- (UIButton*)btnDeleteRecord
{
    if (!_btnDeleteRecord)
    {
        _btnDeleteRecord = [[UIButton alloc] init];
        [_btnDeleteRecord setImage:[UIImage imageNamed:@"删除录音"] forState:UIControlStateNormal];
        [[_btnDeleteRecord rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self initRecord];
        }];
    }
    return _btnDeleteRecord;
}

- (AVAudioRecorder*)recorder
{
    if (!_recorder)
    {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if (session == nil)
        {
            NSLog(@"Error creating session: %@",[sessionError description]);
        }
        else
        {
            [session setActive:YES error:nil];
        }
        
        //1.获取沙盒地址
        NSString* path = [NSString stringWithFormat:@"%@", _projName];
        NSURL* recordFile = [FileUtils getFileURLProjPath:path fileName:RECORD_FILE_NAME];
        //2.设置参数
        NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                       [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                       // 音频格式
                                       [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                       //采样位数  8、16、24、32 默认为16
                                       [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                       // 音频通道数 1 或 2
                                       [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                       //录音质量
                                       [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                       nil];
        
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:recordFile settings:recordSetting error:nil];
    }
    return _recorder;
}

//- (LanSongAudioRecorder*)lansongRecorder
//{
//    if (!_lansongRecorder)
//    {
//        NSString* path = [NSString stringWithFormat:@"%@/draft", _projName];
//        NSURL* recordFile = [FileUtils getFileURLProjPath:path fileName:RECORD_FILE_NAME];
////        _lansongRecorder = [[LanSongAudioRecorder alloc] initWithSampleRate:8000.0 chnls:2 saveUrl:recordFile];
//        _lansongRecorder = [[LanSongAudioRecorder alloc] initWithSampleRate:8000.0 chnls:2];
//    }
//    return _lansongRecorder;
//}

- (AVAudioPlayer*)recorderPlayer
{
    if (!_recorderPlayer)
    {
        NSString* path = [NSString stringWithFormat:@"%@/draft", _projName];
        NSURL* recordFile = [FileUtils getFileURLProjPath:path fileName:RECORD_FILE_NAME];
        NSError *error;
        _recorderPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordFile error:&error];
        if (error == nil)
        {
            _recorderPlayer.numberOfLoops = 0;//循环播放
            _recorderPlayer.volume = 0.5;
            
            [_recorderPlayer prepareToPlay];//预先加载音频到内存，播放更流畅
            
            //播放音频，同时调用视频播放，实现同步播放
            [_recorderPlayer play];
        }
        else
        {
            NSLog(@"%@",error);
        }
    }
    
    return _recorderPlayer;
}
@end
