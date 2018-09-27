//
//  UIUitls.h
//  Wasee
//
//  Created by 陈忠杰 on 2017/7/19.
//  Copyright © 2017年 陈忠杰. All rights reserved.
//

#ifndef UIUitls_h
#define UIUitls_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Toast.h"
#import "UIImageView+AFNetworking.h"
#import "AFImageDownloader.h"
#import "UIButton+CountDown.h"
#import "UIButton+FillColor.h"
#import "UIButton+HitRect.h"
#import "Dimens.h"
#import "MJRefresh.h"
#import "Masonry.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(rgbValue,alpha) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:alpha]

#define BG_GRAY 0xEEEEEE
#define BG_WHITE 0xFFFFFF
#define BG_BLACK 0x000000
#define TEXT_NORMAL 0x378CDA
#define TEXT_FOCUS 0x63A3DD
#define BTN_GREEN 0x00dcaa
#define BTN_GREEN_FOCUS 0x03F2BB
#define TEXT_GRAY 0x666666
#define TEXT_RED 0xFF0000

#define NowTimeStamp \
[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]

#define TAG_NAVIGATION_GREEN_BAR (1000)

@interface UIUtils : NSObject

+ (UIImageView *)roundFrameImageView:(UIImageView *)imageView;
+ (UIImage *) imageWithFrame:(CGRect)frame color:(int)color alpha:(CGFloat)alpha;
+ (void) setNavigationTransparent:(UIViewController *)viewController percent:(float)percent;
+ (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size;
+ (void)compressImages:(UIImage *)image
             frameRate:(int)frameRate
              duration:(int)duration
             exportUrl:(NSURL*)exportUrl
            completion:(void(^)(NSURL *outurl))block;
@end


#endif /* UIUitls_h */
