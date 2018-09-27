//
//  UIScrollView+ZFPlayer.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIScrollView+ZFPlayer.h"
#import <objc/runtime.h>
#import "ZFReachabilityManager.h"
#import "ZFPlayer.h"
#import "ZFKVOController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

UIKIT_STATIC_INLINE void Hook_Method(Class originalClass, SEL originalSel, Class replacedClass, SEL replacedSel, SEL noneSel){
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    Method replacedMethod = class_getInstanceMethod(replacedClass, replacedSel);
    if (!originalMethod) {
        Method noneMethod = class_getInstanceMethod(replacedClass, noneSel);
        class_addMethod(originalClass, originalSel, method_getImplementation(noneMethod), method_getTypeEncoding(noneMethod));
        return;
    }
    BOOL addMethod = class_addMethod(originalClass, replacedSel, method_getImplementation(replacedMethod), method_getTypeEncoding(replacedMethod));
    if (addMethod) {
        /// 如果父类实现，但是当前类未实就崩溃。以下两行的代码是把当前类加进去这个方法，并取到当前类的originalMethod。
        /// The following two lines of code add the current class to the method and take it to the originalMethod of the current class if the superclass implements it, but the current class fails to implement it.
        class_addMethod(originalClass, originalSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
        Method newMethod = class_getInstanceMethod(originalClass, replacedSel);
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

@interface UIScrollView ()

@property (nonatomic, assign) CGFloat zf_lastOffsetY;

@end

@implementation UIScrollView (ZFPlayer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(setDelegate:)
        };
        for (NSInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"zf_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            Method originalMethod = class_getInstanceMethod(self, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    });
}

- (void)zf_setDelegate:(id<UIScrollViewDelegate>)delegate {
    if (([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) && [delegate conformsToProtocol:@protocol(UIScrollViewDelegate)]) {
        SEL originalSelectors[] = {
            @selector(scrollViewDidEndDecelerating:),
            @selector(scrollViewDidEndDragging:willDecelerate:),
            @selector(scrollViewDidScrollToTop:),
            @selector(scrollViewWillBeginDragging:),
            @selector(scrollViewDidScroll:)
        };
        
        SEL replacedSelectors[] = {
            @selector(zf_scrollViewDidEndDecelerating:),
            @selector(zf_scrollViewDidEndDragging:willDecelerate:),
            @selector(zf_scrollViewDidScrollToTop:),
            @selector(zf_scrollViewWillBeginDragging:),
            @selector(zf_scrollViewDidScroll:)
        };
        
        SEL noneSelectors[] = {
            @selector(add_scrollViewDidEndDecelerating:),
            @selector(add_scrollViewDidEndDragging:willDecelerate:),
            @selector(add_scrollViewDidScrollToTop:),
            @selector(add_scrollViewWillBeginDragging:),
            @selector(add_scrollViewDidScroll:)
        };
        
        for (NSInteger index = 0; index < sizeof(originalSelectors) / sizeof(SEL); ++index) {
            Hook_Method([delegate class], originalSelectors[index], [self class], replacedSelectors[index], noneSelectors[index]);
        }
    }
    [self zf_setDelegate:delegate];
}

#pragma mark - Replace_Method

- (void)zf_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView add_scrollViewDidEndDecelerating:scrollView];
    [self zf_scrollViewDidEndDecelerating:scrollView];
}

- (void)zf_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView add_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    [self zf_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)zf_scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView add_scrollViewDidScrollToTop:scrollView];
    [self zf_scrollViewDidScrollToTop:scrollView];
}

- (void)zf_scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView add_scrollViewDidScroll:scrollView];
    [self zf_scrollViewDidScroll:scrollView];
}

- (void)zf_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView add_scrollViewWillBeginDragging:scrollView];
    [self zf_scrollViewWillBeginDragging:scrollView];
}

#pragma mark - Add_Method

- (void)add_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [scrollView zf_scrollViewDidStopScroll];
    }
}

- (void)add_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [scrollView zf_scrollViewDidStopScroll];
        }
    }
}

- (void)add_scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidStopScroll];
}

- (void)add_scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView scrollViewScrolling];
}

- (void)add_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView scrollViewBeginDragging];
}

#pragma mark - scrollView did stop scroll

- (void)zf_scrollViewDidStopScroll {
    if (!self.zf_enableScrollHook) return;
    @weakify(self)
    [self zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (self.zf_scrollViewDidStopScrollCallback) self.zf_scrollViewDidStopScrollCallback(indexPath);
        if (self.scrollViewDidStopScroll) self.scrollViewDidStopScroll(indexPath);
    }];
}

