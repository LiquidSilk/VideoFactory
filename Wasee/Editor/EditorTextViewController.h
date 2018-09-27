//
//  EditorTextViewController.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/11.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import <UIKit/UIKit.h>

@interface EditorTextViewController : BaseViewController

//确定按钮返回
@property(nonatomic, strong) void(^onSavedBlock)(UIImageView* imageView, NSString* text);
// (^onSavedBlock)(UIImageView* imageView, NSString* text);

- (instancetype)initWithTextRect:(CGRect)rect fontSize:(int)fontSize limit:(int)limit defaultText:(NSString*)text;

@end
