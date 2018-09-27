//
//  SliderRangeView.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/29.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "SliderRangeSelectorView.h"

#define STICKER_WIDTH 36


@interface CenterView : UIView

@property(nonatomic, copy)NSString* key;


@end

@implementation CenterView
@end
//////////////////////////////////////////////////////////////////////////





@interface SliderRangeSelectorView()

@property(nonatomic, strong) NSMutableDictionary* leftList;
@property(nonatomic, strong) NSMutableDictionary* rightList;
@property(nonatomic, strong) NSMutableDictionary* centerViewList;
@property(nonatomic, assign) CGFloat lastOffset;
@property(nonatomic, assign) CGFloat curOffset;
@end


@implementation SliderRangeSelectorView


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _leftList = [NSMutableDictionary dictionaryWithCapacity:5];
        _rightList = [NSMutableDictionary dictionaryWithCapacity:5];
        _centerViewList = [NSMutableDictionary dictionaryWithCapacity:5];
//        [self addSelector:@"1"];
//        [self addSelector:@"3"];
    }
    
    return self;
}

- (void)updatePosition:(NSString*)key
{
    LSSlider* left = (LSSlider*)[_leftList objectForKey:key];
    LSSlider* right = (LSSlider*)[_rightList objectForKey:key];
    CenterView* center = (CenterView*)[_centerViewList objectForKey:key];
    
    left.center = CGPointMake(left.centerPosition, left.frame.size.height/2);
    
    right.center = CGPointMake(right.centerPosition, right.frame.size.height/2);
    
    center.frame = CGRectMake(CGRectGetMidX(left.frame), center.frame.origin.y, CGRectGetMidX(right.frame) - CGRectGetMidX(left.frame), center.frame.size.height);
    
    [self delegateProc];
}

- (void)addSelector:(NSString*)key
{
    CenterView* centerView = [[CenterView alloc] initWithFrame:CGRectMake(0, 0, 40, 70)];
    centerView.key = key;
    centerView.backgroundColor = [UIColor redColor];
    centerView.alpha = 0.4;
    [self addSubview:centerView];
    UIPanGestureRecognizer *centerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCenterPan:)];
    [centerView addGestureRecognizer:centerPan];
    [_centerViewList setObject:centerView forKey:key];
    UITapGestureRecognizer *centerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [centerView addGestureRecognizer:centerTap];
    
    
    LSSlider* left = [[LSSlider alloc] initWithFrame:CGRectMake(STICKER_WIDTH / 2, 0, STICKER_WIDTH, 70)];
    left.key = key;
    left.centerPosition = STICKER_WIDTH / 2;
    left.contentMode = UIViewContentModeLeft;
    left.userInteractionEnabled = YES;
    left.clipsToBounds = YES;
    left.backgroundColor = [UIColor clearColor];
    left.layer.borderWidth = 0;
    [self addSubview:left];
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
    [left addGestureRecognizer:leftPan];
    [_leftList setObject:left forKey:key];
    
    LSSlider* right = [[LSSlider alloc] initWithFrame:CGRectMake(STICKER_WIDTH / 2 + 40, 0, STICKER_WIDTH, 70)];
    right.key = key;
    right.centerPosition = STICKER_WIDTH / 2 + 40;
    right.contentMode = UIViewContentModeLeft;
    right.userInteractionEnabled = YES;
    right.clipsToBounds = YES;
    right.backgroundColor = [UIColor clearColor];
    right.layer.borderWidth = 0;
    [self addSubview:right];
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
    [right addGestureRecognizer:rightPan];
    [_rightList setObject:right forKey:key];
    
    
    [self updatePosition:key];
}

- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture
{
    //    if(fabs(_maxGap - _minGap) < 0.001)
    //    {
    //        [self handleCenterPan:gesture];
    //        return;
    //    }
    LSSlider* leftThumb = (LSSlider*)gesture.view;
    NSString* key = leftThumb.key;
    LSSlider* rightThumb = (LSSlider*)[_rightList objectForKey:key];
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:self];
        
        leftThumb.centerPosition += translation.x;
        if (leftThumb.centerPosition < STICKER_WIDTH / 2) {
            leftThumb.centerPosition = STICKER_WIDTH / 2;
        }
        
        float maxGap = 0;
        float minGap = 0;
        if (
            (rightThumb.centerPosition - leftThumb.centerPosition <= STICKER_WIDTH) ||
            ((maxGap > 0) && (rightThumb.centerPosition - leftThumb.centerPosition > maxGap)) ||
            ((minGap > 0) && (rightThumb.centerPosition - leftThumb.centerPosition < minGap))
            
            )
        {
            leftThumb.centerPosition -= translation.x;
        }
        
        [gesture setTranslation:CGPointZero inView:self];
        
        [self setNeedsLayout];
        [self updatePosition:key];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self focusOnKey:key];
    }
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture
{
    //    if(fabs(_maxGap - _minGap) < 0.001)
    //    {
    //        [self handleCenterPan:gesture];
    //        return;
    //    }
    
    LSSlider* rightThumb = (LSSlider*)gesture.view;
    NSString* key = rightThumb.key;
    LSSlider* leftThumb = (LSSlider*)[_leftList objectForKey:key];
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        
        
        CGPoint translation = [gesture translationInView:self];
        rightThumb.centerPosition += translation.x;
        if (rightThumb.centerPosition < 0) {
            rightThumb.centerPosition = 0;
        }
        
        if (rightThumb.centerPosition + STICKER_WIDTH / 2 > self.frame.size.width){
            rightThumb.centerPosition = self.frame.size.width - STICKER_WIDTH / 2;
        }
        
        if (rightThumb.centerPosition-leftThumb.centerPosition <= STICKER_WIDTH){
            rightThumb.centerPosition -= translation.x;
        }
        
        float maxGap = 0;
        float minGap = 0;
        if ((rightThumb.centerPosition -leftThumb.centerPosition <= STICKER_WIDTH) ||
            ((maxGap > 0) && (rightThumb.centerPosition - leftThumb.centerPosition > maxGap)) ||
            ((minGap > 0) && (rightThumb.centerPosition - leftThumb.centerPosition < minGap))){
            rightThumb.centerPosition -= translation.x;
        }
        
        
        [gesture setTranslation:CGPointZero inView:self];
        
        [self setNeedsLayout];
        [self updatePosition:key];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self focusOnKey:key];
    }
}

