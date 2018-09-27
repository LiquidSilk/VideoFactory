//
//  MediaUtil.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/6.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "MediaUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "FileUtils.h"
#import "UIUitls.h"

@implementation MediaUtil


+ (void)cutMedia:(NSURL*)sourceUrl
     outFileName:(NSString*)outFileName
  containerFrame:(CGSize)size
          target:(id)target
        selector:(SEL)aSelector
      onComplete:(void(^)())block
{
    AVURLAsset *asset = [[AVURLAsset alloc]initWithURL:sourceUrl options:nil];
    NSTimeInterval duration = CMTimeGetSeconds(asset.duration);
    
    //拍摄时间总长
    Float64 totalSecconds = duration;
    //每秒录制帧数
    int32_t framesPerSecond = 20;
    AVMutableComposition *composion = [[AVMutableComposition alloc]init];
    CMPersistentTrackID ida = 0;
    
    AVMutableCompositionTrack *firstTrack = [composion addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:ida];
    AVMutableCompositionTrack *audioTrack = [composion addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:ida];
    CMTime inserTime = kCMTimeZero;
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[asset tracksWithMediaType:AVMediaTypeVideo][0] atTime:inserTime error:nil];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[asset tracksWithMediaType:AVMediaTypeAudio][0] atTime:inserTime error:nil];
    inserTime = CMTimeAdd(inserTime, asset.duration);
    
    //todo
//    CGSize renderSize = CGSizeMake(firstTrack.naturalSize.width, firstTrack.naturalSize.width);
    NSInteger originWidth = firstTrack.naturalSize.width;
    NSInteger originHeight = firstTrack.naturalSize.height;
    NSInteger targetWidth = size.width;
    NSInteger targetHeight = size.height;
    NSInteger width = MAX(originWidth, targetWidth);
    NSInteger height = MAX(originHeight, targetHeight);
    CGSize renderSize = CGSizeMake(targetWidth, targetHeight);
    
    
    
    AVMutableVideoComposition *videoComposition = [[AVMutableVideoComposition alloc] init];
    videoComposition.frameDuration = CMTimeMake(1, framesPerSecond);
    videoComposition.renderSize = renderSize;
    
    AVMutableVideoCompositionInstruction* instruction = [[AVMutableVideoCompositionInstruction alloc]init];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(totalSecconds, framesPerSecond));
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
//    CGAffineTransform t1 = CGAffineTransformMakeTranslation(-(firstTrack.naturalSize.width-renderSize.width) / 2, -(firstTrack.naturalSize.height-renderSize.height)/2 );
    //                CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
    //                CGAffineTransform finalTransform = t1;
    NSInteger tx = (targetWidth - originWidth) / 2;
    NSInteger ty = (targetHeight - originHeight) / 2;
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(tx, ty);
    CGAffineTransform t2 = CGAffineTransformScale(t1, 0.5, 0.5);
    [transformer setTransform:t1 atTime:kCMTimeZero];
    instruction.layerInstructions = @[transformer];
    
    videoComposition.instructions = @[instruction];
    

    //处理后的视频路径
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:outFileName]){
        [manager removeItemAtPath:outFileName error:nil];
    }
    NSURL *videoPath = [NSURL fileURLWithPath:outFileName];
    
    //对视频做相应的压缩
    AVAssetExportSession* exporter = [[AVAssetExportSession alloc]initWithAsset:composion presetName:AVAssetExportPresetHighestQuality];//压缩等级
    exporter.outputURL = videoPath;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.videoComposition = videoComposition;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(totalSecconds, framesPerSecond));
    
    NSTimer* timerProgress = [NSTimer scheduledTimerWithTimeInterval:0.1 target:target selector:aSelector userInfo:exporter repeats:YES];
    
    //处理成功后
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if ([exporter status] == AVAssetExportSessionStatusCompleted) {
            NSLog(@"压缩裁剪后的视频路径:%@", outFileName);
            if (block) {
                [timerProgress invalidate];
                block();
            }
        }else{
            NSLog(@"当前压缩进度:%f",exporter.progress);
        }
        NSLog(@"%@",exporter.error);
    }];
}


