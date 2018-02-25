//
//  KittiesRetriever.m
//  KittiesCollection
//
//  Created by Vadim Temnogrudov on 23/02/2018.
//  Copyright © 2018 temrov. All rights reserved.
//

#import "KittiesRetriever.h"

@interface KittiesRetriever()

@property (nonatomic) NSUInteger kittiesRetrieved;
@property (nonatomic) BOOL isRetrieving;

@end

@implementation KittiesRetriever

- (instancetype)init {
    self = [super init];
    if (self) {
        self.kittiesRetrieved = 0;
        self.isRetrieving = NO;
    }
    return self;

}
- (BOOL)retrieveWithCompletion:(void (^)(NSArray<NSString *> *kitties))completion {
    if (!self.hasNext) {
        return NO;
    }
    if (self.isRetrieving) {
        return NO;
    }
    self.isRetrieving = YES;
    __weak __typeof__(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __typeof__(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        strongSelf.isRetrieving = NO;
        NSMutableArray *kitties = [NSMutableArray new];
        for (NSUInteger i = strongSelf.kittiesRetrieved; i < strongSelf.kittiesRetrieved + 10; i++) {
            [kitties addObject:[NSString stringWithFormat:@"Kitty %lu", (unsigned long)i]];
        }
        strongSelf.kittiesRetrieved += kitties.count;
        if (completion) {
            completion(kitties);
        }
    });
    return YES;
}

- (BOOL)hasNext {
    return self.kittiesRetrieved < 50;
}

- (void)reset {
    if (self.hasNext) {
        return;
    }
    self.kittiesRetrieved = 0;
}

@end
