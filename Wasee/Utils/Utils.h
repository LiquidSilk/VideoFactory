//
//  Utils.h
//  Wasee
//
//  Created by 陈忠杰 on 2017/8/8.
//  Copyright © 2017年 陈忠杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"
#import "NSString+LSString.h"
#import "FileUtils.h"
#import "ReactiveObjC.h"

#define APP_DEBUG 1



@interface Utils : NSObject

+ (NSString *)timeFormatted:(int)totalSeconds;

+ (NSTimeInterval)currentTimeStamp;

+ (NSString*)getDeviceId;

@end
