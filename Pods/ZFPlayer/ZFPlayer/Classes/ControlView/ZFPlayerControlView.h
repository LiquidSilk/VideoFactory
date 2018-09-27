//
//  ZFPlayerControlView.h
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "ZFPortraitControlView.h"
#import "ZFLandScapeControlView.h"
#import "ZFPlayerMediaControl.h"
#import "ZFSpeedLoadingView.h"

@interface ZFPlayerControlView : UIView <ZFPlayerMediaControl>

/// 竖屏控制层的View
@property (nonatomic, strong, readonly) ZFPortraitControlView *portraitControlView;
/// 横屏控制层的View
@property (nonatomic, strong, readonly) ZFLandScapeControlView *landScapeControlView;
/// 加载loading
@property (nonatomic, strong, readonly) ZFSpeedLoadingView *activity;
/// 快进快退View
@property (nonatomic, strong, readonly) UIView *fastView;
/// 快进快退进度progress
@property (nonatomic, strong, readonly) ZFSliderView *fastProgressView;
/// 快进快退时间
@property (nonatomic, strong, readonly) UILabel *fastTimeLabel;
/// 快进快退ImageView
@property (nonatomic, strong, readonly) UIImageView *fastImageView;
/// 加载失败按钮
@property (nonatomic, strong, readonly) UIButton *failBtn;
/// 底部播放进度
@property (nonatomic, strong, readonly) ZFSliderView *bottomPgrogress;
/// 封面图
@property (nonatomic, strong, readonly) UIImageView *coverImageView;

- (void)showTitle:(NSString *)title
   coverURLString:(NSString *)coverUrl
   fullScreenMode:(ZFFullScreenMode)fullScreenMode;

- (void)resetControlView;

@end
