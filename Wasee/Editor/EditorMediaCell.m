//
//  EditorMediaCell.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/9.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "EditorMediaCell.h"
#import "UIUitls.h"

@interface EditorMediaCell()

@property(nonatomic, strong)UIView* view;
@property(nonatomic, strong)UIImageView* imageView;

@end


@implementation EditorMediaCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _view = [[UIView alloc] init];
        _view.backgroundColor = [UIColor redColor];
        [self addSubview:_view];
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _view.frame = self.bounds;
//    _imageView.frame = self.bounds;
}

- (void)setType:(int)type
{
//    if (type == 0) {
//        _view.backgroundColor = [UIColor redColor];
//    }
//    else if (type == 1)
//    {
//        _view.backgroundColor = [UIColor blueColor];
//    }
//    else if (type == 2)
//    {
//        _view.backgroundColor = [UIColor purpleColor];
//    }
    _view.backgroundColor = [UIColor whiteColor];;
}

- (void)setImage:(UIImage*)image
{
    _imageView.image = image;
    
    if (image.size.width / image.size.height > CGRectGetWidth(self.frame) / CGRectGetHeight(self.frame))
    {
        [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(self.mas_width).multipliedBy(image.size.height / image.size.width);
        }];
    }
    else
    {
        [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_height).multipliedBy(image.size.width / image.size.height);
        }];
    }
}

- (void)setImageViewWithURL:(NSString *)url
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image.size.width / image.size.height > CGRectGetWidth(self.frame) / CGRectGetHeight(self.frame))
        {
            [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self);
                make.centerY.mas_equalTo(self);
                make.height.mas_equalTo(self.mas_width).multipliedBy(image.size.height / image.size.width);
            }];
        }
        else
        {
            [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(self);
                make.centerX.mas_equalTo(self);
                make.width.mas_equalTo(self.mas_height).multipliedBy(image.size.width / image.size.height);
            }];
        }
    }];
}

@end