+ (void)generateWhiteVideoWithSize:(CGSize)size
                          duration:(int)duration
                          projName:(NSString*)projName
                        onComplete:(void(^)())onComplete
{
    NSString* fileName = [NSString stringWithFormat:@"bg.mp4"];
    NSURL *exportUrl = [FileUtils getFileURLProjPath:projName fileName:fileName];
    
    if(![FileUtils fileExist:projName fileName:fileName])
    {
        [FileUtils createDir:projName];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            float originWidth = size.width;
            float originHeight = size.height;
            
            UIImage* imageWhite = [UIImage imageNamed:@"video_white_bg"];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(originWidth, originHeight), NO, 0.0);
            [imageWhite drawInRect:CGRectMake(0, 0, originWidth, originHeight)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [UIUtils compressImages: newImage frameRate:25 duration:duration exportUrl:exportUrl completion:^(NSURL *outurl) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"");
                     onComplete();
                 });
            }];
        });
    }
}

+ (void)generateTransparentWithSize:(CGSize)size
                           projName:(NSString *)projName
                           fileName:(NSString *)fileName
                              image:(UIImage*)image
                           onFinish:(void(^)())finishBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *exportUrl = [FileUtils getFileProjPath:projName fileName:fileName];
//        if(![FileUtils fileExist:projName fileName:fileName])
        {
            [FileUtils createDir:projName];
            UIImage* imageWhite = [UIImage imageNamed:@"transparent"];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0.0);
            [imageWhite drawInRect:CGRectMake(0, 0, size.width, size.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [UIImagePNGRepresentation(newImage) writeToFile:exportUrl atomically:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                finishBlock();
            });
        }
    });
}

+ (void)editVideoSynthesizeVieoPath:(NSURL*)assetURL
                      originBGMPath:(NSURL*)originBGMPath
                    originBGMVolume:(CGFloat)originBGMVolume
                          voicePath:(NSURL*)voiceURLPath
                        voiceVolume:(CGFloat)voiceVolume
                        videoVolume:(CGFloat)videoVolume
                         outputPath:(NSURL*)outputPath
                         complition:(void (^)(NSURL* outputPath,BOOL isSucceed)) completionHandle
{
    BOOL bVoiceURLPathExist = YES;
    if (![FileUtils fileExist:voiceURLPath])
    {
        bVoiceURLPathExist = NO;
    }
    //素材
    AVAsset *asset = [AVAsset assetWithURL:assetURL];
    AVAsset *originAudioAsset = [AVAsset assetWithURL:originBGMPath];
    AVAsset *voiceAsset = [AVAsset assetWithURL:voiceURLPath];
    
    CMTime duration = asset.duration;
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero, duration);
    
    //分离素材
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];//视频素材
    AVAssetTrack *audioAssetTrack = [[originAudioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];// 背景音乐音频素材
    AVAssetTrack *voiceAssetTrack = nil;
    if (bVoiceURLPathExist) {
        voiceAssetTrack = [[voiceAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];//录音
    }
    
    
    
    //创建编辑环境
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    
    //视频素材加入视频轨道
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoCompositionTrack insertTimeRange:video_timeRange ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    
    //音频素材加入音频轨道
    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioCompositionTrack insertTimeRange:video_timeRange ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    //录音加入音频轨道
    AVMutableCompositionTrack *voiceCompositionTrack = nil;
    if (bVoiceURLPathExist)
    {
        voiceCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [voiceCompositionTrack insertTimeRange:video_timeRange ofTrack:voiceAssetTrack atTime:kCMTimeZero error:nil];
    }
    
    //创建导出素材类
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    
    
    //    设置输出路径
//    NSURL *outputPath = [self exporterPath];
    exporter.outputURL = outputPath;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;//指定输出格式
    exporter.shouldOptimizeForNetworkUse= YES;
    
    //    音量控制
//    exporter.audioMix = [self buildAudioMixWithVideoTrack:originalAudioCompositionTrack VideoVolume:videoVolume BGMTrack:audioCompositionTrack BGMVolume:BGMVolume atTime:kCMTimeZero];
    exporter.audioMix = [self buildAudioMixWithVideoTrack:audioCompositionTrack
                                              VideoVolume:originBGMVolume
                                               voiceTrack:voiceCompositionTrack
                                              voiceVolume:voiceVolume
                                                   atTime:kCMTimeZero];
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed: {
                NSLog(@"合成失败：%@",[[exporter error] description]);
                completionHandle(outputPath,NO);
            } break;
            case AVAssetExportSessionStatusCancelled: {
                completionHandle(outputPath,NO);
            } break;
            case AVAssetExportSessionStatusCompleted: {
                completionHandle(outputPath,YES);
            } break;
            default: {
                completionHandle(outputPath,NO);
            } break;
        }
    }];
}

