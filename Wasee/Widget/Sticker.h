//
//  Sticker.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/23.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Sticker : UIView


@property(nonatomic, strong)UIView* scaleView;
@property(nonatomic, strong)UIView* closeView;
@property(nonatomic, strong)UIView* editView;
@property(nonatomic, assign)float startTime;
@property(nonatomic, assign)float endTime;
@property(nonatomic, assign)NSUInteger mode; //1:普通模式 2:生成视频模式
@property(nonatomic, assign)NSUInteger ratio; //输出尺寸与原始预览比值


- (instancetype)initWithRect:(CGRect)rect;

- (void)updateScaleView;
- (void)showTool:(BOOL)bShow;
- (void)setMode:(NSUInteger)mode ratio:(float)ratio;
@end
