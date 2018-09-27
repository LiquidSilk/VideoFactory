//
//  LSCollectionViewHorizontalLayout.h
//  TestCollectionView
//
//  Created by 陈忠杰 on 18/08/27.

#import <UIKit/UIKit.h>

@interface LSCollectionViewHorizontalLayout : UICollectionViewFlowLayout
@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;
@property (strong, nonatomic) NSMutableArray *allAttributes;

@end
