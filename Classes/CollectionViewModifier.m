//
//  CollectionViewModifier.m
//  AFNetworking
//
//  Created by Vadim Temnogrudov on 22/02/2018.
//

#import "CollectionViewModifier.h"


@implementation CollectionViewModifier
@synthesize delegate;

- (nullable instancetype)initWithCollectionView:(nullable UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
    }
    return self;
}

#pragma mark - MultipleItemsViewModifierProtocol

- (void)modifyAnimatedWithUpdateBlock:(nullable multipleItemsViewModifyBlock)updateBlock
                          deleteBlock:(nullable multipleItemsViewModifyBlock)deleteBlock
                          insertBlock:(nullable multipleItemsViewModifyBlock)insertBlock {
    if ([self.delegate respondsToSelector:@selector(modifier:willUpdateView:)]) {
        [self.delegate modifier:self willUpdateView:self.collectionView];
    }
    __weak __typeof__(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        NSArray<NSIndexPath *> *indexPaths = nil;
        if (updateBlock) {
            indexPaths = updateBlock();
            if (indexPaths) {
                [self.collectionView reloadItemsAtIndexPaths:indexPaths];
            }
        }
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
        __typeof__(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if ([strongSelf.delegate respondsToSelector:@selector(modifier:didUpdatedView:)]) {
            [strongSelf.delegate modifier:strongSelf didUpdatedView:strongSelf.collectionView];
        }
    }];
}

- (void)modifyNotAnimatedWithBlock:(void (^_Nullable)(void))modifyBlock {
    if ([self.delegate respondsToSelector:@selector(modifier:willUpdateView:)]) {
        [self.delegate modifier:self willUpdateView:self.collectionView];
    }
    if (modifyBlock) {
        modifyBlock();
    }
    [self.collectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(modifier:didUpdatedView:)]) {
        [self.delegate modifier:self didUpdatedView:self.collectionView];
    }
}

@end
