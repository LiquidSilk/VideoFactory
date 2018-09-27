//
//  FilterViewController.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/9/10.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

@optional
- (void)filterViewController:(FilterViewController*)vc addFilter:(NSString*)filterName;
@end


@interface FilterViewController : UIViewController

@property(nonatomic, weak)id<FilterViewControllerDelegate>delegate;

@end
