//
//  Sticker.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/23.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "Sticker.h"
#import "UIUitls.h"

static int SCALE_BUTTON_WIDTH = 20;
@interface Sticker()
{
}


@property(nonatomic, strong)UIView* stickerContentView;
@property(nonatomic, assign)CGRect originRect;
@end


@implementation Sticker

- (instancetype)initWithRect:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if (self) {
        self.layer.anchorPoint = CGPointMake(0, 0);
        self.backgroundColor = [UIColor blueColor];
        _mode = 1;
        _ratio = 1;
        
        [self addSubview:self.stickerContentView];
        [_stickerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leftMargin.topMargin.mas_equalTo(SCALE_BUTTON_WIDTH / 2);
            make.rightMargin.bottomMargin.mas_equalTo( -SCALE_BUTTON_WIDTH / 2);
        }];
        [self addSubview:self.scaleView];
        [_scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(self);
            make.width.height.mas_equalTo(SCALE_BUTTON_WIDTH);
        }];
        [self addSubview:self.closeView];
        [_closeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self);
            make.width.height.mas_equalTo(SCALE_BUTTON_WIDTH);
        }];
        [self addSubview:self.editView];
        [_editView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(self);
            make.width.height.mas_equalTo(SCALE_BUTTON_WIDTH);
        }];
        _originRect = rect;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateScaleView];
}

- (void)updateScaleView
{
    if (_mode == 1)
    {
        float scale = self.transform.a;
        [_scaleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(self);
            make.width.height.mas_equalTo(SCALE_BUTTON_WIDTH / scale);
        }];
        [_closeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self);
            make.width.height.mas_equalTo(SCALE_BUTTON_WIDTH / scale);
        }];
        [_editView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(self);
            make.width.height.mas_equalTo(SCALE_BUTTON_WIDTH / scale);
        }];
        [_stickerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leftMargin.topMargin.mas_equalTo(SCALE_BUTTON_WIDTH / scale / 2);
            make.rightMargin.bottomMargin.mas_equalTo( -SCALE_BUTTON_WIDTH / scale / 2);
        }];
    }
    else
    {
        //videofactory 用到
//        float scale = self.transform.a;
//        float scale2 = CGRectGetWidth(self.frame) / scale / (CGRectGetWidth(_originRect) * 4);
        float margin = _ratio * SCALE_BUTTON_WIDTH;
        [_scaleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(self);
            make.width.height.mas_equalTo(0);
        }];
        [_closeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self);
            make.width.height.mas_equalTo(0);
        }];
        [_editView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(self);
            make.width.height.mas_equalTo(0);
        }];
        [_stickerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leftMargin.topMargin.mas_equalTo(margin / 2);
            make.rightMargin.bottomMargin.mas_equalTo(-margin / 2);
        }];
    }
}

- (void)showTool:(BOOL)bShow
{
    [_closeView setHidden:!bShow];
    [_editView setHidden:!bShow];
    [_scaleView setHidden:!bShow];
}

- (void)setMode:(NSUInteger)mode ratio:(float)ratio
{
    _mode = mode;
    _ratio = ratio;
}

#pragma mark - getter
- (UIView*)scaleView
{
    if (!_scaleView) {
        _scaleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCALE_BUTTON_WIDTH, SCALE_BUTTON_WIDTH)];
        UIImageView* imageScale = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"拉伸"]];
        [_scaleView addSubview:imageScale];
        [imageScale mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(_scaleView);
        }];
    }
    return _scaleView;
}

- (UIView*)closeView
{
    if (!_closeView) {
        _closeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCALE_BUTTON_WIDTH, SCALE_BUTTON_WIDTH)];
        UIImageView* imageClose = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"删除贴图"]];
        [_closeView addSubview:imageClose];
        [imageClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(_closeView);
        }];
    }
    return _closeView;
}

- (UIView*)editView
{
    if (!_editView) {
        _editView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCALE_BUTTON_WIDTH, SCALE_BUTTON_WIDTH)];
        UIImageView* imageEdit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"编辑"]];
        [_editView addSubview:imageEdit];
        [imageEdit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(_editView);
        }];
    }
    return _editView;
}

- (UIView*)stickerContentView
{
    if (!_stickerContentView) {
        _stickerContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCALE_BUTTON_WIDTH, SCALE_BUTTON_WIDTH)];
        _stickerContentView.backgroundColor = [UIColor redColor];
//        UIImageView* lena = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lena"]];
//        [_stickerContentView addSubview:lena];
//        [lena mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.bottom.mas_equalTo(self.stickerContentView);
//        }];
    }
    return _stickerContentView;
}

@end
