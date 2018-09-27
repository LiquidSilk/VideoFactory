//
//  Utils.m
//  Wasee
//
//  Created by 陈忠杰 on 2017/8/8.
//  Copyright © 2017年 陈忠杰. All rights reserved.
//

#import "Utils.h"


@implementation Utils


+ (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

//获取当前时间戳
+ (NSTimeInterval)currentTimeStamp{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];//精确到秒
    return time;
}

+ (NSString*)getDeviceId
{
    NSString* strUDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return strUDID;
}

@end
