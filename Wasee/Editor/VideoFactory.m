//
//  VideoFactory.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/17.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "VideoFactory.h"
#import "FileUtils.h"
#import "GPUImage.h"
#import "StickerView.h"

static const int WATER_OFFSET = 10086;
@interface VideoFactory()
{
    CGFloat _originAudioVolume;
    CGFloat _voiceVolume;
    CGFloat _musicVolume;
}

@property(nonatomic, copy)NSString *projName;
@property(nonatomic, strong)AVMutableCompositionTrack *originAudioCompositionTrack;//视频原音
@property(nonatomic, strong)AVMutableCompositionTrack *voiceCompositionTrack;
@property(nonatomic, strong)AVMutableCompositionTrack *musicCompositionTrack;
@property(nonatomic, strong)AVVideoCompositionCoreAnimationTool* animationTool;
@property(nonatomic, assign)CMTimeRange videoTimeRange;
@property(nonatomic, assign)CGSize sizeOfVideo;
@property(nonatomic, strong)CALayer *parentLayer;
@property(nonatomic, strong)CALayer *videoLayer;
@property(nonatomic, strong)CALayer *overlayLayer;
@property(nonatomic, strong)AVAsset *originVideoAsset;
@property(nonatomic, strong)GPUImageMovie * gpuMovie;
@property(nonatomic, strong)NSTimer* sampleTimer;
@property(nonatomic, strong)CIFilter *videoFilter;
@property(nonatomic, strong)NSMutableArray *waterList;
@end



@implementation VideoFactory


- (instancetype)initWithName:(NSString*)projName view:(UIView*)view path:(NSString*)path
{
    self = [super init];
    if (self)
    {
        _originAudioVolume = 0.5;
        _voiceVolume = 0.5;
        _musicVolume = 0.5;
        _waterList = [NSMutableArray arrayWithCapacity:10];
        self.projName = projName;
        [self initFactory:view path:path];
    }
    return self;
}

