//
//  AudioVolumeViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/17.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "AudioVolumeViewController.h"
#import "UIUitls.h"
#import "Utils.h"

@interface AudioVolumeViewController ()

@property(nonatomic, strong)UISlider* sliderOrigin;
@property(nonatomic, strong)UISlider* sliderMusic;
@property(nonatomic, strong)UISlider* sliderVoice;
@property(nonatomic, strong)UILabel* labelOrigin;
@property(nonatomic, strong)UILabel* labelMusic;
@property(nonatomic, strong)UILabel* labelVoice;
@property(nonatomic, strong)UILabel* labelPercentOrigin;
@property(nonatomic, strong)UILabel* labelPercentMusic;
@property(nonatomic, strong)UILabel* labelPercentVoice;

@end

@implementation AudioVolumeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.sliderOrigin];
    [self.view addSubview:self.sliderMusic];
    [self.view addSubview:self.sliderVoice];
    
    [self createLabel];
    
//    [self setSliderEnable:NO];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_sliderMusic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).offset(5);
        make.centerY.mas_equalTo(self.view).offset(-30);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(30);
    }];
    
    [_sliderOrigin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_sliderMusic);
        make.centerY.mas_equalTo(_sliderMusic.mas_centerY).offset(-50);
        make.width.mas_equalTo(_sliderMusic);
        make.height.mas_equalTo(_sliderMusic);
    }];
    
    [_sliderVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_sliderMusic);
        make.centerY.mas_equalTo(_sliderMusic.mas_centerY).offset(50);
        make.width.mas_equalTo(_sliderMusic);
        make.height.mas_equalTo(_sliderMusic);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 公有方法
- (void)show:(BOOL)bShow
{
    self.view.hidden = !bShow;
}

- (void)setSlider:(int)sliderType enable:(BOOL)bEnable
{
    UISlider* slider = nil;
    UILabel* labelTitle = nil;
    UILabel* labelPercent = nil;
    if (sliderType == 0)
    {
        slider = _sliderOrigin;
        labelTitle = _labelOrigin;
        labelPercent = _labelPercentOrigin;
    }
    else if (sliderType == 1)
    {
        slider = _sliderMusic;
        labelTitle = _labelMusic;
        labelPercent = _labelPercentMusic;
    }
    else if (sliderType == 2)
    {
        slider = _sliderVoice;
        labelTitle = _labelVoice;
        labelPercent = _labelPercentVoice;
    }
    [slider setEnabled:bEnable];
    labelTitle.textColor = bEnable ? [UIColor whiteColor] : [UIColor grayColor];
    labelPercent.textColor = bEnable ? [UIColor whiteColor] : [UIColor grayColor];
}


#pragma mark - 私有方法
- (void)createLabel
{
    _labelOrigin = [[UILabel alloc] init];
    _labelOrigin.text = @"原声";
    _labelOrigin.textColor = [UIColor whiteColor];
    [self.view addSubview:_labelOrigin];
    [_labelOrigin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_sliderOrigin.mas_left).offset(-30);
        make.centerY.mas_equalTo(_sliderOrigin.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25);
    }];
    
    _labelMusic = [[UILabel alloc] init];
    _labelMusic.text = @"音乐";
    _labelMusic.textColor = [UIColor whiteColor];
    [self.view addSubview:_labelMusic];
    [_labelMusic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_labelOrigin);
        make.centerY.mas_equalTo(_sliderMusic.mas_centerY);
        make.width.height.mas_equalTo(_labelOrigin);
    }];
    
    _labelVoice = [[UILabel alloc] init];
    _labelVoice.text = @"配音";
    _labelVoice.textColor = [UIColor whiteColor];
    [self.view addSubview:_labelVoice];
    [_labelVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_labelOrigin);
        make.centerY.mas_equalTo(_sliderVoice.mas_centerY);
        make.width.height.mas_equalTo(_labelOrigin);
    }];
    
    
    _labelPercentOrigin = [[UILabel alloc] init];
    _labelPercentOrigin.text = @"50";
    _labelPercentOrigin.textColor = [UIColor whiteColor];
    [self.view addSubview:_labelPercentOrigin];
    [_labelPercentOrigin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_sliderOrigin.mas_right).offset(35);
        make.centerY.mas_equalTo(_sliderOrigin.mas_centerY);
        make.width.height.mas_equalTo(_labelOrigin);
    }];
    
    _labelPercentMusic = [[UILabel alloc] init];
    _labelPercentMusic.text = @"50";
    _labelPercentMusic.textColor = [UIColor whiteColor];
    [self.view addSubview:_labelPercentMusic];
    [_labelPercentMusic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_labelPercentOrigin);
        make.centerY.mas_equalTo(_sliderMusic.mas_centerY);
        make.width.height.mas_equalTo(_labelPercentOrigin);
    }];
    
    _labelPercentVoice = [[UILabel alloc] init];
    _labelPercentVoice.text = @"50";
    _labelPercentVoice.textColor = [UIColor whiteColor];
    [self.view addSubview:_labelPercentVoice];
    [_labelPercentVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_labelPercentOrigin);
        make.centerY.mas_equalTo(_sliderVoice.mas_centerY);
        make.width.height.mas_equalTo(_labelPercentOrigin);
    }];
}


