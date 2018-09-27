//
//  VideoRange.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/6/25.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAVideoRangeSlider.h"
#import "UIUitls.h"
#import "Utils.h"


@protocol VideoRangeDelegate <NSObject>

@optional
- (void)videoRangeOnSelectImage:(UIImage*)image;
- (void)videoRangeOnMoveSlider:(float)percent;
- (void)videoRangeOnSelectedEndSlider:(float)percent;
- (void)videoRangeInRangeWithKey:(NSString*)key;
- (void)videoRangeOutRangeWithKey:(NSString*)key;
@end


@interface VideoRange : SAVideoRangeSlider

@property(nonatomic, weak)id<VideoRangeDelegate> rangeDelegate;
@property(nonatomic, strong)RACSubject *subject;
@property(nonatomic, copy)NSString* projName;

- (VideoRange*)initWithFrame:(CGRect)rect fileURL:(NSURL*)url useProgress:(BOOL)bUseProgress;
- (void)addSlider;
- (void)setSliderPercent:(CGFloat)percent;
- (void)addRangeSelector:(NSString*)key;
- (void)removeRangeSelectorWithKey:(NSString*)key;
- (NSMutableDictionary*)getRangeMap;
@end
