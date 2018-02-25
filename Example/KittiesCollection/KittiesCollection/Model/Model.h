//
//  Model.h
//  KittiesCollection
//
//  Created by Vadim Temnogrudov on 23/02/2018.
//  Copyright © 2018 temrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TRMultipleItemsViewModifierProtocol.h>

@interface Model : NSObject

@property (nonatomic, weak) NSObject<TRMultipleItemsViewModifierProtocol> *viewModifier;

@property (nonatomic, readonly) BOOL hasNext;

@property (nonatomic, readonly) NSInteger kittiesCount;
- (NSString *)kittyAtIndex:(NSInteger)index;

- (BOOL)loadMoreKitties;
- (void)shuffleKitties;
- (BOOL)reset;

@end
