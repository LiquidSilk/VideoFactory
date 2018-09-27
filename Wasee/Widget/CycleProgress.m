//
//  CycleProgress.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/7.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "CycleProgress.h"
@interface CycleProgress()
{
    dispatch_semaphore_t semaphore;
    dispatch_queue_t q;
}
@property(nonatomic, assign)float curProgress;
@property(nonatomic, assign)float targetProgress;
@property(nonatomic, strong)CAShapeLayer* progressLayer;
@end

@implementation CycleProgress

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth color1:(UIColor*)color1 color1:(UIColor*) color2;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _curProgress = 0.0;
        [self setNeedsDisplay];
        
        q = dispatch_queue_create("progress", NULL);
        semaphore = dispatch_semaphore_create(1);
        
        [self addGradientLineWidth:4 color1:color1 color1:color2];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文

    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.width / 2);  //设置圆心位置
    CGFloat radius = self.bounds.size.width / 2 - 3;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _curProgress;  //圆终点位置

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];

//    CGContextSetLineWidth(ctx, 5); //设置线条宽度
//    [[UIColor blueColor] setStroke]; //设置描边颜色
//
//    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
//
//    CGContextStrokePath(ctx);  //渲染
    
    _progressLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
}

- (void)go2Progress:(float)progress
{
    dispatch_async(q, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        float _targetProgress = progress;
        NSTimer* timer = [NSTimer timerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
            _curProgress = _curProgress + 0.01;
            if (_curProgress >= _targetProgress) {
                [timer invalidate];
                dispatch_semaphore_signal(semaphore);
            }
            [self setNeedsDisplay];
        }];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    });
}

- (void)addGradientLineWidth:(float)lineWidth color1:(UIColor*)color1 color1:(UIColor*) color2;
{
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.width / 2);  //设置圆心位置
    CGFloat radius = self.bounds.size.width / 2 - lineWidth * 0.5;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _curProgress;  //圆终点位置
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _progressLayer.strokeColor = [[UIColor redColor] CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer.opacity = 1; //背景颜色的透明度
    _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _progressLayer.lineWidth = lineWidth;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    _progressLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    [self.layer addSublayer:_progressLayer];
    
    CALayer *gradientLayer = [CALayer layer];
    
    //左侧渐变色
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);    // 分段设置渐变色
    leftLayer.locations = @[@0.3, @0.7, @1];
    leftLayer.startPoint = CGPointMake(0, 0);
    leftLayer.endPoint = CGPointMake(1, 1);
    leftLayer.colors = @[(id)color1.CGColor, (id)color2.CGColor];
    [gradientLayer addSublayer:leftLayer];
    
    //    //右侧渐变色
    //    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    //    rightLayer.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
    //    rightLayer.locations = @[@0.3, @0.9, @1];
    //    rightLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor redColor].CGColor];
    //    [gradientLayer addSublayer:rightLayer];
    
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
}

@end