- (void)handleCenterPan:(UIPanGestureRecognizer *)gesture
{
    
    CenterView* centerView = (CenterView*)gesture.view;
    NSString* key = centerView.key;
    LSSlider* left = (LSSlider*)[_leftList objectForKey:key];
    LSSlider* right = (LSSlider*)[_rightList objectForKey:key];
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:self];
        
        left.centerPosition += translation.x;
        right.centerPosition += translation.x;
        
        if (right.centerPosition + STICKER_WIDTH / 2 > self.frame.size.width || left.centerPosition < STICKER_WIDTH / 2){
            left.centerPosition -= translation.x;
            right.centerPosition -= translation.x;
        }
        
        
        [gesture setTranslation:CGPointZero inView:self];
        
        [self setNeedsLayout];
        [self updatePosition:key];
    }
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self focusOnKey:key];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    CenterView* centerView = (CenterView*)gesture.view;
    NSString* key = centerView.key;
    [self focusOnKey:key];
}

- (NSMutableDictionary*)getRangeMap
{
    NSMutableDictionary* map = [NSMutableDictionary dictionaryWithCapacity:[_leftList count]];
    for(id key in _leftList)
    {
        LSSlider* left = [_leftList objectForKey:key];
        LSSlider* right = [_rightList objectForKey:key];

        float percentL = (left.centerPosition - STICKER_WIDTH * 0.5) / (self.frame.size.width - STICKER_WIDTH);
        float percentR = (right.centerPosition - STICKER_WIDTH * 0.5) / (self.frame.size.width - STICKER_WIDTH);
        
        NSArray* item = [NSArray arrayWithObjects:
                         [NSNumber numberWithFloat:percentL],
                         [NSNumber numberWithFloat:percentR], nil];
        [map setObject:item forKey:key];
    }
    return map;
}

- (void)progressProc:(CGFloat)offset
{
    _curOffset = offset;

    [self delegateProc];

    _lastOffset = offset;
}

- (void)removeSelectorWithKey:(NSString*)key
{
    LSSlider* left = [_leftList objectForKey:key];
    LSSlider* right = [_rightList objectForKey:key];
    CenterView* centerView = (CenterView*)[_centerViewList objectForKey:key];
    if (left && right && centerView)
    {
        [centerView removeFromSuperview];
        [left removeFromSuperview];
        [right removeFromSuperview];
        
        [_leftList removeObjectForKey:key];
        [_rightList removeObjectForKey:key];
        [_centerViewList removeObjectForKey:key];
    }
}

#pragma mark - 私有方法
- (void)focusOnKey:(NSString*)key
{
    CenterView* centerView = (CenterView*)[_centerViewList objectForKey:key];
    LSSlider* left = (LSSlider*)[_leftList objectForKey:key];
    LSSlider* right = (LSSlider*)[_rightList objectForKey:key];
    
    [centerView removeFromSuperview];
    [left removeFromSuperview];
    [right removeFromSuperview];
    NSInteger count = [[self subviews] count];
    [self insertSubview:centerView atIndex:count + 1];
    [self insertSubview:left atIndex:count + 1];
    [self insertSubview:right atIndex:count + 1];
}

- (void)delegateProc
{
    if (_delegate)
    {
        for(id key in _leftList)
        {
            LSSlider* left = [_leftList objectForKey:key];
            LSSlider* right = [_rightList objectForKey:key];
            if (_curOffset >= left.centerPosition && _curOffset <= right.centerPosition)
            {
                [_delegate SliderRangeSelectorView:self inRangeWithkey:key];
            }
            else
            {
                [_delegate SliderRangeSelectorView:self outRangeWithkey:key];
            }
        }
    }
}
@end
