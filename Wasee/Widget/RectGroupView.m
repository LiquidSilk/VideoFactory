//
//  RectGroupView.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/25.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "RectGroupView.h"

@interface RectGroupView()
{
    
}
@property(nonatomic, assign)CGSize originSize;
@property(nonatomic, strong)NSMutableDictionary* dictRect;
@end


@implementation RectGroupView

- (instancetype)initWithOriginSize:(CGSize)size
{
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _originSize = size;
        _dictRect = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

#pragma mark - method
- (void)addRectView:(RectView*)rectView name:(NSString *)name
{
    [self addSubview: rectView];
    [rectView updatePosition];
    
    [_dictRect setObject:rectView forKey:name];
}

- (void)addRectViewWithRect:(CGRect)rect name:(NSString*)name
{
    [self layoutIfNeeded];
    float ratio = self.frame.size.width / _originSize.width;
    RectView* rectView = [[RectView alloc] initWithFrame:rect ratio:ratio];
    [self addRectView:rectView name:name];
}

- (void)setFocus:(BOOL)bFocus withName:(NSString*)name
{
    RectView* rectView = [_dictRect objectForKey:name];
    if (rectView)
    {
        [rectView setFocus:bFocus];
    }
}

@end
