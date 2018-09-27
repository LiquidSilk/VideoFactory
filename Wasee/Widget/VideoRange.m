//
//  VideoRange.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/6/25.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "VideoRange.h"
#import "LSSlider.h"
#import "SliderRangeSelectorView.h"

#define STICKER_WIDTH 36
#define IMAGESLIDER_WIDTH 16
@interface VideoRange()<SAVideoRangeSliderDelegate, SliderRangeSelectorViewDelegate>
{
}
@property(nonatomic, strong)UIView* pan;
@property(nonatomic, strong)SliderRangeSelectorView* sliderRangeView;

@end

@implementation VideoRange

-(VideoRange*)initWithFrame:(CGRect)frame
                    fileURL:(NSURL*)url
                useProgress:(BOOL)bUseProgress
{
    self = [super initWithFrame:frame videoUrl:url useSlider:!bUseProgress stickerWidth:STICKER_WIDTH];
    if (self)
    {
        if (bUseProgress)
        {
            [self addRangeSelectorView];
            [self addSlider];
            [self showRangeSelector:NO];
        }
        [self setPopoverBubbleSize:200 height:0];
        self.delegate = self;
        self.minGap = 2.5; // optional, seconds
        self.maxGap = 10; // optional, seconds
    }
    
    return self;
}



- (void)addSlider
{
    //滑块的View
    _pan = [[UIView alloc] initWithFrame:CGRectMake(0, -5, STICKER_WIDTH, self.frame.size.height + 10)];
    [self addSubview:_pan];
    
    //显示的图片
    UIImageView* imageSlider = [[UIImageView alloc] initWithFrame:CGRectMake((STICKER_WIDTH - IMAGESLIDER_WIDTH) / 2, 0, IMAGESLIDER_WIDTH, self.frame.size.height + 10)];
    imageSlider.image = [UIImage imageNamed:@"播放滑块"];
    [_pan addSubview:imageSlider];

    
    UIPanGestureRecognizer *moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [_pan addGestureRecognizer:moveGesture];
}

- (void)setSliderPercent:(CGFloat)percent {
    float x = (self.frame.size.width - STICKER_WIDTH) * percent;
    _pan.frame = CGRectMake(x, -5, STICKER_WIDTH, self.frame.size.height + 10);
    [_sliderRangeView progressProc:CGRectGetMidX(_pan.frame)];
}

- (void)showRangeSelector:(BOOL)bShow
{
    [self.leftThumb setHidden:!bShow];
    [self.rightThumb setHidden:!bShow];
    [self.topBorder setHidden:!bShow];
    [self.bottomBorder setHidden:!bShow];
}

- (void)addRangeSelectorView
{
    _sliderRangeView = [[SliderRangeSelectorView alloc] init];
    _sliderRangeView.delegate = self;
    [self addSubview:_sliderRangeView];
    [_sliderRangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.mas_equalTo(self);
    }];
}

- (void)addRangeSelector:(NSString*)key
{
    [_sliderRangeView addSelector:key];
}

- (void)removeRangeSelectorWithKey:(NSString*)key
{
    [_sliderRangeView removeSelectorWithKey:key];
}

- (NSMutableDictionary*)getRangeMap
{
    return [_sliderRangeView getRangeMap];
}

-(void)panView:(UIPanGestureRecognizer *)panGesture{
    UIView *pan = (UIView*)panGesture.view;
    CGPoint point = [panGesture translationInView:pan];
    
    panGesture.view.transform = CGAffineTransformTranslate(panGesture.view.transform, point.x, 0);
    if (CGRectGetMinX(pan.frame) <= 0)
    {
        //超出左边界
        panGesture.view.frame = CGRectMake(0,
                                           pan.frame.origin.y,
                                           pan.frame.size.width,
                                           pan.frame.size.height);
    }
    else if(CGRectGetMaxX(pan.frame) >= CGRectGetWidth(self.frame))
    {
        //超过右边界
        panGesture.view.frame = CGRectMake(self.frame.size.width - STICKER_WIDTH,
                                           pan.frame.origin.y,
                                           pan.frame.size.width,
                                           pan.frame.size.height);
    }
    
    if(_rangeDelegate)
    {
        float minX = CGRectGetMinX(pan.frame);
        float percent = minX / (self.frame.size.width - STICKER_WIDTH);
        [_sliderRangeView progressProc:CGRectGetMidX(pan.frame)];
        [_rangeDelegate videoRangeOnMoveSlider:percent];
    }
    
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
    
    if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        if(_rangeDelegate)
        {
            float minX = CGRectGetMinX(pan.frame);
            float percent = minX / (self.frame.size.width - STICKER_WIDTH);
            [_sliderRangeView progressProc:CGRectGetMidX(pan.frame)];
            [_rangeDelegate videoRangeOnSelectedEndSlider:percent];
        }
    }
}

#pragma mark - SliderRangeSelectorViewDelegate
- (void)SliderRangeSelectorView:(SliderRangeSelectorView*)view inRangeWithkey:(NSString*)key
{
    if(_rangeDelegate)
    {
        [_rangeDelegate videoRangeInRangeWithKey:key];
    }
}

- (void)SliderRangeSelectorView:(SliderRangeSelectorView*)view outRangeWithkey:(NSString*)key
{
    if(_rangeDelegate)
    {
        [_rangeDelegate videoRangeOutRangeWithKey:key];
    }
}




- (void)videoRange:(SAVideoRangeSlider *)videoRange didChangecenterPosition:(CGFloat)centerPosition centerPosition:(CGFloat)centerPosition
{
}

- (void)videoRange:(SAVideoRangeSlider *)videoRange didGestureStateEndedcenterPosition:(CGFloat)centerPosition centerPosition:(CGFloat)centerPosition
{
    NSLog(@"didGestureStateEndedcenterPosition %f-%f", centerPosition, centerPosition);
    
    if(_subject)
    {
        NSURL *videoUrl = [FileUtils getFileURLProjPath:_projName fileName:@"backgroundVideo.mp4"];
        AVAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:videoAsset presetName:AVAssetExportPresetPassthrough];
        
        NSURL *outUrl = [FileUtils getFileURLProjPath:_projName fileName:@"backgroundVideo_out.mp4"];
        exportSession.outputURL = outUrl;
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:videoAsset];
        CMTime time = CMTimeMakeWithSeconds((centerPosition + centerPosition) * 0.5 - (centerPosition - centerPosition) * 0.4, videoAsset.duration.timescale);
        NSError *error = nil;
        CMTime actualTime;
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        imageGenerator.appliesPreferredTrackTransform = YES;
        CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:NULL error:&error];
        if(error){
            NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
            return;
        
        }
        
        UIImage *image = [UIImage imageWithCGImage:cgImage];//转化为UIImage
        
        [_subject sendNext:image];
    }
}
@end
