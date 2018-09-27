//
//  WaseeSceneRenderer.h
//  testGVR
//
//  Created by 陈忠杰 on 2018/4/9.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <GVRKit/GVRKit.h>

@protocol WaseeSceneRendererDelegate <NSObject>

@optional
//凝视3秒
- (void)WaseeSceneRendererOnGaze:(bool)isLookAt;
//开始看
- (void)WaseeSceneRendererOnLookAt:(bool)isLookAt;
@end


@interface WaseeSceneRenderer : GVRSceneRenderer
@property(nonatomic,weak)id<WaseeSceneRendererDelegate> delegate;
@end
