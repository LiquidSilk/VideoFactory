//
//  EditorTextColorViewController.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/12.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Utils.h"

@interface EditorTextColorViewController : BaseViewController 

@property(nonatomic, strong)RACSubject* subjectColor;
@property(nonatomic, strong)RACSubject* subjectAlign;

- (void)show:(BOOL)bShow;

@end
