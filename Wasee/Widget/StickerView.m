//
//  StickerView.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/21.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "StickerView.h"
#import "UIUitls.h"

@interface StickerView()
{
    float originWidth;
    float originHeight;
    int   direction;
    int   tag; //每个sticker的tag
}
@property(nonatomic, strong)NSMutableDictionary* stickerList;

@end




@implementation StickerView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tag = 0;
        self.stickerList = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        tag = 0;
        self.stickerList = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}



#pragma mark pan   平移手势事件
- (void)panMoveView:(UIPanGestureRecognizer *)panGesture
{
    Sticker *mainView = (Sticker*)panGesture.view;
    CGPoint point = [panGesture translationInView:mainView];
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        [self focusOnSticker:mainView];
    }
    panGesture.view.transform = CGAffineTransformTranslate(panGesture.view.transform, point.x, 0);
    if (CGRectGetMinX(mainView.frame) <= 0)
    {
        //超出左边界
        panGesture.view.frame = CGRectMake(0,
                                           mainView.frame.origin.y,
                                           mainView.frame.size.width,
                                           mainView.frame.size.height);
    }
    else if(CGRectGetMaxX(mainView.frame) >= CGRectGetWidth(self.frame))
    {
        //超过右边界
        panGesture.view.frame = CGRectMake(self.frame.size.width - mainView.frame.size.width,
                                           mainView.frame.origin.y,
                                           mainView.frame.size.width,
                                           mainView.frame.size.height);
    }
    
    panGesture.view.transform = CGAffineTransformTranslate(panGesture.view.transform, 0, point.y);
    if (CGRectGetMinY(mainView.frame) <= 0) {
        //超出上边界
        panGesture.view.frame = CGRectMake(mainView.frame.origin.x,
                                           0,
                                           mainView.frame.size.width,
                                           mainView.frame.size.height);
    }
    else if(CGRectGetMaxY(mainView.frame) >= CGRectGetHeight(self.frame))
    {
        //超出下边界
        panGesture.view.frame = CGRectMake(mainView.frame.origin.x,
                                           self.frame.size.height - mainView.frame.size.height,
                                           mainView.frame.size.width,
                                           mainView.frame.size.height);
    }
    
    
    
//    CGPoint newCenter = CGPointMake(
//                                    mainView.frame.origin.x + mainView.frame.size.width - SCALE_BUTTON_WIDTH * 0.5,
//                                    mainView.frame.origin.y + mainView.frame.size.height - SCALE_BUTTON_WIDTH * 0.5);
//    mainView.scaleView.frame = CGRectMake(newCenter.x, newCenter.y, SCALE_BUTTON_WIDTH, SCALE_BUTTON_WIDTH) ;
//    [panGesture setTranslation:CGPointZero inView:panGesture.view];
   
    [panGesture setTranslation:CGPointZero inView:panGesture.view];

}

-(void)panView:(UIPanGestureRecognizer *)panGesture{
    UIView* scaleView = (Sticker*)panGesture.view;
    CGPoint point = [panGesture translationInView:scaleView];
    Sticker* mainView = (Sticker*)scaleView.superview;
    CGPoint pointInMainView = [panGesture translationInView:mainView];
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        if(fabs(point.x) > fabs(point.y))
        {
            direction = 1;
        }
        else
        {
            direction = 2;
        }
    }
    
    
    if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        float scale;
        float scaleX = (CGRectGetWidth(self.frame) -  mainView.frame.origin.x) / originWidth;
        float scaleY = (CGRectGetHeight(self.frame) -  mainView.frame.origin.y) / originHeight;
        if(direction == 1)
        {
            if(mainView.frame.origin.x + originWidth + point.x > CGRectGetWidth(self.frame) ||
               (mainView.frame.origin.y + originHeight + point.y > CGRectGetHeight(self.frame)))
            {
                scale = MIN(scaleX, scaleY);
            }
            else
            {
                scale = (originWidth + point.x) / originWidth;
            }
            
        }
        else
        {
            if(mainView.frame.origin.x + originWidth + point.x > CGRectGetWidth(self.frame) ||
               (mainView.frame.origin.y + originHeight + point.y > CGRectGetHeight(self.frame)))
            {
                scale = MIN(scaleX, scaleY);
            }
            else
            {
                scale = (originHeight + point.y) / originHeight;
            }
        }
        
        float curScale = mainView.transform.a;
        if (curScale > 2)
        {
            if (scale < 1)
            {
                mainView.transform = CGAffineTransformScale(mainView.transform, scale, scale);
            }
        }
        else if (curScale < 1)
        {
            if (scale > 1)
            {
                mainView.transform = CGAffineTransformScale(mainView.transform, scale, scale);
            }
        }
        else
        {
            mainView.transform = CGAffineTransformScale(mainView.transform, scale, scale);
        }
        
        
