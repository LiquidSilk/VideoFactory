//
//  EditorTextViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/11.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "EditorTextViewController.h"
#import "UIUitls.h"
#import "Utils.h"
#import "LUNSegmentedControl.h"
#import "IQKeyboardManager.h"
#import "EditorTextFontTableViewController.h"
#import "EditorTextColorViewController.h"

#import "TextFieldCounter.h"
#import "TextImageView.h"

@interface EditorTextViewController ()<LUNSegmentedControlDataSource, LUNSegmentedControlDelegate, UITextFieldDelegate>
{
    NSArray* tabNameList;
}
@property(nonatomic, assign) CGRect textRect;
@property(nonatomic, assign) int fontSize;
@property(nonatomic, assign) int textCountLimit;
@property(nonatomic, copy) NSString* defaultText;

@property(nonatomic, strong) TextFieldCounter* textFieldCounter;
@property(nonatomic, strong) EditorTextFontTableViewController* fontTableVC;
@property(nonatomic, strong) EditorTextColorViewController* textColorVC;
@property(nonatomic, strong) LUNSegmentedControl *segmentedControl;
@end

@implementation EditorTextViewController


- (instancetype)initWithTextRect:(CGRect)rect fontSize:(int)fontSize limit:(int)limit defaultText:(NSString*)text
{
    self = [super init];
    if (self) {
        self.textRect = rect;
        self.fontSize = fontSize;
        self.textCountLimit = limit;
        self.defaultText = text;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    tabNameList = @[@"编辑", @"字体", @"样式"];
    
    [super setNavigationColor:BG_BLACK];
    [super setTintColor:BG_WHITE];
    self.view.backgroundColor = UIColorFromRGB(BG_BLACK);
    
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.textFieldCounter];
    
    [self createNavigationButton];
    
    [IQKeyboardManager sharedManager].enable = YES;
}

