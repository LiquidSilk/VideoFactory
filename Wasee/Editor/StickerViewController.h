//
//  StickerViewController.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/27.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sticker.h"

@class StickerViewController;

@protocol StickerViewControllerDelegate <NSObject>

@optional
- (void)stickerViewController:(StickerViewController*)vc addSticker:(Sticker*)sticker;
- (void)stickerViewController:(StickerViewController*)vc removeSticker:(Sticker*)sticker;
@end


@interface StickerViewController : UIViewController

@property(nonatomic, weak)id<StickerViewControllerDelegate> delegate;

- (void)addSubviewTo:(UIView*)parentView;
- (void)setStickerWithKey:(NSString*)key show:(BOOL)bShow;
- (UIView*)getStickerWithKey:(NSString*)key;
@end