//        if (CGRectGetMaxX(mainView.frame) > CGRectGetWidth(self.frame))
//        {
//            float width = CGRectGetWidth(self.frame) - mainView.frame.origin.x;
//            float scale = width / originWidth;
//            mainView.transform = CGAffineTransformScale(mainView.transform, scale, scale);
//        }
//
//        if (CGRectGetMaxY(mainView.frame) > CGRectGetHeight(self.frame))
//        {
//            float height = CGRectGetHeight(self.frame) - mainView.frame.origin.y;
//            float scale = height / originHeight;
//            mainView.transform = CGAffineTransformScale(mainView.transform, scale, scale);
//        }
    }
    
   

        
//    NSLog(@"%.2f--%.2f", CGRectGetMaxX(mainView.frame), CGRectGetMaxY(mainView.frame));
//    NSLog(@"%.2f--%.2f", CGRectGetMinX(mainView.frame), CGRectGetMinY(mainView.frame));
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        float scale = mainView.transform.a;
        NSLog(@"scale = %.3f", scale);
//        if (CGRectGetMaxX(mainView.frame) > CGRectGetWidth(self.frame))
//        {
//            float width = CGRectGetWidth(self.frame) - mainView.frame.origin.x;
//            float scale = width / originWidth;
//            mainView.transform = CGAffineTransformScale(mainView.transform, scale, scale);
//        }
//
//        if (CGRectGetMaxY(mainView.frame) > CGRectGetHeight(self.frame))
//        {
//            float height = CGRectGetHeight(self.frame) - mainView.frame.origin.y;
//            float scale = height / originHeight;
//            mainView.transform = CGAffineTransformScale(mainView.transform, scale, scale);
//        }
    }
    
    
    [mainView updateScaleView];
//    _scaleView.frame = CGRectMake(
//                                  mainView.frame.origin.x + mainView.frame.size.width - SCALE_BUTTON_WIDTH * 0.5,
//                                  mainView.frame.origin.y + mainView.frame.size.height - SCALE_BUTTON_WIDTH * 0.5,
//                                  SCALE_BUTTON_WIDTH, SCALE_BUTTON_WIDTH) ;
    originWidth = mainView.frame.size.width;
    originHeight = mainView.frame.size.height;
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
}

- (void)closeSticker:(UITapGestureRecognizer*)gesture
{
    UIView* closeView = (Sticker*)gesture.view;
    Sticker* mainView = (Sticker*)closeView.superview;
    [mainView removeFromSuperview];
    
    NSString* key = [NSString stringWithFormat:@"%ld", mainView.tag];
    [_stickerList removeObjectForKey:key];
    if (_delegate)
    {
        [_delegate StickerView:self onRemoveWithKey:mainView];
    }
}

- (void)editSticker:(UITapGestureRecognizer*)gesture
{
    UIView* closeView = (Sticker*)gesture.view;
    Sticker* mainView = (Sticker*)closeView.superview;
    if (_delegate)
    {
        [_delegate StickerView:self onClickEdit:mainView];
    }
//    [self.navigationController pushViewController:editText animated:YES];
}

#pragma mark - method
/*
 * 添加贴纸
 */
- (Sticker*)addSticker
{
    Sticker* sticker = [[Sticker alloc] initWithRect:CGRectMake(0, 0, 40, 60)];
    [self addSubview:sticker];
    tag++;
    sticker.tag = tag;
    [_stickerList setObject:sticker forKey:[NSString stringWithFormat:@"%ld", sticker.tag]];
    
    //平移缩放按钮
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [sticker.scaleView addGestureRecognizer:pan];
    
    //平移大view
    UIPanGestureRecognizer *panMove = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMoveView:)];
    [sticker addGestureRecognizer:panMove];
    
    //点击删除按钮
    UITapGestureRecognizer* tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSticker:)];
    [sticker.closeView addGestureRecognizer: tapToClose];
    
    //点击编辑按钮
    UITapGestureRecognizer* tapEdit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editSticker:)];
    [sticker.editView addGestureRecognizer: tapEdit];
    
    [self focusOnSticker:sticker];
    return sticker;
}

- (void)setStickerWithKey:(NSString*)key show:(BOOL)bShow
{
    UIView* view = [self viewWithTag:[key intValue]];
    [view setHidden:!bShow];
}

- (UIView*)getViewWithKey:(NSString*)key
{
    return [self viewWithTag:[key intValue]];
}

#pragma mark - 私有方法
- (void)focusOnSticker:(Sticker*)sticker
{
    for (id key in _stickerList)
    {
        Sticker* stickerTemp = [_stickerList objectForKey:key];
        if (stickerTemp == sticker) {
            [stickerTemp showTool:YES];
        }
        else
        {
            [stickerTemp showTool:NO];
        }
    }
}

#pragma mark - getter


@end