- (NSArray<UIColor *> *)segmentedControl:(LUNSegmentedControl *)segmentedControl gradientColorsForStateAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @[UIColorFromRGB(0x628bff), UIColorFromRGB(0x50c4ff)];
            break;
        case 1:
            return @[UIColorFromRGB(0x628bff), UIColorFromRGB(0x50c4ff)];
            break;
        case 2:
            return @[UIColorFromRGB(0x628bff), UIColorFromRGB(0x50c4ff)];
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)numberOfStatesInSegmentedControl:(LUNSegmentedControl *)segmentedControl {
    return 3;
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForStateAtIndex:(NSInteger)index {
    return [[NSAttributedString alloc] initWithString:tabNameList[index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForSelectedStateAtIndex:(NSInteger)index {
    return [[NSAttributedString alloc] initWithString:tabNameList[index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:16]}];
}

- (void)segmentedControl:(LUNSegmentedControl *)segmentedControl didChangeStateFromStateAtIndex:(NSInteger)fromIndex toStateAtIndex:(NSInteger)toIndex
{
    NSLog(@"fromIndex = %d toIndex = %d", fromIndex, toIndex);
    if (toIndex == 0) {
        [_textFieldCounter becomeFirstResponder];
        [self showTab:0];
    }
    else if (toIndex == 1) {
        [_textFieldCounter resignFirstResponder];
        [self showTab:1];
    }
    else
    {
        [_textFieldCounter resignFirstResponder];
        [self showTab:2];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-50);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
    
    __block float textWidth = MIN(_textRect.size.width, 360);
    float ratio = textWidth / _textRect.size.width;
    [_textFieldCounter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(-150);
        make.width.mas_equalTo(textWidth);
        make.height.mas_equalTo(_textRect.size.height).multipliedBy(ratio);
    }];
    _textFieldCounter.font = [UIFont systemFontOfSize:(_fontSize * ratio)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 控件创建
- (UITextField*)textFieldCounter
{
    if (_textFieldCounter == nil) {
        _textFieldCounter = [[TextFieldCounter alloc] initWithLimit:_textCountLimit];
        _textFieldCounter.placeholder = @"请输入文字";
        _textFieldCounter.text = self.defaultText;
        [_textFieldCounter updateTextCount];
        _textFieldCounter.clearButtonMode = UITextFieldViewModeUnlessEditing;
//        _textFieldCounter.keyboardType = UIKeyboardTypeNumberPad;//数字键盘
//        _textFieldCounter.returnKeyType = UIReturnKeyGo;//键盘右下角显示go
        _textFieldCounter.font = [UIFont systemFontOfSize:_fontSize];
        _textFieldCounter.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [_textFieldCounter addTarget:self action:@selector(textFieldDidChanging:) forControlEvents:UIControlEventEditingDidBegin];
        [self.view addSubview:_textFieldCounter];
    }
    return _textFieldCounter;
}

- (EditorTextFontTableViewController*)fontTableVC
{
    if (_fontTableVC == nil)
    {
        _fontTableVC = [[EditorTextFontTableViewController alloc] init];
        [self addChildViewController:_fontTableVC];
        [self.view addSubview:_fontTableVC.tableView];
        [_fontTableVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(_segmentedControl.mas_bottom).offset(5);
        }];
    }
    return _fontTableVC;
}

- (EditorTextColorViewController*)textColorVC
{
    if (_textColorVC == nil)
    {
        _textColorVC = [[EditorTextColorViewController alloc] init];
        //1.颜色信号
        RACSubject* subjectColor = [RACSubject subject];
        _textColorVC.subjectColor = subjectColor;
        __weak typeof(self) weakself = self;
        [subjectColor subscribeNext:^(UIColor* color) {
            weakself.textFieldCounter.textColor = color;
        }];
        
        //2.对齐信号
        RACSubject* subjectAlign = [RACSubject subject];
        _textColorVC.subjectAlign = subjectAlign;
        [subjectAlign subscribeNext:^(NSString* align) {
            weakself.textFieldCounter.textAlignment = [align isEqualToString:@"right"] ? NSTextAlignmentRight :
            ([align isEqualToString:@"left"] ? NSTextAlignmentLeft : NSTextAlignmentCenter) ;
        }];
        
        [self addChildViewController:_textColorVC];
        [self.view addSubview:_textColorVC.view];
        [_textColorVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(_segmentedControl.mas_bottom).offset(5);
        }];
    }
    return _textColorVC;
}

- (LUNSegmentedControl*)segmentedControl
{
    if (_segmentedControl == nil)
    {
        _segmentedControl = [[LUNSegmentedControl alloc] init];
        _segmentedControl.delegate = self;
        _segmentedControl.dataSource = self;
        _segmentedControl.backgroundColor = UIColorFromRGB(BG_WHITE);
        _segmentedControl.selectorViewColor = UIColorFromRGB(0x50b4ff);
        _segmentedControl.cornerRadius = 26;
        _segmentedControl.transitionStyle = LUNSegmentedControlTransitionStyleSlide;
    }
    return _segmentedControl;
}

#pragma mark - textfield回调
- (void) textFieldDidChanging:(id) sender {
    UITextField *_field = (UITextField *)sender;
    [self showTab:0];
    [_segmentedControl setCurrentState:0];
}

#pragma mark - 确定按钮
- (void) saveText
{
    TextImageView* textImageView = [[TextImageView alloc] initWithText:@"" frame:CGRectMake(0, 0, _textRect.size.width, _textRect.size.height)];
    [textImageView setText:self.textFieldCounter.text];
    [textImageView setTextColor:self.textFieldCounter.textColor backgroudColor:[UIColor clearColor]];
    [textImageView setTextAlignment:self.textFieldCounter.textAlignment];
    [textImageView setFontWithName:@"Arial-BoldItalicMT" size:_fontSize];
    [textImageView updateTextImage];
    //        textImageView.layer.anchorPoint = CGPointMake(0, 1);
    
//    __weak typeof(self) weakSelf = self;
    self.onSavedBlock(textImageView, self.textFieldCounter.text);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - method
- (void) showTab:(int)num
{
    switch (num) {
        case 0:
            [self.fontTableVC show:NO];
            [self.textColorVC show:NO];
            break;
        case 1:
            [self.fontTableVC show:YES];
            [self.textColorVC show:NO];
            break;
        case 2:
            [self.fontTableVC show:NO];
            [self.textColorVC show:YES];
            break;
        default:
            break;
    }
}

/*
 * 创建导航按钮
 */
- (void)createNavigationButton
{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveText)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}
@end
