//
//  TRMultipleItemsViewModifierDelegate.h
//  MultipleItemsViewModify
//
//  Created by Vadim Temnogrudov on 20/02/2018.
//
#import <UIKit/UIKit.h>

@protocol TRMultipleItemsViewModifierProtocol;

@protocol TRMultipleItemsViewModifierDelegate

@optional
// called directly to modifications of view
- (void)modifier:(nonnull NSObject<TRMultipleItemsViewModifierProtocol> *)modifier willUpdateView:(nullable UIView *)view;

// called immediately after modification of view
- (void)modifier:(nonnull NSObject<TRMultipleItemsViewModifierProtocol> *)modifier didUpdatedView:(nullable UIView *)view;

@end
