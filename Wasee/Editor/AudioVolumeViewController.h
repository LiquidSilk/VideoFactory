//
//  AudioVolumeViewController.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/17.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioVolumeViewController;

@protocol AudioVolumeViewControllerDelegate <NSObject>
@optional
- (void)recordViewController:(AudioVolumeViewController*)vc
                originVolume:(float)originVolume
                 musicVolume:(float)musicVolume
                 voiceVolume:(float)voiceVolume;
@end


@interface AudioVolumeViewController : UIViewController

@property(nonatomic, weak)id<AudioVolumeViewControllerDelegate> delegate;

- (void)show:(BOOL)bShow;
- (void)setSlider:(int)sliderType enable:(BOOL)bEnable;
@end
