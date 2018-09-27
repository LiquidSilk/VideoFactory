//
//  StickerViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/8/27.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "StickerViewController.h"
#import "StickerView.h"
#import "UIUitls.h"
#import "EditorMediaCell.h"
#import "LSCollectionViewHorizontalLayout.h"
#import "EditorTextViewController.h"
#import "LaterPeriodViewController.h"

//#define SCREENW [UIScreen mainScreen].bounds.size.width
//#define SCREENH [UIScreen mainScreen].bounds.size.height
//#define SCREEN_SCALE ([ UIScreen mainScreen ].bounds.size.width/320)
#define LWLRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface CollectionCell : UICollectionViewCell

@property(nonatomic, weak) UILabel *titleLabel;

@end

@implementation CollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel = titleLabel;
        [self.contentView addSubview:self.titleLabel];
        self.backgroundColor = LWLRandomColor;
    }
    return self;
}
@end

@interface CollectionCellWhite : CollectionCell

@end

@implementation CollectionCellWhite

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
@end



@interface StickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, StickerViewDelegate>

@property(nonatomic, strong) LSCollectionViewHorizontalLayout *layout;
@property(nonatomic, strong) NSArray* items;
@property(nonatomic, assign) NSUInteger pageCount;
@property(nonatomic, strong) StickerView* stickerView;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation StickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.userInteractionEnabled = YES;
    
//    [self.view addSubview:self.collectionView];
//    self.collectionView;
//    self.stickerView;
    
//    _stickerView = [[StickerView alloc] initWithFrame:CGRectMake(0, 0, 540, 960)];
//    _stickerView.backgroundColor  = [UIColor redColor];
//    [self.view addSubview:_stickerView];
//    [_stickerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view);
//        make.top.mas_equalTo(64);
//        make.height.mas_equalTo(240);
//        make.width.mas_equalTo(135);
//    }];
    
    [self.view addSubview:self.collectionView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    LaterPeriodViewController* vc = [self parentViewController];
    [vc setTabShow:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _pageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierCell = @"Cell";
    
    CollectionCell *cell = nil;
    if (indexPath.item > 12) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellWhite" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
        cell.titleLabel.text = [NSString stringWithFormat:@"第%ld个礼物", (long)indexPath.row];
    }
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Sticker* sticker = [_stickerView addSticker];
    if (_delegate) {
        [_delegate stickerViewController:self addSticker:sticker];
    }
}

#pragma mark - StickerViewDelegate
- (void)StickerView:(StickerView *)stickerView onRemoveWithKey:(Sticker*)sticker
{
    if (_delegate) {
        [_delegate stickerViewController:self removeSticker:sticker];
    }
}

- (void)StickerView:(StickerView *)stickerView onClickEdit:(Sticker *)sticker
{
    __weak typeof (self) weakSelf = self;
    EditorTextViewController* editText = [[EditorTextViewController alloc] initWithTextRect:CGRectMake(0, 0, 420, 40) fontSize:28 limit:17 defaultText:@"123123"];
    editText.onSavedBlock = ^(UIImageView* imageView, NSString* text)
    {
#pragma mark 文字生成
        
        
        
        //                [MediaUtil generateTransparentWithSize:CGSizeMake(366, 26) projName:@"1108/images" fileName:@"xxxx__xxx_xxx____.png" onFinish:^{
        //                    [_preview updateLottie];
        //                    [_preview addSubview:imageView withPath:@"zzzz.proj 2.mask.comp_004_ios" mediaType:1 text:text];
        //                    [_preview showPreviewAtTime:6.3];
        //                }];
        
//        [_preview.lottieView updateImageWithKey:@"image_0" image:imageView.image];
//        _preview.lottieView.animationProgress = 0;
//        [_preview.lottieView play];
//
//        //                [_preview addSubview:imageView withPath:@"comp_text_png" mediaType:2 text:@""];
//
//
//        EditorMediaCell * cell = (EditorMediaCell*)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];//即为要得到的cell
//        [cell setImage:imageView.image];
    };
    [self.navigationController pushViewController:editText animated:YES];
}

- (void)addSubviewTo:(UIView *)parentView
{
    [parentView addSubview:self.stickerView];
    [self.stickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(parentView);
        make.top.mas_equalTo(64);
//        make.size.mas_equalTo(0.25);
        make.height.mas_equalTo(240);
        make.width.mas_equalTo(135);
    }];
}

- (void)setStickerWithKey:(NSString *)key show:(BOOL)bShow
{
    [_stickerView setStickerWithKey:key show:bShow];
}

- (UIView*)getStickerWithKey:(NSString*)key
{
    return [_stickerView getViewWithKey:key];
}


#pragma mark - getter
- (UICollectionView*)collectionView
{
    if (!_collectionView)
    {
        _items = @[ @"a", @"b", @"c", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"b", @"c", ];
        _pageCount = ceil(_items.count / 4.0) * 4;
        
        LSCollectionViewHorizontalLayout *layout =[[LSCollectionViewHorizontalLayout alloc]init];
        layout.rowCount = 2;
        layout.itemCountPerRow = 4;
        float cellHeight = 100;
        float col = 4;
        float margin = 2;
        float cellWidth = (kScreenW - margin * col) / 4;
        layout.itemSize = CGSizeMake(cellWidth, 100);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        layout.headerReferenceSize = CGSizeMake(2, 2);
        layout.footerReferenceSize = CGSizeMake(2, 2);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 410, kScreenW, 202) collectionViewLayout:layout];
        _collectionView.userInteractionEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[CollectionCellWhite class] forCellWithReuseIdentifier:@"CellWhite"];
        [_collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    return _collectionView;
}

- (StickerView*)stickerView
{
    if (!_stickerView)
    {
        _stickerView = [[StickerView alloc] initWithFrame:CGRectMake(0, 0, 540, 960)];
        _stickerView.delegate = self;
        [self.view addSubview:_stickerView];
    }
    return _stickerView;
}

@end
