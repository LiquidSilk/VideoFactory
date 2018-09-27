//
//  CycleProgress.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/7.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 //使用：
CycleProgress* cycleProgress = [[CycleProgress alloc] initWithFrame:CGRectMake(50, 90, 30, 30) lineWidth:4 color1:[UIColor yellowColor] color1:[UIColor greenColor]];
[self.view addSubview:cycleProgress];

[cycleProgress go2Progress:0.1];
[cycleProgress go2Progress:0.3];
[cycleProgress go2Progress:0.5];

NSTimer* timer = [NSTimer timerWithTimeInterval:2.01 repeats:NO block:^(NSTimer * _Nonnull timer) {
    [cycleProgress go2Progress:0.6];
}];
[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

NSTimer* timer2 = [NSTimer timerWithTimeInterval:9.01 repeats:NO block:^(NSTimer * _Nonnull timer) {
    [cycleProgress go2Progress:1.0];
}];
[[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];

*/

@interface CycleProgress : UIView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth color1:(UIColor*)color1 color1:(UIColor*) color2;

- (void)go2Progress:(float)progress;

@end
