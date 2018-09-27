//
//  RSOpacitySlider.m
//  RSColorPicker
//
//  Created by Jared Allen on 5/16/13.
//  Copyright (c) 2013 Red Cactus LLC. All rights reserved.
//

#import "RSOpacitySlider.h"

#import "RSColorFunctions.h"

@implementation RSOpacitySlider

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRoutine];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initRoutine];
    }
    return self;
}

- (void)initRoutine {
    self.minimumValue = 0.0;
    self.maximumValue = 1.0;
    self.continuous = YES;

    self.enabled = YES;
    self.userInteractionEnabled = YES;
    self.tintColor = [UIColor whiteColor];
    self.maximumTrackTintColor = [UIColor whiteColor];
    self.minimumTrackTintColor = [UIColor whiteColor];

    [self addTarget:self action:@selector(myValueChanged:) forControlEvents:UIControlEventValueChanged];
}

-  (void)didMoveToWindow {
    if (!self.window) return;

//    UIImage *backgroundImage = RSOpacityBackgroundImage(16.f, self.window.screen.scale, [UIColor colorWithWhite:0.5 alpha:1.0]);
//    self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
}

- (void)myValueChanged:(id)notif {
    _colorPicker.opacity = self.value;
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    CGFloat width = rect.size.width;
//    CGFloat height = rect.size.height;
//    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
//    CGFloat radius = 15;
//    // 移动到初始点
//    CGContextMoveToPoint(ctx, radius, 0);
//    // 绘制第1条线和第1个1/4圆弧，右上圆弧
//
//    CGContextAddLineToPoint(ctx, width - radius,0);
//    CGContextAddArc(ctx, width - radius, radius, radius, 0.5 * M_PI, 0.0, 0);
//
//    // 绘制第2条线和第2个1/4圆弧，右下圆弧
//    CGContextAddArc(ctx, width - radius, height - radius, radius,0.0, 0.5 *M_PI, 0);
//
//    // 绘制第3条线和第3个1/4圆弧，左下圆弧
//    CGContextAddLineToPoint(ctx, radius, height);
//    CGContextAddArc(ctx, radius, height - radius, radius,0.5 *M_PI,M_PI,0);
//
//    // 绘制第4条线和第4个1/4圆弧，左上圆弧
//    CGContextAddLineToPoint(ctx, 0, radius);
//    CGContextAddArc(ctx, radius, radius, radius,M_PI,1.5 *M_PI,0);
//
//    // 闭合路径
//    CGContextClosePath(ctx);
//    CGContextClip(ctx);
//
//    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
//    NSArray *colors = [[NSArray alloc] initWithObjects:
//                       (id)[UIColor colorWithWhite:0 alpha:0].CGColor,
//                       (id)[UIColor colorWithWhite:1 alpha:1].CGColor,nil];
//
////    CGGradientRef myGradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);
//    CGFloat locations[2] = { 0.0, 1.0 };
//    size_t num_locations = 2;
//    CGFloat components[8] = { 0.0, 0.0, 0.0, 0.0, // Start color
//        1.0, 1.0, 1.0, 1.0 }; // End color ;
//    CGGradientRef myGradient = CGGradientCreateWithColorComponents(space, components, locations, num_locations);
//
//    CGContextDrawLinearGradient(ctx, myGradient, CGPointZero, CGPointMake(rect.size.width, 0), 0);
//    CGGradientRelease(myGradient);
//    CGColorSpaceRelease(space);
//}

- (void)setColorPicker:(RSColorPickerView *)cp {
    _colorPicker = cp;
    if (!_colorPicker) { return; }
    self.value = [_colorPicker brightness];
}

@end
