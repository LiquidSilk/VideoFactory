//
//  MediaUtil.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/6.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MediaUtil : NSObject


+ (void)cutMedia:(NSURL*)sourceUrl
     outFileName:(NSString*)outFileName
  containerFrame:(CGSize)size
          target:(id)target
        selector:(SEL)aSelector
      onComplete:(void(^)())block;

//生成白色底视频
+ (void)generateWhiteVideoWithSize:(CGSize)size
                          duration:(int)duration
                          projName:(NSString*)projName
                        onComplete:(void(^)())onComplete;


+ (void)generateTransparentWithSize:(CGSize)size
                           projName:(NSString*)projName
                           fileName:(NSString*)fileName
                              image:(UIImage*)image
                           onFinish:(void(^)())finishBlock;

+ (void)editVideoSynthesizeVieoPath:(NSURL*)assetURL
                      originBGMPath:(NSURL*)originBGMPath
                    originBGMVolume:(CGFloat)originBGMVolume
                          voicePath:(NSURL*)voiceURLPath
                        voiceVolume:(CGFloat)voiceVolume
                        videoVolume:(CGFloat)videoVolume
                         outputPath:(NSURL*)outputPath
                         complition:(void (^)(NSURL* outputPath,BOOL isSucceed)) completionHandle;

@end
