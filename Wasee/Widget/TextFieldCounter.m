//
//  TextFieldCounter.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/14.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "TextFieldCounter.h"
#import "UIUitls.h"

#define MAX_LIMIT_NUMS 10 //最大限制字数

@interface TextFieldCounter()<UITextFieldDelegate>


@end

@implementation TextFieldCounter

- (instancetype) initWithLimit:(int)max
{
    self = [super init];
    if (self) {
        _maxCount = max;
        [self create];
    }
    return self;
}

- (void)create
{
    self.delegate = self;
    [self addTarget:self action:@selector(textFieldDidChanging:) forControlEvents:UIControlEventEditingChanged];
    
    self.textColor = [UIColor whiteColor];
    
    
    _labelLimit = [[UILabel alloc] init];
    _labelLimit.textColor = [UIColor whiteColor];
    _labelLimit.text = [NSString stringWithFormat:@"%d/%d", 0, _maxCount];

    
   
    [self addSubview:_labelLimit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_labelLimit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.mas_bottom);
    }];
    
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = UIColorFromRGB(BG_WHITE).CGColor;
    border.fillColor = nil;
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    //create path
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
//    border.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(5, 5)];
//    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    border.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(1, 1)].CGPath;
    border.frame = self.bounds;
    border.lineWidth = 1.f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @2];
    [self.layer addSublayer:border];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text{
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < _maxCount) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = _maxCount - comcatstr.length;
    
    

    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

- (void) textFieldDidChanging:(id) sender {
    UITextField *_field = (UITextField *)sender;
    _labelLimit.text = [NSString stringWithFormat:@"%d/%d", _field.text.length, _maxCount];
}

- (void)updateTextCount { 
    _labelLimit.text = [NSString stringWithFormat:@"%d/%d", self.text.length, _maxCount];
}

@end
