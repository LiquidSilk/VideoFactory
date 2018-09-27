//
//  VideoFactory.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/17.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class VideoFactory;

@protocol VideoFactoryDelegate <NSObject>

@optional
- (void)onFilterComplete;
@end



@interface VideoFactory : NSObject

@property (nonatomic, strong)AVMutableComposition *composition;//编辑环境
@property (nonatomic, strong)AVMutableVideoComposition* videoComposition;
@property (nonatomic, strong)AVMutableAudioMix *audioMix;
@property (nonatomic, strong)AVPlayerItem *playerItem;
@property (nonatomic, weak)id<VideoFactoryDelegate> delegate;


- (instancetype)initWithName:(NSString*)projName view:(UIView*)view path:(NSString*)path;

- (void)removeAllSubLayer;
- (void)addWater:(UIView*)view startTime:(CGFloat)start endTime:(CGFloat)end ratio:(float)ratio originHeight:(float)originHeight;
- (void)addVoiceAssets:(NSURL*)voiceURL;
- (void)addMusicAssets:(NSURL*)musicURL;
- (void)addFilter:(NSString*)filterName;
- (void)setVideoVolume:(CGFloat)volume musicVolume:(CGFloat)musicVolume voiceVolume:(CGFloat)voiceVolume;
- (void)removeVoice;
- (BOOL)musicTrackExists;
- (BOOL)voiceTrackExists;
- (void)exportToPath:(NSURL*)outputPath
          complition:(void (^)(NSURL* outputPath,BOOL isSucceed)) completionHandle;
@end
