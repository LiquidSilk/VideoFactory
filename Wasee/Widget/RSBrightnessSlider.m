//
//  RSBrightnessSlider.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//

#import "RSBrightnessSlider.h"

#import "CGContextCreator.h"

/**
 * Returns Image with hourglass looking slider that looks something like:
 *
 *  6 ______ 5
 *    \    /
 *   7 \  / 4
 *    ->||<--- cWidth (Center Width)
 *      ||
 *   8 /  \ 3
 *    /    \
 *  1 ------ 2
 */
UIImage * RSHourGlassThumbImage(CGSize size, CGFloat cWidth){

    //Set Size
    CGFloat width = size.width;
    CGFloat height = size.height;

    //Setup Context
    CGContextRef ctx = [CGContextCreator newARGBBitmapContextWithSize:size];

    //Set Colors
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);

    //Draw Slider, See Diagram above for point numbers
    CGFloat yDist83 = sqrtf(3)/2*width;
    CGFloat yDist74 = height - yDist83;
    CGPoint addLines[] = {
        CGPointMake(0, -1),                          //Point 1
        CGPointMake(width, -1),                      //Point 2
        CGPointMake(width/2+cWidth/2, yDist83),      //Point 3
        CGPointMake(width/2+cWidth/2, yDist74),      //Point 4
        CGPointMake(width, height+1),                //Point 5
        CGPointMake(0, height+1),                    //Point 6
        CGPointMake(width/2-cWidth/2, yDist74),      //Point 7
        CGPointMake(width/2-cWidth/2, yDist83)       //Point 8
    };
    //Fill Path
    CGContextAddLines(ctx, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextFillPath(ctx);

    //Stroke Path
    CGContextAddLines(ctx, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);

    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);

    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

    return image;
}

/**
 * Returns image that looks like a square arrow loop, something like:
 *
 * +-----+
 * | +-+ | ------------------------
 * | | | |                       |
 * ->| |<--- loopSize.width     loopSize.height
 * | | | |                       |
 * | +-+ | ------------------------
 * +-----+
 */
UIImage * RSArrowLoopThumbImage(CGSize size, CGSize loopSize){

    //Setup Rects
    CGRect outsideRect = CGRectMake(0, 0, size.width, size.height);
    CGRect insideRect;
    insideRect.size = loopSize;
    insideRect.origin.x = (size.width - loopSize.width)/2;
    insideRect.origin.y = (size.height - loopSize.height)/2;

    //Setup Context
    CGContextRef ctx = [CGContextCreator newARGBBitmapContextWithSize:size];

    //Set Colors
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);

    CGMutablePathRef loopPath = CGPathCreateMutable();
    CGPathAddRect(loopPath, nil, outsideRect);
    CGPathAddRect(loopPath, nil, insideRect);


    //Fill Path
    CGContextAddPath(ctx, loopPath);
    CGContextEOFillPath(ctx);

    //Stroke Path
    CGContextAddRect(ctx, insideRect);
    CGContextStrokePath(ctx);

    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);

    //Memory
    CGPathRelease(loopPath);
    CGContextRelease(ctx);

    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

    return image;
}


@implementation RSBrightnessSlider

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

- (void)myValueChanged:(id)notif {
    [_colorPicker setBrightness:self.value];
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
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
//
//    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
//    NSArray *colors = @[(id)[UIColor colorWithWhite:0 alpha:1].CGColor,
//                        (id)[UIColor colorWithWhite:1 alpha:1].CGColor];
//
//    //    CGGradientRef myGradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);
//    CGFloat locations[2] = { 0.0, 1.0 };
//    size_t num_locations = 2;
//    CGFloat components[8] = { 0.0, 0.0, 0.0, 1.0, // Start color
//        1.0, 1.0, 1.0, 1.0 }; // End color ;
//    CGGradientRef myGradient = CGGradientCreateWithColorComponents(space, components, locations, num_locations);
//
//    CGContextDrawLinearGradient(ctx, myGradient, CGPointZero, CGPointMake(rect.size.width, 0), 0);
//    CGGradientRelease(myGradient);
//
//    CGColorSpaceRelease(space);
//}

- (void)setColorPicker:(RSColorPickerView*)cp {
    _colorPicker = cp;
    if (!_colorPicker) { return; }
    self.value = [_colorPicker brightness];
}

@end