- (void)scrollViewBeginDragging {
    if (!self.zf_enableScrollHook) return;
    self.zf_lastOffsetY = self.contentOffset.y;
}

- (void)scrollViewScrolling {
    if (!self.zf_enableScrollHook) return;
    CGFloat offsetY = self.contentOffset.y;
    self.zf_scrollDerection = (offsetY - self.zf_lastOffsetY > 0) ? ZFPlayerScrollDerectionUp : ZFPlayerScrollDerectionDown;
    self.zf_lastOffsetY = offsetY;
    
    // Avoid being paused the first time you play it.
    if (self.contentOffset.y < 0) return;
    if (self.zf_playingIndexPath) {
        UIView *cell = [self zf_getCellForIndexPath:self.zf_playingIndexPath];
        if (!cell) {
            if (self.zf_playerDidDisappearInScrollView) self.zf_playerDidDisappearInScrollView(self.zf_playingIndexPath);
            return;
        }
        UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
        CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
        CGRect rect = [self convertRect:rect1 toView:self.superview];
        CGFloat topSpacing = rect.origin.y - CGRectGetMinY(self.frame) - CGRectGetMinY(playerView.frame) - self.contentInset.bottom;
        CGFloat bottomSpacing = CGRectGetMaxY(self.frame) - CGRectGetMaxY(rect) + CGRectGetMinY(self.frame) + self.contentInset.top;
        
        if (self.zf_scrollDerection == ZFPlayerScrollDerectionUp) { /// Scroll up
            /// Top area
            if (topSpacing <= 0 && topSpacing > -CGRectGetHeight(rect)/2) {
                /// When the player will disappear.
                if (self.zf_playerWillDisappearInScrollView) self.zf_playerWillDisappearInScrollView(self.zf_playingIndexPath);
            } else if (topSpacing <= -CGRectGetHeight(rect)/2 && topSpacing > -CGRectGetHeight(rect)) {
                /// When the player did disappeared half.
                if (self.zf_playerDisappearHalfInScrollView) self.zf_playerDisappearHalfInScrollView(self.zf_playingIndexPath);
            } else if (topSpacing <= -CGRectGetHeight(rect)) {
                /// When the player did disappeared.
                if (self.zf_playerDidDisappearInScrollView) self.zf_playerDidDisappearInScrollView(self.zf_playingIndexPath);
            } else if (topSpacing > 0 && topSpacing < CGRectGetHeight(self.frame)) {
                /// In visable area
                /// When the player did appeared.
                if (self.zf_playerDidAppearInScrollView) self.zf_playerDidAppearInScrollView(self.zf_playingIndexPath);
            }
        } else if (self.zf_scrollDerection == ZFPlayerScrollDerectionDown) { /// Scroll Down
            /// Bottom area
            if (bottomSpacing <= 0 && bottomSpacing > -CGRectGetHeight(rect)/2) {
                /// When the player will disappear.
                if (self.zf_playerWillDisappearInScrollView) self.zf_playerWillDisappearInScrollView(self.zf_playingIndexPath);
            } else if (bottomSpacing <= -CGRectGetHeight(rect)/2 && bottomSpacing > -CGRectGetHeight(rect)) {
                /// When the player did disappeared half.
                if (self.zf_playerDisappearHalfInScrollView) self.zf_playerDisappearHalfInScrollView(self.zf_playingIndexPath);
            } else if (bottomSpacing <= -CGRectGetHeight(rect)) {
                /// When the player did disappeared.
                if (self.zf_playerDidDisappearInScrollView) self.zf_playerDidDisappearInScrollView(self.zf_playingIndexPath);
            } else if (bottomSpacing > 0 && bottomSpacing < CGRectGetHeight(self.frame)) {
                /// In visable area
                /// When the player did appeared.
                if (self.zf_playerDidAppearInScrollView) self.zf_playerDidAppearInScrollView(self.zf_playingIndexPath);
            }
        }
    }
}

