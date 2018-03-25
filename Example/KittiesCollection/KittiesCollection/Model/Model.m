//
//  Model.m
//  KittiesCollection
//
//  Created by Vadim Temnogrudov on 23/02/2018.
//  Copyright © 2018 temrov. All rights reserved.
//

#import "Model.h"
#import "KittiesRetriever.h"
#include <stdlib.h>
@interface Model()

// basic array that we should display
@property (nonatomic, strong) NSMutableArray<NSString *> *kitties;

// this guy gets some kitties for us
@property (nonatomic, strong) KittiesRetriever *retriever;

@end

@implementation Model

- (instancetype)init {
    self = [super init];
    if (self) {
        self.kitties = [NSMutableArray new];
        self.retriever = [KittiesRetriever new];
    }
    return self;
}

- (BOOL)hasNext {
    return self.retriever.hasNext;
}

- (NSInteger)kittiesCount {
    return self.kitties.count;
}

- (NSString *)kittyAtIndex:(NSInteger)index {
    return self.kitties[index];
}

- (BOOL)loadMoreKitties {
    __weak __typeof__(self) weakSelf = self;
    return [self.retriever retrieveWithCompletion:^(NSArray<NSString *> *kitties) {
        __typeof__(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf.viewModifier modifyAnimatedWithUpdateBlock:nil
                                                   deleteBlock:nil
                                                   insertBlock:^NSArray<NSIndexPath *> * _Nonnull{
                                                       // just inserting new items
                                                       NSMutableArray *indexPaths = [NSMutableArray new];
                                                       [kitties enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                           [indexPaths addObject:[NSIndexPath indexPathForRow:strongSelf.kitties.count inSection:0]];
                                                           [strongSelf.kitties addObject:obj];
                                                       }];
                                                       // we inserted some items into out array
                                                       // and now we should update view for synchronizing
                                                       return indexPaths;
                                                   } completionBlock:nil];
    }];
}

- (void)shuffleKitties {

    __weak __typeof__(self) weakSelf = self;
    [self.viewModifier modifyAnimatedWithMoveBlock:^NSArray<TRMoveItemInfo *> *{
        __typeof__(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return nil;
        }
        NSMutableArray<TRMoveItemInfo *> *moveItems = [strongSelf indexesToMove];
        [moveItems enumerateObjectsUsingBlock:^(TRMoveItemInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [strongSelf.kitties exchangeObjectAtIndex:obj.fromIndex.row withObjectAtIndex:obj.toIndex.row];
        }];
        return moveItems;
    } completionBlock:nil];
}

- (void)reset {
    __weak __typeof__(self) weakSelf = self;
    [self.viewModifier modifyNotAnimatedWithBlock:^{
        __typeof__(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf.retriever reset];
        [strongSelf.kitties removeAllObjects];
    } completionBlock:nil];
}

#pragma mark - Shuffle helper

- (NSMutableArray<TRMoveItemInfo *> *)indexesToMove {
    NSMutableArray<TRMoveItemInfo *> *moveItems = [NSMutableArray new];
    [self.kitties enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TRMoveItemInfo *moveItemInfo = [TRMoveItemInfo new];
        moveItemInfo.fromIndex = [NSIndexPath indexPathForRow:idx inSection:0];
        NSUInteger toIndex = [self moveToIndexForMoveArray:moveItems];
        moveItemInfo.toIndex = [NSIndexPath indexPathForRow:toIndex inSection:0];
        [moveItems addObject:moveItemInfo];
    }];
    return moveItems;
}

- (NSUInteger)moveToIndexForMoveArray:(NSMutableArray<TRMoveItemInfo *> *)moveItems {
    NSUInteger targetIndex = arc4random_uniform((int)self.kitties.count);
    return [self findNextEmptySlotForItemIndex:targetIndex inMoveArray:moveItems];
}

- (NSUInteger)findNextEmptySlotForItemIndex:(NSUInteger)index inMoveArray:(NSMutableArray<TRMoveItemInfo *> *)moveItems {
    __block BOOL isEmptySlot = YES;
    [moveItems enumerateObjectsUsingBlock:^(TRMoveItemInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.toIndex.row == index) {
            isEmptySlot = NO;
            *stop = YES;
        }
    }];
    if (isEmptySlot) {
        // to Index is free now
        return index;
    }
    // recursive search for 'to' position
    NSUInteger nextIndexToCheck = (index + 1) % self.kitties.count;
    return [self findNextEmptySlotForItemIndex:nextIndexToCheck inMoveArray:moveItems];
}

@end
