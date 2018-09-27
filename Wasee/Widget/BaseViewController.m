//
//  BaseViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/10.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "BaseViewController.h"
#import "UIUitls.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setNavigationColor:(int)color
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [UIUtils imageWithFrame:CGRectMake(0, 0, kScreenW, 64) color:color alpha:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

- (void)setTintColor:(int)color
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    //设置导航栏标题颜色
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(color)}];
    //设置导航栏返回颜色
    [bar setTintColor:UIColorFromRGB(color)];

}

- (void)showNavigationBar:(BOOL)bShow
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    //隐藏标题栏
    if (!bShow) {
        [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImage *bgImage = [UIUtils imageWithFrame:CGRectMake(0, 0, kScreenW, 64) color:BG_BLACK alpha:1.0];
        [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    }
}

@end
