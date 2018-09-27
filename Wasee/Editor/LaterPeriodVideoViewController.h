//
//  LaterPeriodViewController.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/10.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoFactory.h"
#import "VideoRange.h"

@class LaterPeriodVideoViewController;

static const NSInteger PLAYER_STATUS_START = 1;
static const NSInteger PLAYER_STATUS_PAUSE = 2;
static const NSInteger PLAYER_STATUS_FINISH = 5;


static const NSInteger PLAYER_MODE_NORMAL = 0;
static const NSInteger PLAYER_MODE_RESTART = 1;

@protocol LaterPeriodVideoViewControllerDelegate <NSObject>

@optional
- (void)laterPeriodViewController:(LaterPeriodVideoViewController*)vc onStatus:(NSInteger)status;
- (void)laterPeriodViewController:(LaterPeriodVideoViewController*)vc inRangeWithKey:(NSString*)key;
- (void)laterPeriodViewController:(LaterPeriodVideoViewController*)vc outRangeWithKey:(NSString*)key;
- (void)laterPeriodViewController:(LaterPeriodVideoViewController*)vc onSelecedImage:(UIImage*)image;
@end


@interface LaterPeriodVideoViewController : UIViewController

@property(nonatomic, copy)NSString *videoPath;
@property(nonatomic, copy)NSString *projName;
@property(nonatomic, weak)id<LaterPeriodVideoViewControllerDelegate> delegate;
@property(nonatomic, assign)NSInteger playerMode;
@property(nonatomic, strong)VideoFactory* videoFactory;
@property(nonatomic, strong)VideoRange* videoRange;

- (void)play;
- (void)restart;
- (void)pause;
- (void)setVideoVolume:(CGFloat)volume musicVolume:(CGFloat)musicVolume voiceVolume:(CGFloat)voiceVolume;
- (void)addMusicURL:(NSURL*)musicURL;
- (void)addVoiceURL:(NSURL*)voiceURL;
- (void)addFilter:(NSString*)filterName;
- (void)setControlEnable:(BOOL)bEnable;
- (void)removeVoice;
- (UIImage*)getScreenShotImageAt:(float)time;

- (void)addVideoRangeSelector:(NSString*)key;
- (void)removeRangeSelectorWithKey:(NSString*)key;
- (NSMutableDictionary*)getRangeMap;
@end
