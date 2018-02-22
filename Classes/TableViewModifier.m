//
//  TableViewModifier.m
//
//  Created by Vadim Temnogrudov on 20/02/2018.
//

#import "TableViewModifier.h"

@implementation TableViewModifier
@synthesize delegate;

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
    }
    return self;
}

#pragma mark - MultipleItemsViewModifierProtocol

- (void)modifyAnimatedWithUpdateBlock:(nullable multipleItemsViewModifyBlock)updateBlock
                          deleteBlock:(nullable multipleItemsViewModifyBlock)deleteBlock
                          insertBlock:(nullable multipleItemsViewModifyBlock)insertBlock {
    
    if ([self.delegate respondsToSelector:@selector(modifier:willUpdateView:)]) {
        [self.delegate modifier:self willUpdateView:self.tableView];
    }
    __weak __typeof__(self) weakSelf = self;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if ([weakSelf.delegate respondsToSelector:@selector(modifier:didUpdatedView:)]) {
            [weakSelf.delegate modifier:weakSelf didUpdatedView:weakSelf.tableView];
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

- (void)modifyNotAnimatedWithBlock:(void (^_Nullable)(void))modifyBlock {
    if ([self.delegate respondsToSelector:@selector(modifier:willUpdateView:)]) {
        [self.delegate modifier:self willUpdateView:self.tableView];
    }
    if (modifyBlock) {
        modifyBlock();
    }
    [self.tableView reloadData];
    if ([self.delegate respondsToSelector:@selector(modifier:didUpdatedView:)]) {
        [self.delegate modifier:self didUpdatedView:self.tableView];
    }
}

@end
