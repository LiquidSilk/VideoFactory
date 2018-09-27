//
//  RectView.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/6/26.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "RectView.h"
#import "UIUitls.h"

@interface RectView()
{
    float m_fRatio;
}

@property(nonatomic, assign)float ratio;
@property(nonatomic, assign)CGRect rectFrame;
@property(nonatomic, copy)UIColor* color;

@end


@implementation RectView

- (id)initWithFrame:(CGRect)frame ratio:(float)ratio
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _rectFrame = frame;
        _ratio =  ratio;
        _color = [UIColor redColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    //矩形，并填弃颜色
    CGContextSetLineWidth(context, 2.0);//线的宽度
    UIColor* clearColor = [UIColor clearColor];//blue蓝色
    CGContextSetFillColorWithColor(context, clearColor.CGColor);//填充颜色
    UIColor* red = [UIColor redColor];
    CGContextSetStrokeColorWithColor(context, _color.CGColor);//线框颜色
    CGContextAddRect(context, CGRectMake(0, 0, _rectFrame.size.width * _ratio, _rectFrame.size.height * _ratio));//画方框
    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径  
}

- (void)updatePosition
{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_rectFrame.origin.x * _ratio);
        make.top.mas_equalTo(_rectFrame.origin.y * _ratio);
        make.width.mas_equalTo(_rectFrame.size.width * _ratio);
        make.height.mas_equalTo(_rectFrame.size.height * _ratio);
    }];
}

- (void)setFocus:(BOOL)bFocus
{
    if (bFocus)
    {
        _color = [UIColor whiteColor];
    }
    else
    {
        _color = [UIColor redColor];
    }
    [self setNeedsDisplay];
}

@end
