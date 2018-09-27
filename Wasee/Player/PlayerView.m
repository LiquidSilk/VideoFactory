//
//  PlayerView.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/4/18.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "PlayerView.h"
#import "UIUitls.h"

#import <GVRKit/GVRKit.h>
#import <GVRVideoView.h>

static NSString * const PBJViewControllerVideoPath = @"https://resource.v123.cn/v/Data/upload/cloud/201611/937770344/video/201803/5aaa2e2ed9a7b.mp4";

@interface PlayerView()<
    UIGestureRecognizerDelegate>
{
    BOOL isVRMode;
}

@property(nonatomic, strong)UISlider* slider;
@property(nonatomic, strong)UITapGestureRecognizer* tapGesture;



@end



@implementation PlayerView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self createSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)createSubViews
{
    self.backgroundColor = [UIColor blueColor];
    
    //1
    UIButton* btnPlayPause = [[UIButton alloc] init];
    UIImage *imgShareN = [UIImage imageNamed:@"full_play_btn_hl"];
    UIImage *imgShareF = [UIImage imageNamed:@"full_play_btn_hl"];
    [btnPlayPause setBackgroundImage:imgShareN forState:UIControlStateNormal];
    [btnPlayPause setBackgroundImage:imgShareF forState:UIControlStateHighlighted];
    [btnPlayPause addTarget:self action:@selector(btnPlayPauseOnSelected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnPlayPause];
    [btnPlayPause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    
    //2
    _slider = [[UISlider alloc] init];
    [_slider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [self addSubview:_slider];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btnPlayPause.mas_right).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-100);
        make.centerY.mas_equalTo(btnPlayPause.mas_centerY);
    }];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    _tapGesture.delegate = self;
    [_slider addGestureRecognizer:_tapGesture];
    [_slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:_slider];
    
    float curValue = _slider.value;
    float curPointX = _slider.frame.size.width * curValue;
    if (fabs(curPointX - touchPoint.x) < 5) {
        return;
    }
    CGFloat value = (_slider.maximumValue - _slider.minimumValue) * (touchPoint.x/ _slider.frame.size.width );
    [_slider setValue:value animated:YES];
}

- (void)sliderTouchDown:(UISlider *)sender {
    _tapGesture.enabled = NO;
}

- (void)sliderTouchUp:(UISlider *)sender {
    _tapGesture.enabled = YES;
}


//播放暂停
-(void)btnPlayPauseOnSelected {
    if(_delegate)
    {
        [_delegate playerViewOnPlaySelect];
    }
}
@end
