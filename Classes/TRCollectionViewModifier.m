//
//  TRCollectionViewModifier.m
//  MultipleItemsViewModify
//
//  Created by Vadim Temnogrudov on 22/02/2018.
//

#import "TRCollectionViewModifier.h"


@implementation TRCollectionViewModifier
@synthesize delegate;

- (nullable instancetype)initWithCollectionView:(nullable UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
    }
    return self;
}

#pragma mark - TRMultipleItemsViewModifierProtocol

- (void)modifyAnimatedWithUpdateBlock:(nullable multipleItemsViewModifyBlock)updateBlock
                          deleteBlock:(nullable multipleItemsViewModifyBlock)deleteBlock
                          insertBlock:(nullable multipleItemsViewModifyBlock)insertBlock
                      completionBlock:(nullable multipleItemsViewModifyCompletionBlock)completionBlock{
    if ([self.delegate respondsToSelector:@selector(modifier:willUpdateView:)]) {
        [self.delegate modifier:self willUpdateView:self.collectionView];
    }
    // retaining view to prevent from destroying it while animaiton is in flight
    UICollectionView *strongCollectionView = self.collectionView;
    __weak __typeof__(self) weakSelf = self;
    [UIView animateWithDuration:0 animations:^{
        [self.collectionView performBatchUpdates:^{
            NSArray<NSIndexPath *> *indexPaths = nil;
            if (updateBlock) {
                indexPaths = updateBlock();
                if (indexPaths) {
                    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
                }
            }
        } completion:nil];
    }];
    
    [self.collectionView performBatchUpdates:^{
        NSArray<NSIndexPath *> *indexPaths = nil;
        if (deleteBlock) {
            indexPaths = deleteBlock();
            if (indexPaths) {
                [self.collectionView deleteItemsAtIndexPaths:indexPaths];
            }
        }
        if (insertBlock) {
            indexPaths = insertBlock();
            if (indexPaths) {
                [self.collectionView insertItemsAtIndexPaths:indexPaths];
            }
        }
    } completion:^(BOOL finished) {
        strongCollectionView = nil;
        __typeof__(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if ([strongSelf.delegate respondsToSelector:@selector(modifier:didUpdatedView:)]) {
            [strongSelf.delegate modifier:strongSelf didUpdatedView:strongSelf.collectionView];
        }
        if (completionBlock) {
            completionBlock(finished);
        }
    }];
}

- (void)modifyAnimatedWithMoveBlock:(NSArray<TRMoveItemInfo *> *(^_Nullable)(void))moveBlock
                    completionBlock:(nullable multipleItemsViewModifyCompletionBlock)completionBlock{
    if ([self.delegate respondsToSelector:@selector(modifier:willUpdateView:)]) {
        [self.delegate modifier:self willUpdateView:self.collectionView];
    }
    __weak __typeof__(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        if (moveBlock) {
            NSArray<TRMoveItemInfo *> *moveItemsInfo = moveBlock();
            [moveItemsInfo enumerateObjectsUsingBlock:^(TRMoveItemInfo * _Nonnull moveItem, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.collectionView moveItemAtIndexPath:moveItem.fromIndex toIndexPath:moveItem.toIndex];
            }];
        }
    } completion:^(BOOL finished) {
        __typeof__(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if ([strongSelf.delegate respondsToSelector:@selector(modifier:didUpdatedView:)]) {
            [strongSelf.delegate modifier:strongSelf didUpdatedView:strongSelf.collectionView];
        }
        if (completionBlock) {
            completionBlock(finished);
        }
    }];
}



- (void)modifyNotAnimatedWithBlock:(void (^_Nullable)(void))modifyBlock
                   completionBlock:(nullable multipleItemsViewModifyCompletionBlock)completionBlock{
    if ([self.delegate respondsToSelector:@selector(modifier:willUpdateView:)]) {
        [self.delegate modifier:self willUpdateView:self.collectionView];
    }
    if (modifyBlock) {
        modifyBlock();
    }
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    
    if ([self.delegate respondsToSelector:@selector(modifier:didUpdatedView:)]) {
        [self.delegate modifier:self didUpdatedView:self.collectionView];
    }
    if (completionBlock) {
        completionBlock(YES);
    }
}

@end

