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

@property (nonatomic, strong) NSMutableArray<NSString *> *kitties;
@property (nonatomic, strong) KittiesRetriever *retriever;

@end

@implementation Model

- (NSInteger)kittiesCount {
    return self.kitties.count;
}

- (NSString *)kittyAtIndex:(NSInteger)index {
    return self.kitties[index];
}

- (void)loadMoreKitties {
    __weak __typeof__(self) weakSelf = self;
    [self.retriever retrieveWithCompletion:^(NSArray<NSString *> *kitties) {
        __typeof__(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
//        [strongSelf.viewModifier modifyAnimatedWithUpdateBlock:nil
//                                                   deleteBlock:nil
//                                                   insertBlock:^NSArray<NSIndexPath *> * _Nonnull{
//                                                       NSMutableArray *indexPaths = [NSMutableArray new];
//                                                       [kitties enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                                           [indexPaths addObject:[NSIndexPath indexPathForRow:strongSelf.kitties.count inSection:0]];
//                                                           [strongSelf.kitties addObject:obj];
//                                                       }];
//                                                       return indexPaths;
//                                                   }];
    }];
}

@end