#pragma mark - getter
- (UISlider*)sliderOrigin
{
    if (!_sliderOrigin)
    {
        _sliderOrigin = [[UISlider alloc] init];
        _sliderOrigin.minimumTrackTintColor = [UIColor whiteColor];
        _sliderOrigin.maximumTrackTintColor = [UIColor grayColor];
        _sliderOrigin.maximumValue = 1;
        _sliderOrigin.minimumValue = 0;
        _sliderOrigin.value = 0.5;
        [[_sliderOrigin rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UISlider * _Nullable slider) {
            NSLog(@"_sliderOrigin = %.2f", slider.value);
            _labelPercentOrigin.text = [NSString stringWithFormat:@"%.0f", slider.value * 100];
            if (_delegate) {
                [_delegate recordViewController:self originVolume:_sliderOrigin.value musicVolume:_sliderMusic.value voiceVolume:_sliderVoice.value];
            }
        }];
    }
    return _sliderOrigin;
}

- (UISlider*)sliderMusic
{
    if (!_sliderMusic)
    {
        _sliderMusic = [[UISlider alloc] init];
        _sliderMusic.minimumTrackTintColor = [UIColor whiteColor];
        _sliderMusic.maximumTrackTintColor = [UIColor grayColor];
        _sliderMusic.maximumValue = 1;
        _sliderMusic.minimumValue = 0;
        _sliderMusic.value = 0.5;
        [[_sliderMusic rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UISlider * _Nullable slider) {
            NSLog(@"_sliderMusic = %.2f", slider.value);
            _labelPercentMusic.text = [NSString stringWithFormat:@"%.0f", slider.value * 100];
            if (_delegate) {
                [_delegate recordViewController:self originVolume:_sliderOrigin.value musicVolume:_sliderMusic.value voiceVolume:_sliderVoice.value];
            }
        }];
    }
    return _sliderMusic;
}

- (UISlider*)sliderVoice
{
    if (!_sliderVoice)
    {
        _sliderVoice = [[UISlider alloc] init];
        _sliderVoice.minimumTrackTintColor = [UIColor whiteColor];
        _sliderVoice.maximumTrackTintColor = [UIColor grayColor];
        _sliderVoice.maximumValue = 1;
        _sliderVoice.minimumValue = 0;
        _sliderVoice.value = 0.5;
        [[_sliderVoice rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UISlider * _Nullable slider) {
            NSLog(@"_sliderVoice = %.2f", slider.value);
            _labelPercentVoice.text = [NSString stringWithFormat:@"%.0f", slider.value * 100];
            if (_delegate) {
                [_delegate recordViewController:self originVolume:_sliderOrigin.value musicVolume:_sliderMusic.value voiceVolume:_sliderVoice.value];
            }
        }];
    }
    return _sliderVoice;
}
@end
