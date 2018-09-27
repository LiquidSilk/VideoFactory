//
//  StickerView.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/21.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sticker.h"

@class StickerView;
@protocol StickerViewDelegate <NSObject>

- (void)StickerView:(StickerView *)stickerView onRemoveWithKey:(Sticker*)sticker;
- (void)StickerView:(StickerView *)stickerView onClickEdit:(Sticker *)sticker;
@end

@interface StickerView : UIView

@property(nonatomic, weak)id<StickerViewDelegate> delegate;

- (instancetype)init;

- (Sticker*)addSticker;
- (void)setStickerWithKey:(NSString*)key show:(BOOL)bShow;
- (UIView*)getViewWithKey:(NSString*)key;
@end
