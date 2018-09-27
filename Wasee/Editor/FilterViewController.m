//
//  FilterViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/9/10.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "FilterViewController.h"
#import "UIUitls.h"
#import "Utils.h"
#import "LSCollectionViewHorizontalLayout.h"
#import "LaterPeriodViewController.h"


#define LWLRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface FilterCell : UICollectionViewCell

@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation FilterCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel = titleLabel;
        [self.contentView addSubview:self.titleLabel];
        
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.contentView);
        }];
        self.backgroundColor = LWLRandomColor;
        
        
    }
    return self;
}
@end

@interface FilterCellWhite : FilterCell

@end

@implementation FilterCellWhite

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
@end



@interface FilterViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) LSCollectionViewHorizontalLayout *layout;
@property(nonatomic, strong) NSArray* items;
@property(nonatomic, strong) NSMutableArray* images;
@property(nonatomic, assign) NSUInteger pageCount;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)createImage
{
    _images = [NSMutableArray arrayWithCapacity:20];
    for(NSArray* dict in _items)
    {
        NSString* filterName = dict[0];
        
        UIImage* imgLena = [UIImage imageNamed:@"lena"];
        NSData *data = UIImagePNGRepresentation(imgLena);
        CIImage *source = [CIImage imageWithData:data];
        
        if ([filterName isEqualToString:@""])
        {
            [_images addObject:imgLena];
        }
        else
        {
            CIFilter *filter = [CIFilter filterWithName:filterName];
            [filter setValue:source forKey:kCIInputImageKey];
            UIImage* output = [filter valueForKey:kCIOutputImageKey];
            
            CIContext *context = [CIContext contextWithOptions:nil];
            struct CGImage *cgImage = [context createCGImage:filter.outputImage fromRect:source.extent];
            
            UIImage *outputUIImage = [UIImage imageWithCGImage:cgImage];
            [_images addObject:outputUIImage];
        }
    }
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _pageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierCell = @"FilterCell";
    
    FilterCell *cell = nil;
    if (indexPath.item > _items.count - 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCellWhite" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
//        NSString* filterName = _items[indexPath.row][0];
//        cell.titleLabel.text = _items[indexPath.row][1];
//
//
//        UIImage* imgLena = [UIImage imageNamed:@"lena"];
//        NSData *data = UIImagePNGRepresentation(imgLena);
//        CIImage *source = [CIImage imageWithData:data];
//
//        CIFilter *filter = [CIFilter filterWithName:filterName];
//        [filter setValue:source forKey:kCIInputImageKey];
//        UIImage* output = [filter valueForKey:kCIOutputImageKey];
//
//        CIContext *context = [CIContext contextWithOptions:nil];
//        struct CGImage *cgImage = [context createCGImage:filter.outputImage fromRect:source.extent];
//
//        UIImage *outputUIImage = [UIImage imageWithCGImage:cgImage];
        
        [cell.imageView setImage:_images[indexPath.row]];
        
    }
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate)
    {
        NSLog(@"%@",_items[indexPath.row][1]);
        [_delegate filterViewController:self addFilter:_items[indexPath.row][0]];
    }
}

#pragma mark - getter
- (UICollectionView*)collectionView
{
    if (!_collectionView)
    {
        //CIPhotoEffectInstant 怀旧
        //CIPhotoEffectNoir 黑白
        //CIPhotoEffectTonal 色调
        //CIPhotoEffectTransfer 岁月
        //CIPhotoEffectMono 单色
        //CIPhotoEffectFade 褪色
        //CIPhotoEffectProcess 冲印
        //CIPhotoEffectChrome 烙黄
        //CIMotionBlur 动感
        //CIBoxBlur 羽化
        //CICrystallize 水晶
        //CIGloom 柔和
        //CIPixellate 马赛克
        //CISepiaTone 老照片
        //CIComicEffect 漫画
        _items = @[
                      @[@"", @"还原"],
                      @[@"CIPhotoEffectInstant", @"怀旧"],
                      @[@"CIPhotoEffectNoir", @"黑白"],
                      @[@"CIPhotoEffectTonal", @"色调"],
                      @[@"CIPhotoEffectTransfer", @"岁月"],
                      @[@"CIPhotoEffectMono", @"单色"],
                      @[@"CIPhotoEffectFade", @"褪色"],
                      @[@"CIPhotoEffectProcess", @"冲印"],
                      @[@"CIPhotoEffectChrome", @"烙黄"],
                      @[@"CIMotionBlur", @"动感"],
                      @[@"CIBoxBlur", @"羽化"],
                      @[@"CICrystallize", @"水晶"],
                      @[@"CIGloom", @"柔和"],
                      @[@"CIPixellate", @"马赛克"],
                      @[@"CISepiaTone", @"老照片"],
                      @[@"CIComicEffect", @"漫画"],
                   ];
        [self createImage];
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
        [_collectionView registerClass:[FilterCellWhite class] forCellWithReuseIdentifier:@"FilterCellWhite"];
        [_collectionView registerClass:[FilterCell class] forCellWithReuseIdentifier:@"FilterCell"];
    }
    return _collectionView;
}
@end
