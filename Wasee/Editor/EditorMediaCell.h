//
//  EditorMediaCell.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/9.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditorMediaCell : UICollectionViewCell


//0:图片模式 1:图片 2:文字
- (void)setType:(int)type;
- (void)setImage:(UIImage*)image;
- (void)setImageViewWithURL:(NSString *)url;
@end
