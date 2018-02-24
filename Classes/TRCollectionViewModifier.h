//
//  TRCollectionViewModifier.h
//  AFNetworking
//
//  Created by Vadim Temnogrudov on 22/02/2018.
//

#import <Foundation/Foundation.h>
#import "TRMultipleItemsViewModifierProtocol.h"

@interface TRCollectionViewModifier : NSObject<TRMultipleItemsViewModifierProtocol>

@property (nullable, nonatomic, weak) UICollectionView *collectionView;

- (nullable instancetype)initWithCollectionView:(nullable UICollectionView *)collectionView;

@end
