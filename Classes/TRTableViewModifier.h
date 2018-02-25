//
//  TRTableViewModifier.h
//  MultipleItemsViewModify
//
//  Created by Vadim Temnogrudov on 20/02/2018.
//
#import <Foundation/Foundation.h>
#import "TRMultipleItemsViewModifierProtocol.h"

@interface TRTableViewModifier : NSObject<TRMultipleItemsViewModifierProtocol>

@property (nullable, nonatomic, weak) UITableView *tableView;

- (nullable instancetype)initWithTableView:(nonnull UITableView *)tableView;

@end
