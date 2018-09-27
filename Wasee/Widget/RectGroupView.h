//
//  RectGroupView.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/25.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RectView.h"

@interface RectGroupView : UIView

- (instancetype)initWithOriginSize:(CGSize)size;

- (void)addRectView:(RectView*)rectView name:(NSString*)name;
- (void)addRectViewWithRect:(CGRect)rect name:(NSString*)name;

- (void)setFocus:(BOOL)bFocus withName:(NSString*)name;
@end
