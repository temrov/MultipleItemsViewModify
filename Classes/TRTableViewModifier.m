//
//  TRTableViewModifier.m
//  MultipleItemsViewModify
//
//  Created by Vadim Temnogrudov on 20/02/2018.
//

#import "TRTableViewModifier.h"

@implementation TRTableViewModifier
@synthesize delegate;

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
    }
    return self;
}

#pragma mark - TRMultipleItemsViewModifierProtocol

- (void)modifyAnimatedWithUpdateBlock:(nullable multipleItemsViewModifyBlock)updateBlock
                          deleteBlock:(nullable multipleItemsViewModifyBlock)deleteBlock
                          insertBlock:(nullable multipleItemsViewModifyBlock)insertBlock
                      completionBlock:(nullable multipleItemsViewModifyCompletionBlock)completionBlock{
    
    if ([self.delegate respondsToSelector:@selector(modifier:willUpdateView:)]) {
        [self.delegate modifier:self willUpdateView:self.tableView];
    }
    // retaining view to prevent from destroying it while animaiton is in flight
    __block UITableView *strongTableView = self.tableView;
    __weak __typeof__(self) weakSelf = self;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        strongTableView = nil;
        if ([weakSelf.delegate respondsToSelector:@selector(modifier:didUpdatedView:)]) {
            [weakSelf.delegate modifier:weakSelf didUpdatedView:weakSelf.tableView];
        }
        if (completionBlock) {
            completionBlock(YES);
        }
    }];
    
    [self.tableView beginUpdates];
    NSArray<NSIndexPath *> *indexPaths = nil;
    if (updateBlock) {
        indexPaths = updateBlock();
        if (indexPaths) {
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    if (deleteBlock) {
        indexPaths = deleteBlock();
        if (indexPaths) {
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    if (insertBlock) {
        indexPaths = insertBlock();
        if (indexPaths) {
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    [self.tableView endUpdates];
    
    [CATransaction commit];
}

- (void)modifyAnimatedWithMoveBlock:(NSArray<TRMoveItemInfo *> *(^_Nullable)(void))moveBlock
                    completionBlock:(nullable multipleItemsViewModifyCompletionBlock)completionBlock{
    
    if ([self.delegate respondsToSelector:@selector(modifier:willUpdateView:)]) {
        [self.delegate modifier:self willUpdateView:self.tableView];
    }
    // retaining view to prevent from destroying it while animaiton is in flight
    __block UITableView *strongTableView = self.tableView;
    __weak __typeof__(self) weakSelf = self;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        strongTableView = nil;
        if ([weakSelf.delegate respondsToSelector:@selector(modifier:didUpdatedView:)]) {
            [weakSelf.delegate modifier:weakSelf didUpdatedView:weakSelf.tableView];
        }
        if (completionBlock) {
            completionBlock(YES);
        }
    }];
    
    [self.tableView beginUpdates];
    
    if (moveBlock) {
        NSArray<TRMoveItemInfo *> *moveItemsInfo = moveBlock();
        [moveItemsInfo enumerateObjectsUsingBlock:^(TRMoveItemInfo * _Nonnull moveItem, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView moveRowAtIndexPath:moveItem.fromIndex toIndexPath:moveItem.toIndex];
        }];
    }
    
    [self.tableView endUpdates];
    
    [CATransaction commit];
}

- (void)modifyNotAnimatedWithBlock:(void (^_Nullable)(void))modifyBlock
                   completionBlock:(nullable multipleItemsViewModifyCompletionBlock)completionBlock{
    if ([self.delegate respondsToSelector:@selector(modifier:willUpdateView:)]) {
        [self.delegate modifier:self willUpdateView:self.tableView];
    }
    if (modifyBlock) {
        modifyBlock();
    }
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    if (completionBlock) {
        completionBlock(YES);
    }
    if ([self.delegate respondsToSelector:@selector(modifier:didUpdatedView:)]) {
        [self.delegate modifier:self didUpdatedView:self.tableView];
    }
}

@end
