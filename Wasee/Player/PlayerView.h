//
//  PlayerView.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/4/18.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaseeSceneRenderer.h"

@protocol PlayerViewDelegate <NSObject>

@optional
-(void)playerViewOnPlaySelect;

@end



@interface PlayerView : UIView

@property(nonatomic, strong)GVRRendererViewController *gvrViewController;
@property(nonatomic,weak)id<PlayerViewDelegate> delegate;
@end