- (void)zf_filterShouldPlayCellWhileScrolling:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.zf_shouldAutoPlay) return;
    if ([ZFReachabilityManager sharedManager].isReachableViaWWAN && !self.zf_WWANAutoPlay) return;
    NSArray *visiableCells = nil;
    NSIndexPath *indexPath = nil;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        visiableCells = [tableView visibleCells];
        // Top
        indexPath = tableView.indexPathsForVisibleRows.firstObject;
        if (self.contentOffset.y <= 0 && (!self.zf_playingIndexPath || [indexPath compare:self.zf_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.zf_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // Bottom
        indexPath = tableView.indexPathsForVisibleRows.lastObject;
        if (self.contentOffset.y + self.frame.size.height >= self.contentSize.height && (!self.zf_playingIndexPath || [indexPath compare:self.zf_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.zf_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        visiableCells = [collectionView visibleCells];
        NSArray *sortedIndexPaths = [collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        visiableCells = [visiableCells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *path1 = (NSIndexPath *)[collectionView indexPathForCell:obj1];
            NSIndexPath *path2 = (NSIndexPath *)[collectionView indexPathForCell:obj2];
            return [path1 compare:path2];
        }];
        
        // Top
        indexPath = sortedIndexPaths.firstObject;
        if (self.contentOffset.y <= 0 && (!self.zf_playingIndexPath || [indexPath compare:self.zf_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.zf_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // Bottom
        indexPath = collectionView.indexPathsForVisibleItems.lastObject;
        if (self.contentOffset.y + self.frame.size.height >= self.contentSize.height && (!self.zf_playingIndexPath || [indexPath compare:self.zf_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.zf_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    }
    
    NSArray *cellsArray = nil;
    if (self.zf_scrollDerection == ZFPlayerScrollDerectionUp) {
        cellsArray = visiableCells;
    } else {
        cellsArray = [visiableCells reverseObjectEnumerator].allObjects;
    }
    /// 中线
    CGFloat scrollViewMidY = (CGRectGetHeight(self.frame) - self.contentInset.top - self.contentInset.bottom)/2;
    /// 最终播放的indexPath
    __block NSIndexPath *finalIndexPath = nil;
    /// 最终距离中线的间距
    __block CGFloat finalSpace = 0;
    [cellsArray enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
        if (!playerView) return;
        CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
        CGRect rect = [self convertRect:rect1 toView:self.superview];
        CGFloat topSpacing = CGRectGetMinY(rect) - CGRectGetMinY(self.frame) - CGRectGetMinY(playerView.frame) - self.contentInset.bottom;
        CGFloat bottomSpacing = CGRectGetMaxY(self.frame) - CGRectGetMaxY(rect) + CGRectGetMinY(self.frame) + self.contentInset.top;
        CGFloat centerSpacing = ABS(scrollViewMidY - CGRectGetMidY(rect));
        NSIndexPath *indexPath = [self zf_getIndexPathForCell:cell];
        /// Play when the video playback section is visible.
        if ((topSpacing >= -CGRectGetHeight(rect)/2) && (bottomSpacing >= -CGRectGetHeight(rect)/2)) {
            /// 如果有正在播放的cell，直接停止遍历
            if (self.zf_playingIndexPath) {
                indexPath = self.zf_playingIndexPath;
                *stop = YES;
                return;
            }
            if (!finalIndexPath || centerSpacing < finalSpace) {
                finalIndexPath = indexPath;
                finalSpace = centerSpacing;
            }
        }
    }];
    /// 如果找到播放的indexPath
    if (finalIndexPath) {
        if (handler) handler(finalIndexPath);
        self.zf_shouldPlayIndexPath = finalIndexPath;
    }
}

- (void)zf_filterShouldPlayCellWhileScrolled:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.zf_shouldAutoPlay) return;
    if ([ZFReachabilityManager sharedManager].isReachableViaWWAN && !self.zf_WWANAutoPlay) return;
    @weakify(self)
    [self zf_filterShouldPlayCellWhileScrolling:^(NSIndexPath *indexPath) {
        @strongify(self)
        if ([ZFReachabilityManager sharedManager].isReachableViaWWAN) return;
        if (!self.zf_playingIndexPath) {
            if (handler) handler(indexPath);
            self.zf_playingIndexPath = indexPath;
        }
    }];
}

- (UIView *)zf_getCellForIndexPath:(NSIndexPath *)indexPath {
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        return cell;
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (NSIndexPath *)zf_getIndexPathForCell:(UIView *)cell {
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)cell];
        return indexPath;
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        NSIndexPath *indexPath = [collectionView indexPathForCell:(UICollectionViewCell *)cell];
        return indexPath;
    }
    return nil;
}

- (void)zf_scrollToRowAtIndexPath:(NSIndexPath *)indexPath completionHandler:(void (^ __nullable)(void))completionHandler {
    [UIView animateWithDuration:0.6 animations:^{
        if ([self isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self;
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } else if ([self isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)self;
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        }
    } completion:^(BOOL finished) {
        if (completionHandler) completionHandler();
    }];
}

#pragma mark - getter

- (BOOL)zf_enableScrollHook {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)zf_isPlaying {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (NSIndexPath *)zf_playingIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSIndexPath *)zf_shouldPlayIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSInteger)zf_containerViewTag {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (ZFPlayerScrollDerection)zf_scrollDerection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (BOOL)zf_stopWhileNotVisible {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)zf_isWWANAutoPlay {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)zf_shouldAutoPlay {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) return number.boolValue;
    self.zf_shouldAutoPlay = YES;
    return YES;
}

- (void (^)(NSIndexPath * _Nonnull))zf_playerDidAppearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))zf_playerWillDisappearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))zf_playerDisappearHalfInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))zf_playerDidDisappearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))zf_scrollViewDidStopScrollCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (CGFloat)zf_lastOffsetY {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

#pragma mark - setter

- (void)setZf_enableScrollHook:(BOOL)zf_enableScrollHook {
    objc_setAssociatedObject(self, @selector(zf_enableScrollHook), @(zf_enableScrollHook), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_playing:(BOOL)zf_playing {
    objc_setAssociatedObject(self, @selector(zf_isPlaying), @(zf_playing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_playingIndexPath:(NSIndexPath *)zf_playingIndexPath {
    objc_setAssociatedObject(self, @selector(zf_playingIndexPath), zf_playingIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_shouldPlayIndexPath:(NSIndexPath *)zf_shouldPlayIndexPath {
    objc_setAssociatedObject(self, @selector(zf_shouldPlayIndexPath), zf_shouldPlayIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.shouldPlayIndexPath = zf_shouldPlayIndexPath;
}

- (void)setZf_containerViewTag:(NSInteger)zf_containerViewTag {
    objc_setAssociatedObject(self, @selector(zf_containerViewTag), @(zf_containerViewTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_scrollDerection:(ZFPlayerScrollDerection)zf_scrollDerection {
    objc_setAssociatedObject(self, @selector(zf_scrollDerection), @(zf_scrollDerection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_stopWhileNotVisible:(BOOL)zf_stopWhileNotVisible {
    objc_setAssociatedObject(self, @selector(zf_stopWhileNotVisible), @(zf_stopWhileNotVisible), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_WWANAutoPlay:(BOOL)zf_WWANAutoPlay {
    objc_setAssociatedObject(self, @selector(zf_isWWANAutoPlay), @(zf_WWANAutoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_shouldAutoPlay:(BOOL)zf_shouldAutoPlay {
    objc_setAssociatedObject(self, @selector(zf_shouldAutoPlay), @(zf_shouldAutoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_playerDidAppearInScrollView:(void (^)(NSIndexPath * _Nonnull))zf_playerDidAppearInScrollView {
    objc_setAssociatedObject(self, @selector(zf_playerDidAppearInScrollView), zf_playerDidAppearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setZf_playerWillDisappearInScrollView:(void (^)(NSIndexPath * _Nonnull))zf_playerWillDisappearInScrollView {
    objc_setAssociatedObject(self, @selector(zf_playerWillDisappearInScrollView), zf_playerWillDisappearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setZf_playerDisappearHalfInScrollView:(void (^)(NSIndexPath * _Nonnull))zf_playerDisappearHalfInScrollView {
    objc_setAssociatedObject(self, @selector(zf_playerDisappearHalfInScrollView), zf_playerDisappearHalfInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setZf_playerDidDisappearInScrollView:(void (^)(NSIndexPath * _Nonnull))zf_playerDidDisappearInScrollView {
    objc_setAssociatedObject(self, @selector(zf_playerDidDisappearInScrollView), zf_playerDidDisappearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setZf_scrollViewDidStopScrollCallback:(void (^)(NSIndexPath * _Nonnull))zf_scrollViewDidStopScrollCallback {
    objc_setAssociatedObject(self, @selector(zf_scrollViewDidStopScrollCallback), zf_scrollViewDidStopScrollCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setZf_lastOffsetY:(CGFloat)zf_lastOffsetY {
    objc_setAssociatedObject(self, @selector(zf_lastOffsetY), @(zf_lastOffsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIScrollView (ZFPlayerDeprecated)

#pragma mark - getter

- (NSIndexPath *)shouldPlayIndexPath {
     return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))scrollViewDidStopScroll {
     return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - setter

- (void)setShouldPlayIndexPath:(NSIndexPath *)shouldPlayIndexPath {
    objc_setAssociatedObject(self, @selector(shouldPlayIndexPath), shouldPlayIndexPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setScrollViewDidStopScroll:(void (^)(NSIndexPath * _Nonnull))scrollViewDidStopScroll {
    objc_setAssociatedObject(self, @selector(scrollViewDidStopScroll), scrollViewDidStopScroll, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

#pragma clang diagnostic pop
