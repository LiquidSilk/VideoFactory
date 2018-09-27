//
//  EditorTextColorViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/12.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "EditorTextColorViewController.h"
#import "RSBrightnessSlider.h"
#import "RSOpacitySlider.h"
#import "UIUitls.h"

@interface EditorTextColorViewController () <RSColorPickerViewDelegate>

@property (nonatomic) RSColorPickerView *colorPicker;
@property (nonatomic) RSBrightnessSlider *brightnessSlider;
@property (nonatomic) RSOpacitySlider *opacitySlider;
@property (nonatomic,weak) UIButton *curBtn;

@end

@implementation EditorTextColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super showNavigationBar:NO];
    
    _colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _colorPicker.cropToCircle = YES;
    [_colorPicker setDelegate:self];
    [self.view addSubview:_colorPicker];
    [_colorPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(200);
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    _brightnessSlider = [[RSBrightnessSlider alloc] init];
    [_brightnessSlider setColorPicker:_colorPicker];
    [self.view addSubview:_brightnessSlider];
    [_brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_colorPicker.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
    }];
    
    _opacitySlider = [[RSOpacitySlider alloc] init];
    [_opacitySlider setColorPicker:_colorPicker];
    [self.view addSubview:_opacitySlider];
    [_opacitySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_brightnessSlider.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
    }];
    
    UIButton* btnCenter = [[UIButton alloc] init];
    btnCenter.tag = 2;
    [btnCenter setImage:[UIImage imageNamed:@"居中对齐"] forState:UIControlStateNormal];
    [[btnCenter rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [_subjectAlign sendNext:@"center"];
        [self setFocus:2];
    }];
    [self.view addSubview:btnCenter];
    [btnCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_opacitySlider.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    UIButton* btnLeft = [[UIButton alloc] init];
    btnLeft.tag = 1;
    [btnLeft setImage:[UIImage imageNamed:@"左对齐"] forState:UIControlStateNormal];
    [[btnLeft rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [_subjectAlign sendNext:@"left"];
        [self setFocus:1];
    }];
    [self.view addSubview:btnLeft];
    [btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnCenter.mas_top);
        make.right.mas_equalTo(btnCenter.mas_left).offset(-40);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    UIButton* btnRight = [[UIButton alloc] init];
    btnRight.tag = 3;
    [btnRight setImage:[UIImage imageNamed:@"右对齐"] forState:UIControlStateNormal];
    [[btnRight rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [_subjectAlign sendNext:@"right"];
        [self setFocus:3];
    }];
    [self.view addSubview:btnRight];
    [btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnCenter.mas_top);
        make.left.mas_equalTo(btnCenter.mas_right).offset(40);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self setFocus:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - RSColorPickerView delegate methods

- (void)colorPickerDidChangeSelection:(RSColorPickerView *)cp {
    UIColor *color = [cp selectionColor];
    [_subjectColor sendNext:color];
}


- (void)show:(BOOL)bShow
{
    self.view.hidden = !bShow;
}

//1:左 2:中 3:右
- (void)setFocus:(NSInteger)btnTag
{
    if(_curBtn.tag == 1)
    {
        [_curBtn setImage:[UIImage imageNamed:@"左对齐"] forState:UIControlStateNormal];
    }
    else if(_curBtn.tag == 2)
    {
        [_curBtn setImage:[UIImage imageNamed:@"居中对齐"] forState:UIControlStateNormal];
    }
    else if (_curBtn.tag == 3)
    {
        [_curBtn setImage:[UIImage imageNamed:@"右对齐"] forState:UIControlStateNormal];
    }
    
    UIButton* btn = [self.view viewWithTag:btnTag];
    if(btnTag == 1)
    {
        [btn setImage:[UIImage imageNamed:@"左对齐选中"] forState:UIControlStateNormal];
    }
    else if(btnTag == 2)
    {
        [btn setImage:[UIImage imageNamed:@"居中对齐选中"] forState:UIControlStateNormal];
    }
    else if (btnTag == 3)
    {
        [btn setImage:[UIImage imageNamed:@"右对齐选中"] forState:UIControlStateNormal];
    }
    
    _curBtn = btn;
}

@end
