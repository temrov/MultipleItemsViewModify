//
//  Model.m
//  KittiesCollection
//
//  Created by Vadim Temnogrudov on 23/02/2018.
//  Copyright © 2018 temrov. All rights reserved.
//

#import "Model.h"
#import "KittiesRetriever.h"

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
                                                   }];
    }];
}

@end
