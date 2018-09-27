//
//  EditorAudioCombineViewController.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/13.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaterPeriodVideoViewController.h"

@interface EditorAudioCombineViewController : UIViewController


@property(nonatomic, weak)LaterPeriodVideoViewController* laterPeriodVideoVC;
@property(nonatomic, copy)NSString* projName;


- (void)stopRecord;
@end
