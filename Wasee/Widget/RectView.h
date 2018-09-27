//
//  RectView.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/6/26.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RectView : UIView

- (id)initWithFrame:(CGRect)frame ratio:(float)ratio;
- (void)updatePosition;
- (void)setFocus:(BOOL)bFocus;
@end
