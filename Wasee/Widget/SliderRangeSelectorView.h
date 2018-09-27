//
//  SliderRangeView.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/29.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSlider.h"

@class SliderRangeSelectorView;

@protocol SliderRangeSelectorViewDelegate<NSObject>
@optional
- (void)SliderRangeSelectorView:(SliderRangeSelectorView*)view inRangeWithkey:(NSString*)key;
- (void)SliderRangeSelectorView:(SliderRangeSelectorView*)view outRangeWithkey:(NSString*)key;
@end

@interface SliderRangeSelectorView : UIView

@property(nonatomic, weak)id<SliderRangeSelectorViewDelegate> delegate;

- (void)progressProc:(CGFloat)offset;
- (void)addSelector:(NSString*)key;
- (void)removeSelectorWithKey:(NSString*)key;
- (NSMutableDictionary*)getRangeMap;
@end
