//
//  RecordViewController.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/13.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordViewController;

static const NSInteger BTN_TYPE_START = 1;
static const NSInteger BTN_TYPE_STOP = 2;
static const NSInteger BTN_TYPE_DELETE = 3;

@protocol RecordViewControllerDelegate <NSObject>
@optional
- (void)recordViewController:(RecordViewController*)vc onPushButton:(NSInteger)type path:(NSString*)recordPath;
@end


@interface RecordViewController : UIViewController

@property(nonatomic, copy)NSString* projName;
@property(nonatomic, weak)id<RecordViewControllerDelegate> delegate;

- (void)stopRecord;
- (void)show:(BOOL)bShow;
//音频播放相关
- (void)startRecordPalyer;
- (void)pauseRecordPalyer;
@end