- (void)initFactory:(UIView*)view path:(NSString*)path
{
    NSURL* originVideoURL = [NSURL fileURLWithPath:path];//[FileUtils getFileURLProjPath:_projName fileName:@"backgroundVideo.mp4"];
    NSURL* originBGMPath = [FileUtils getFileURLProjPath:_projName fileName:@"backgroundAudio.mp3"];
    _originVideoAsset = [AVAsset assetWithURL:originVideoURL];
    AVAsset *originAudioAsset = [AVAsset assetWithURL:originBGMPath];
    
    AVAssetTrack *videoAssetTrack = [[_originVideoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];//视频素材
    AVAssetTrack *audioAssetTrack = [[originAudioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];// 背景音乐音
    
    
    _composition = [[AVMutableComposition alloc] init];
    CMTime duration = _originVideoAsset.duration;
    _videoTimeRange = CMTimeRangeMake(kCMTimeZero, duration);
    
    //视频素材加入视频轨道
    AVMutableCompositionTrack *videoCompositionTrack = [_composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoCompositionTrack insertTimeRange:_videoTimeRange ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    
    
    //音频素材加入音频轨道
    _originAudioCompositionTrack = [_composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [_originAudioCompositionTrack insertTimeRange:_videoTimeRange ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    
   
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    _videoComposition = [AVMutableVideoComposition videoCompositionWithAsset:_originVideoAsset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
//        CIImage *source = request.sourceImage.imageByClampingToExtent;
//        int currentTime = request.compositionTime.value / request.compositionTime.timescale;
////        if (currentTime < 3) {
////            [request finishWithImage:source context:nil];
////        } else {
//            [filter setValue:source forKey:kCIInputImageKey];
//
//            CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
//            [request finishWithImage:output context:nil];
////        }
//    }];
    
    
    _videoComposition = [AVMutableVideoComposition videoComposition];
    NSMutableArray *instructions = [NSMutableArray array];
    AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    passThroughInstruction.timeRange = _videoTimeRange;
    AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
    passThroughInstruction.layerInstructions = [NSArray arrayWithObject:passThroughLayer];
    [instructions addObject:passThroughInstruction];
    _videoComposition.instructions = instructions;
    
//    CIFilter *filter = [CIFilter filterWithName:@""];
//    CIFilter *watermarkFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
//    _videoComposition = [AVMutableVideoComposition videoCompositionWithAsset:_originVideoAsset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request)
//                         {
//                             if(!filter)
//                             {
//                                 [request finishWithImage:request.sourceImage.imageByClampingToExtent context:nil];
//                                 return ;
//                             }
//                             float currentTime = request.compositionTime.value / request.compositionTime.timescale;
//                             CIImage *source = request.sourceImage.imageByClampingToExtent;
//                             [filter setValue:source forKey:kCIInputImageKey];
//
//                             CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
//
//
//
//                             UIImage* image = [UIImage imageNamed:@"lena"];
//                             CIImage *watermarkImage = [[CIImage alloc] initWithCGImage:image.CGImage];
//
//                             if (currentTime > 1 && currentTime < 8) {
//                                 [watermarkFilter setValue:output forKey:kCIInputBackgroundImageKey];
//
//                                 [watermarkFilter setValue:[watermarkImage imageByApplyingTransform:CGAffineTransformMakeScale(0.5, 0.5)] forKey:kCIInputImageKey];
//
//                                 [request finishWithImage:watermarkFilter.outputImage context:nil];
//                             }
//                             else
//                             {
//
//                                 [request finishWithImage:output context:nil];
//                             }
//
//
//                         }];
    
    
    
    
    

    
    
    NSMutableArray<AVAudioMixInputParameters *> *trackMixArray = [NSMutableArray<AVAudioMixInputParameters *> array];
    {
        AVMutableAudioMixInputParameters *trackMix1 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:_originAudioCompositionTrack];
        trackMix1.trackID = _originAudioCompositionTrack.trackID;
        [trackMix1 setVolume:_originAudioVolume atTime:kCMTimeZero];
        [trackMixArray addObject:trackMix1];
    }
    _audioMix.inputParameters = trackMixArray;
    
    
    _sizeOfVideo = [videoAssetTrack naturalSize];
    //Image of watermark
//    UIImage *myImage=[UIImage imageNamed:@"avatar"];
//    CALayer* layerCa = [CALayer layer];
//    layerCa.contents = (id)image.CGImage;
//    layerCa.frame = CGRectMake(0, 0, _sizeOfVideo.width, _sizeOfVideo.height);
//    layerCa.opacity = 0.4;
    
    _overlayLayer = [CALayer layer];
    _overlayLayer.frame = CGRectMake(0, 0, _sizeOfVideo.width, _sizeOfVideo.height);
    [_overlayLayer setMasksToBounds:YES];
    
    _parentLayer = [CALayer layer];
    _parentLayer.frame = CGRectMake(0, 0, _sizeOfVideo.width, _sizeOfVideo.height);
    _videoLayer = [CALayer layer];
    _videoLayer.frame = CGRectMake(0, 0, _sizeOfVideo.width, _sizeOfVideo.height);
    // 这里看出区别了吧，我们把overlayLayer放在了videolayer的上面，所以水印总是显示在视频之上的。
    [_parentLayer addSublayer:_videoLayer];
    [_parentLayer addSublayer:_overlayLayer];
    
    
    if (_videoComposition) {
        _videoComposition.frameDuration = CMTimeMake(1, 25);
        _videoComposition.renderSize = videoAssetTrack.naturalSize;
    }
}

- (void)removeAllSubLayer
{
    NSArray* list = _overlayLayer.sublayers;
    [[list copy] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CALayer * subLayer = obj;
        [subLayer removeFromSuperlayer];
    }];
}

- (void)addWater:(Sticker*)view startTime:(CGFloat)start endTime:(CGFloat)end ratio:(float)ratio originHeight:(float)originHeight
{
    float curScale = view.transform.a;
    BOOL viewHidden = [view isHidden];
    [view setHidden:NO];
    view.frame = CGRectMake(view.frame.origin.x * ratio + WATER_OFFSET,
                            view.frame.origin.y * ratio + WATER_OFFSET,
                            CGRectGetWidth(view.frame) * ratio * curScale,
                            CGRectGetHeight(view.frame) * ratio * curScale);
//    view.frame = CGRectMake(0,
//                            0,
//                            CGRectGetWidth(view.frame),
//                            CGRectGetHeight(view.frame));
//    [view updateScaleView];
    UIGraphicsBeginImageContext(view.frame.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [view setHidden:viewHidden];
    
    [_waterList addObject:@[image,
                            [NSNumber numberWithFloat:start],
                            [NSNumber numberWithFloat:end],
                            [NSNumber numberWithFloat:view.frame.origin.x - WATER_OFFSET],
                            [NSNumber numberWithFloat:originHeight - view.frame.origin.y - view.frame.size.height + WATER_OFFSET]
                            ]];
    CALayer *viewLayer = [CALayer layer];
    viewLayer.contents = (id)image.CGImage;
//    viewLayer.frame = CGRectMake(view.frame.origin.x * 4,
//                                 960 - view.frame.origin.y * 4 - view.frame.size.height * 4 * (curScale),
//                                 CGRectGetWidth(view.frame) * 4 * curScale,
//                                 CGRectGetHeight(view.frame) * 4 * curScale);
    viewLayer.frame = CGRectMake(view.frame.origin.x,
                                 originHeight - view.frame.origin.y - view.frame.size.height,
                                 view.frame.size.width,
                                 view.frame.size.height);
    viewLayer.opacity = 0.0;
    [_overlayLayer addSublayer:viewLayer];
    
    CABasicAnimation *animaShow = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animaShow.fromValue = [NSNumber numberWithFloat:0.0f];
    animaShow.toValue = [NSNumber numberWithFloat:1.0f];
    [animaShow setRemovedOnCompletion:NO];
    [animaShow setFillMode:kCAFillModeForwards];
    if (start == 0) {
        start = 0.01;
    }
    [animaShow setBeginTime:start];
    [viewLayer addAnimation:animaShow forKey:@"animateOpacityShow"];

    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [animation setFromValue:[NSNumber numberWithFloat:1.0]];
    [animation setToValue:[NSNumber numberWithFloat:0.0]];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    [animation setBeginTime:end];
    [viewLayer addAnimation:animation forKey:@"animateOpacityHiddenAgin"];

    _animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:_videoLayer inLayer:_parentLayer];
    _videoComposition.animationTool = _animationTool;
}


- (void)addFilter:(NSString*)filterName
{
    _videoComposition = nil;

    //https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/filter/ci/CIMotionBlur
    //[,"黑白","色调","岁月","单色","褪色","冲印","烙黄","原图"]
    //CIPhotoEffectInstant 怀旧
    //CIPhotoEffectNoir 黑白
    //CIPhotoEffectTonal 色调
    //CIPhotoEffectTransfer 岁月
    //CIPhotoEffectMono 单色
    //CIPhotoEffectFade 褪色
    //CIPhotoEffectProcess 冲印
    //CIPhotoEffectChrome 烙黄
    //CIMotionBlur 动感
    //CIBoxBlur 羽化
    //CICrystallize 水晶
    //CIGloom 柔和
    //CIPixellate 马赛克
    //CISepiaTone 老照片
    //CIComicEffect 漫画
    
    
    
    _videoFilter = [CIFilter filterWithName:filterName];
//     [filter setValue:[NSNumber numberWithFloat:5.0] forKey:@"inputIntensity"];
    _videoComposition = [AVMutableVideoComposition videoCompositionWithAsset:_originVideoAsset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request)
    {
        if (_videoFilter == nil)
        {
            [request finishWithImage:request.sourceImage.imageByClampingToExtent context:nil];
        }
        else
        {
            CIImage *source = request.sourceImage.imageByClampingToExtent;
            [_videoFilter setValue:source forKey:kCIInputImageKey];
            
            CIImage *output = [_videoFilter.outputImage imageByCroppingToRect:request.sourceImage.extent];
            [request finishWithImage:output context:nil];
        }

        
        
        
        //素描：
//        CIImage *source = request.sourceImage.imageByClampingToExtent;
//        CIFilter * monoFilter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
//        [monoFilter setValue:source forKey:kCIInputImageKey];
//        CIImage * outImage = [monoFilter valueForKey:kCIOutputImageKey];
//        CIImage * invertImage = [outImage copy];
//        
//        CIFilter * invertFilter = [CIFilter filterWithName:@"CIColorInvert"];
//        [invertFilter setValue:invertImage forKey:kCIInputImageKey];
//        invertImage = [invertFilter valueForKey:kCIOutputImageKey];
//        
//        CIFilter * blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
//        [blurFilter setDefaults];
//        [blurFilter setValue:@5 forKey:kCIInputRadiusKey];
//        [blurFilter setValue:invertImage forKey:kCIInputImageKey];
//        invertImage = [blurFilter valueForKey:kCIOutputImageKey];
//        
//        CIFilter * blendFilter = [CIFilter filterWithName:@"CIColorDodgeBlendMode"];
//        
//        [blendFilter setValue:invertImage forKey:kCIInputImageKey];
//        [blendFilter setValue:outImage forKey:kCIInputBackgroundImageKey];
//        
//        CIImage * sketchImage = [blendFilter outputImage];
//        [request finishWithImage:sketchImage context:nil];
    }];
    
    AVAssetTrack *videoAssetTrack = [[_originVideoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    _videoComposition.frameDuration = CMTimeMake(1, 25);
    _videoComposition.renderSize = videoAssetTrack.naturalSize;
    _videoComposition.animationTool = _animationTool;
    
    _playerItem = nil;
    _playerItem = [AVPlayerItem playerItemWithAsset:self.composition];
    _playerItem.audioMix = self.audioMix;
    _playerItem.videoComposition = _videoComposition;
    
    
    if (_delegate)
    {
        [_delegate onFilterComplete];
    }
    
//    [_gpuMovie cancelProcessing];
//    [_gpuMovie removeAllTargets];
//    _gpuMovie = [[GPUImageMovie alloc]initWithURL:[FileUtils getFileURLProjPath:@"1108" fileName:@"backgroundVideo.mp4"]];
//
//     GPUImageOutput<GPUImageInput> * Filter6 = [[GPUImageColorInvertFilter alloc] init];
//    [_gpuMovie addTarget:Filter6];
//    [_gpuMovie startProcessing];
//    
//
//    self.sampleTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f
//                                                        target:self
//                                                      selector:@selector(retrievingSampleProgress)
//                                                      userInfo:nil
//                                                       repeats:YES];
}

- (void)createVideoComposition
{
    _videoComposition = nil;
    CIFilter *watermarkFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    _videoComposition = [AVMutableVideoComposition videoCompositionWithAsset:_originVideoAsset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request)
     {
         float currentTime = request.compositionTime.value / request.compositionTime.timescale;
         CIImage* output;
         if(!_videoFilter)
         {
//             [request finishWithImage:request.sourceImage.imageByClampingToExtent context:nil];
//             return ;
             output = request.sourceImage.imageByClampingToExtent;
         }
         else
         {
             CIImage *source = request.sourceImage.imageByClampingToExtent;
             [_videoFilter setValue:source forKey:kCIInputImageKey];
             
             output = [_videoFilter.outputImage imageByCroppingToRect:request.sourceImage.extent];
         }


         for (NSArray* list in _waterList)
         {
             UIImage* image = list[0];
             float startTime = [list[1] floatValue];
             float endTime = [list[2] floatValue];
             float x = [list[3] floatValue];
             float y = [list[4] floatValue];
             CIImage *watermarkImage = [[CIImage alloc] initWithCGImage:image.CGImage];

             if (currentTime >= startTime && currentTime <= endTime) {
                 [watermarkFilter setValue:output forKey:kCIInputBackgroundImageKey];

                 CGAffineTransform t = CGAffineTransformMakeTranslation(x, y);
                 [watermarkFilter setValue:[watermarkImage imageByApplyingTransform:t] forKey:kCIInputImageKey];

                 output = [watermarkFilter.outputImage imageByCroppingToRect:request.sourceImage.extent];
             }
            
         }
         [request finishWithImage:output context:nil];
        


     }];
    AVAssetTrack *videoAssetTrack = [[_originVideoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    _videoComposition.frameDuration = CMTimeMake(1, 25);
    _videoComposition.renderSize = videoAssetTrack.naturalSize;
}

//- (void)retrievingSampleProgress
//{
//
//    NSLog(@"Sample Complete:%f",_gpuMovie.progress);
//
//    if(_gpuMovie.progress == 1){
//        [self.sampleTimer invalidate];
//
//        _playerItem = nil;
//        _playerItem = _gpuMovie.playerItem;
//        _playerItem.audioMix = self.audioMix;
////        _playerItem.videoComposition = self.videoComposition;
//        if (_delegate)
//        {
//            [_delegate onFilterComplete];
//        }
//    }
//}

- (void)addVoiceAssets:(NSURL*)voiceURL
{
    AVAsset *voiceAsset = [AVAsset assetWithURL:voiceURL];
    AVAssetTrack *voiceAssetTrack = [[voiceAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];

    if (_voiceCompositionTrack)
    {
        _voiceCompositionTrack = nil;
        [_composition removeTrack:_voiceCompositionTrack];
    }
    
    _voiceCompositionTrack = [_composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [_voiceCompositionTrack insertTimeRange:_videoTimeRange ofTrack:voiceAssetTrack atTime:kCMTimeZero error:nil];
    
    NSMutableArray<AVAudioMixInputParameters *> *trackMixArray = [NSMutableArray<AVAudioMixInputParameters *> array];
    {
        AVMutableAudioMixInputParameters *trackMix1 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:_originAudioCompositionTrack];
        trackMix1.trackID = _originAudioCompositionTrack.trackID;
        [trackMix1 setVolume:_originAudioVolume atTime:kCMTimeZero];
        [trackMixArray addObject:trackMix1];
        
        AVMutableAudioMixInputParameters *trackMix2 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:_voiceCompositionTrack];
        trackMix2.trackID = _voiceCompositionTrack.trackID;
        [trackMix2 setVolume:_voiceVolume atTime:kCMTimeZero];
        [trackMixArray addObject:trackMix2];
        
        if (_musicCompositionTrack)
        {
            AVMutableAudioMixInputParameters *trackMix2 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:_musicCompositionTrack];
            trackMix2.trackID = _musicCompositionTrack.trackID;
            [trackMix2 setVolume:_musicVolume atTime:kCMTimeZero];
            [trackMixArray addObject:trackMix2];
        }
    }
    
    _audioMix.inputParameters = trackMixArray;
    
    _playerItem = nil;
    _playerItem = [AVPlayerItem playerItemWithAsset:self.composition];
    _playerItem.audioMix = self.audioMix;
    _playerItem.videoComposition = self.videoComposition;
}

- (void)addMusicAssets:(NSURL*)musicURL
{
    AVAsset *musicAsset = [AVAsset assetWithURL:musicURL];
    AVAssetTrack *voiceAssetTrack = [[musicAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    if (_musicCompositionTrack)
    {
        _musicCompositionTrack = nil;
        [_composition removeTrack:_musicCompositionTrack];
    }
    
    _musicCompositionTrack = [_composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [_musicCompositionTrack insertTimeRange:_videoTimeRange ofTrack:voiceAssetTrack atTime:kCMTimeZero error:nil];
    
    NSMutableArray<AVAudioMixInputParameters *> *trackMixArray = [NSMutableArray<AVAudioMixInputParameters *> array];
    {
        AVMutableAudioMixInputParameters *trackMix1 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:_originAudioCompositionTrack];
        trackMix1.trackID = _originAudioCompositionTrack.trackID;
        [trackMix1 setVolume:_originAudioVolume atTime:kCMTimeZero];
        [trackMixArray addObject:trackMix1];
        
        if (_voiceCompositionTrack)
        {
            AVMutableAudioMixInputParameters *trackMix2 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:_voiceCompositionTrack];
            trackMix2.trackID = _voiceCompositionTrack.trackID;
            [trackMix2 setVolume:_voiceVolume atTime:kCMTimeZero];
            [trackMixArray addObject:trackMix2];
        }
        
        AVMutableAudioMixInputParameters *trackMix2 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:_musicCompositionTrack];
        trackMix2.trackID = _musicCompositionTrack.trackID;
        [trackMix2 setVolume:_musicVolume atTime:kCMTimeZero];
        [trackMixArray addObject:trackMix2];
    }
    
    _audioMix.inputParameters = trackMixArray;
    
    _playerItem = nil;
    _playerItem = [AVPlayerItem playerItemWithAsset:self.composition];
    _playerItem.audioMix = self.audioMix;
    _playerItem.videoComposition = self.videoComposition;
}

- (void)setVideoVolume:(CGFloat)volume musicVolume:(CGFloat)musicVolume voiceVolume:(CGFloat)voiceVolume
{
    NSMutableArray *allAudioParams = [NSMutableArray array];
    
    _originAudioVolume = volume;
    AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
    [audioInputParams setTrackID:_originAudioCompositionTrack.trackID];
    [audioInputParams setVolume:volume atTime:kCMTimeZero];
    [allAudioParams addObject:audioInputParams];
    
    if (_musicCompositionTrack)
    {
        _musicVolume = musicVolume;
        AVMutableAudioMixInputParameters *audioInputParams2 = [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams2 setTrackID:_musicCompositionTrack.trackID];
        [audioInputParams2 setVolume:_musicVolume atTime:kCMTimeZero];
        [allAudioParams addObject:audioInputParams2];
    }
    
    if (_voiceCompositionTrack)
    {
        _voiceVolume = voiceVolume;
        AVMutableAudioMixInputParameters *audioInputParams2 = [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams2 setTrackID:_voiceCompositionTrack.trackID];
        [audioInputParams2 setVolume:_voiceVolume atTime:kCMTimeZero];
        [allAudioParams addObject:audioInputParams2];
    }
    
    _audioMix = nil;
    _audioMix = [AVMutableAudioMix audioMix];
    _audioMix.inputParameters = allAudioParams;
    
    _playerItem.audioMix = self.audioMix;
}

- (void)removeVoice
{
    if (_voiceCompositionTrack)
    {
        [_composition removeTrack:_voiceCompositionTrack];
        _voiceCompositionTrack = nil;
    }
}

- (BOOL)musicTrackExists
{
    return _musicCompositionTrack != nil;
}

- (BOOL)voiceTrackExists
{
    return _voiceCompositionTrack != nil;
}

- (void)exportToPath:(NSURL*)outputPath
          complition:(void (^)(NSURL* outputPath,BOOL isSucceed)) completionHandle
{
    [self createVideoComposition];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:_composition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = outputPath;
    exporter.outputFileType = AVFileTypeMPEG4;//指定输出格式
    exporter.shouldOptimizeForNetworkUse= YES;
    exporter.audioMix = _audioMix;
    exporter.videoComposition=_videoComposition;
    
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
    
    NSTimer* exportProgressBarTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateExportDisplay:) userInfo:exporter repeats:YES];
    
}

- (void)updateExportDisplay:(NSTimer*)timer {
    NSLog(@"ppppp：%f",((AVAssetExportSession*)timer.userInfo).progress);
}
#pragma mark - 调节合成的音量
- (AVAudioMix *)buildAudioMixWithVideoTrack:(AVCompositionTrack *)videoTrack
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

- (AVPlayerItem *)playerItem {
    if (!_playerItem) {
        _playerItem = [AVPlayerItem playerItemWithAsset:self.composition];
        _playerItem.videoComposition = self.videoComposition;
        _playerItem.audioMix = self.audioMix;
    }
    return _playerItem;
}

- (void)replace
{
    [_gpuMovie cancelProcessing];
    _gpuMovie = [[GPUImageMovie alloc] initWithPlayerItem:_playerItem];
    [_gpuMovie startProcessing];
}
@end
