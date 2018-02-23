//
//  Model.h
//  KittiesCollection
//
//  Created by Vadim Temnogrudov on 23/02/2018.
//  Copyright © 2018 temrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipleItemsViewModify/MultipleItemsViewModifierProtocol.h>

@interface Model : NSObject

@property (nonatomic, weak) NSObject<MultipleItemsViewModifierProtocol> *viewModifier;

@property (nonatomic, readonly) NSInteger kittiesCount;
- (NSString *)kittyAtIndex:(NSInteger)index;

- (void)loadMoreKitties;

@end
