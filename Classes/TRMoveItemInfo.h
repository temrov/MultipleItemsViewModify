//
//  TRMoveItemInfo.h
//  MultipleItemsViewModify
//
//  Created by Vadim Temnogrudov on 25/02/2018.
//

#import <Foundation/Foundation.h>

@interface TRMoveItemInfo : NSObject

@property (nullable, nonatomic, strong) NSIndexPath *fromIndex;
@property (nullable, nonatomic, strong) NSIndexPath *toIndex;

@end
