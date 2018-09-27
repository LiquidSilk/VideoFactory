//
//  TextImageView.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/5/31.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextImageView : UIImageView

- (id)initWithText:(NSString*)text frame:(CGRect)frame;
- (void)setText:(NSString*)text;
- (void)setLineSpacing:(float)spacing;
- (void)setParagraphSpacing:(float)spacing;
- (void)setTextAlignment:(NSTextAlignment)alignment;
- (void)setTextColor:(UIColor*)colorText backgroudColor:(UIColor*)colorBackgroud;
- (void)setFontWithName:(NSString*)fontName size:(int)fontSize;
- (void)updateTextImage;
@end
