//
//  AppDelegate.h
//  Rating
//
//  Created by 陈忠杰 on 2017/7/5.
//  Copyright © 2017年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) NSDictionary *userInfo;

-(void)showWindow:(NSString *)windowType;
@end

