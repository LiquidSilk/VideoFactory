//
//  TextFieldCounter.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/14.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCounter : UITextField

@property(nonatomic, assign)int maxCount;
@property(nonatomic, strong)UILabel* labelLimit;
@property(nonatomic, strong)UITextField* textField;

- (TextFieldCounter*)initWithLimit:(int)max;

- (void)updateTextCount;

@end
