//
//  LSSlider.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/29.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "LSSlider.h"

@implementation LSSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* color6 = [UIColor colorWithRed: 0.196 green: 0.161 blue: 0.047 alpha: 1];
    
    
    
    CGRect bubbleFrame = self.bounds;
    UIColor* aColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetRGBStrokeColor(context, 1,  0, 0, 0.5);//画笔线的颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, CGRectGetMidX(bubbleFrame), CGRectGetMidY(bubbleFrame), 6, 0, 2 * M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    
    CGPoint aPoints[2];//坐标点
    aPoints[0] = CGPointMake(CGRectGetMidX(bubbleFrame), 0);//坐标1
    aPoints[1] = CGPointMake(CGRectGetMidX(bubbleFrame), CGRectGetMaxY(bubbleFrame));//坐标2
    //CGContextAddLines(CGContextRef c, const CGPoint points[],size_t count)
    //points[]坐标数组，和count大小
    CGContextSetLineWidth(context, 3.0);//线的宽度
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
}

@end
