//
//  LaterPeriodViewController.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/25.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "ViewController.h"

@interface LaterPeriodViewController : UITabBarController

@property(nonatomic, copy)NSString *videoPath;
@property(nonatomic, copy)NSString *projName;
- (void)setTabShow:(BOOL)bShow;
@end
