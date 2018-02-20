//
//  TableViewModifier.h
//
//  Created by Vadim Temnogrudov on 20/02/2018.
//
#import "MultipleItemsViewModifierProtocol.h"
#import <Foundation/Foundation.h>

@interface TableViewModifier : NSObject<MultipleItemsViewModifierProtocol>

@property (nullable, nonatomic, weak) UITableView *tableView;

- (nullable instancetype)initWithTableView:(nonnull UITableView *)tableView;

@end
