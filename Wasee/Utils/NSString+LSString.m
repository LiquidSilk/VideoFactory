//
//  NSString+LSString.m
//  Wasee
//
//  Created by 陈忠杰 on 2017/8/10.
//  Copyright © 2017年 陈忠杰. All rights reserved.
//

#import "NSString+LSString.h"

@implementation NSString (LSString)

- (BOOL) isBlankString {
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