#pragma mark - 调节合成的音量
+ (AVAudioMix *)buildAudioMixWithVideoTrack:(AVCompositionTrack *)videoTrack
                                VideoVolume:(float)videoVolume
                                 voiceTrack:(AVCompositionTrack *)voiceTrack
                                voiceVolume:(float)voiceVolume
                                     atTime:(CMTime)volumeRange
{
    NSMutableArray<AVAudioMixInputParameters *> *trackMixArray = [NSMutableArray<AVAudioMixInputParameters *> array];
    //创建音频混合类
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    
    //拿到视频声音轨道设置音量
//    AVMutableAudioMixInputParameters *videoparameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:videoTrack];
//    [videoparameters setVolume:videoVolume atTime:volumeRange];
    
    //加入混合数组
//    audioMix.inputParameters = @[videoparameters];
    
//    if (voiceTrack)
//    {
//        //设置录音音量
//        AVMutableAudioMixInputParameters *voiceParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:voiceTrack];
//        [voiceParameters setVolume:voiceVolume atTime:volumeRange];
//        audioMix.inputParameters = @[videoparameters, voiceParameters];
//    }
    
    AVMutableAudioMixInputParameters *trackMix1 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:videoTrack];
    trackMix1.trackID = videoTrack.trackID;
    [trackMix1 setVolume:videoVolume atTime:kCMTimeZero];
    [trackMixArray addObject:trackMix1];
    
    
    AVMutableAudioMixInputParameters *trackMix2 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:voiceTrack];
    trackMix2.trackID = voiceTrack.trackID;
    [trackMix2 setVolume:voiceVolume atTime:kCMTimeZero];
    [trackMixArray addObject:trackMix2];
    
    
    audioMix.inputParameters = trackMixArray;
    return audioMix;
}

#pragma mark - 音视频剪辑,如果是视频把下面的类型换为AVFileTypeAppleM4V
+ (void)cutAudioVideoResourcePath:(NSURL *)assetURL startTime:(CGFloat)startTime endTime:(CGFloat)endTime complition:(void (^)(NSURL *outputPath,BOOL isSucceed)) completionHandle{
    //    素材
    AVAsset *asset = [AVAsset assetWithURL:assetURL];
    
    //    导出素材
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    
    //剪辑(设置导出的时间段)
    CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(endTime - startTime,asset.duration.timescale);
    exporter.timeRange = CMTimeRangeMake(start, duration);
    
    //    输出路径
    NSURL *outputPath = [self exporterPath];
    exporter.outputURL = [self exporterPath];
    
    //    输出格式
    exporter.outputFileType = AVFileTypeAppleM4A;
    
    exporter.shouldOptimizeForNetworkUse= YES;
    
    //    合成后的回调
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed: {
                NSLog(@"合成失败：%@",[[exporter error] description]);
                completionHandle(outputPath,NO);
            } break;
            case AVAssetExportSessionStatusCancelled: {
                completionHandle(outputPath,NO);
            } break;
            case AVAssetExportSessionStatusCompleted: {
                completionHandle(outputPath,YES);
            } break;
            default: {
                completionHandle(outputPath,NO);
            } break;
        }
    }];
}


#pragma mark - 输出路径
+ (NSURL *)exporterPath {
    
    NSInteger nowInter = (long)[[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"output%ld.mp4",(long)nowInter];
    
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *outputFilePath =[documentsDirectory stringByAppendingPathComponent:fileName];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:outputFilePath]){
        
        [[NSFileManager defaultManager]removeItemAtPath:outputFilePath error:nil];
    }
    
    return [NSURL fileURLWithPath:outputFilePath];
}

@end
