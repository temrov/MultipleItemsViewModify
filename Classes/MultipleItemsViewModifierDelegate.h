//
//  MultipleItemsViewModifierDelegate.h
//
//  Created by Vadim Temnogrudov on 20/02/2018.
//

@protocol MultipleItemsViewModifierProtocol;

@protocol MultipleItemsViewModifierDelegate

@optional
// called directly to modifications of view
- (void)modifier:(nonnull NSObject<MultipleItemsViewModifierProtocol> *)modifier willUpdateView:(nullable UIView *)view;

// called immediately after modification of view
- (void)modifier:(nonnull NSObject<MultipleItemsViewModifierProtocol> *)modifier didUpdatedView:(nullable UIView *)view;

@end
