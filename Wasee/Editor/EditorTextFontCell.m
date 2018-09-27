//
//  EditorTextFontCell.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/11.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "EditorTextFontCell.h"
#import "UIUitls.h"

@interface EditorTextFontCell()

@property(nonatomic, strong) UILabel* fontName;

@end


@implementation EditorTextFontCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    _fontName = [[UILabel alloc] init];
    _fontName.text = @"字体";
    [self addSubview:_fontName];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_fontName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(self.mas_width);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(self.mas_height);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
