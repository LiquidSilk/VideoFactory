//
//  TextImageView.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/5/31.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "TextImageView.h"


@interface TextImageView ()
{
}
@property(nonatomic, strong) NSMutableParagraphStyle* paragraphStyle;
@property(nonatomic, copy) NSString* text;
@property(nonatomic, strong) UIColor* colorText;
@property(nonatomic, strong) UIColor* colorBackgroud;
@property(nonatomic, strong) UIFont* font;
@end


@implementation TextImageView

- (id)initWithText:(NSString*)text frame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [_paragraphStyle setAlignment:NSTextAlignmentLeft];
        [_paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        [_paragraphStyle setLineSpacing:18.f];  //行间距
        [_paragraphStyle setParagraphSpacing:5.f];//字符间距
        
        _colorText = [UIColor blackColor];
        _colorBackgroud = [UIColor clearColor];
        _font = [UIFont systemFontOfSize:30];
        
        _text = text;
        [self updateTextImage];
    }
    return self;
}

- (void)setText:(NSString*)text
{
    _text = text;
}

//行间距
- (void)setLineSpacing:(float)spacing
{
    [_paragraphStyle setLineSpacing:spacing];
}

//字符间距
- (void)setParagraphSpacing:(float)spacing
{
    [_paragraphStyle setParagraphSpacing:spacing];
}

//对齐方式
- (void)setTextAlignment:(NSTextAlignment)alignment
{
    [_paragraphStyle setAlignment:alignment];
}

//设置颜色
- (void)setTextColor:(UIColor*)colorText backgroudColor:(UIColor*)colorBackgroud
{
    _colorText = colorText;
    _colorBackgroud = colorBackgroud;
}

- (void)setFontWithName:(NSString*)fontName size:(int)fontSize
{
    _font = [UIFont fontWithName:fontName size:fontSize];
}


- (void)updateTextImage
{
    NSDictionary* attributes = @{
                    NSFontAttributeName            : _font,
                    NSForegroundColorAttributeName : _colorText,
                    NSBackgroundColorAttributeName : _colorBackgroud,
                    NSParagraphStyleAttributeName : _paragraphStyle,
                    };
    self.image = [self imageFromString:_text attributes:attributes size:self.bounds.size];
}

/**
 把文字转换为图片;
 
 @param string 文字,
 @param attributes 文字的属性
 @param size 转换后的图片宽高
 @return 返回图片
 */
- (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
