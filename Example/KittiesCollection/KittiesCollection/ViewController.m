//
//  ViewController.m
//  KittiesCollection
//
//  Created by Vadim Temnogrudov on 22/02/2018.
//  Copyright © 2018 temrov. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import <TableViewModifier.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, MultipleItemsViewModifierDelegate>

@property (weak, nonatomic) IBOutlet UITableView *kittiesTableView;
@property (strong, nonatomic) TableViewModifier *tableViewModifier;

@property (weak, nonatomic) IBOutlet UIView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *noContentLabel;

@property (strong, nonatomic) Model *model;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.model = [Model new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Kitties table view becomes a target for our tableViewModifier
    self.tableViewModifier = [[TableViewModifier alloc] initWithTableView:self.kittiesTableView];
    self.tableViewModifier.delegate = self;
    
    // model interacts with vith view modifier telling him what to do
    self.model.viewModifier = self.tableViewModifier;
    
    [self tryLoadMoreKittiesIdNeeded];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.kittiesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KittiesCell" forIndexPath:indexPath];
    NSString *kittyName = [self.model kittyAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"kitty '%@'", kittyName];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tryLoadMoreKittiesIdNeeded];
}

#pragma mark - MultipleItemsViewModifierDelegate

- (void)modifier:(nonnull NSObject<MultipleItemsViewModifierProtocol> *)modifier willUpdateView:(nullable UIView *)view {
    [self hideActivityIndicator];
}

- (void)modifier:(nonnull NSObject<MultipleItemsViewModifierProtocol> *)modifier didUpdatedView:(nullable UIView *)view {
    [UIView animateWithDuration:0.2 animations:^{
        self.noContentLabel.alpha = self.model.kittiesCount == 0 ? 1.0 : 0.0;
    }];
    // items are inserted and may be we have some space to display more of them
    [self tryLoadMoreKittiesIdNeeded];
}

#pragma mark - Actitvity indicator view

- (void)showActivityIndicator {
    [UIView animateWithDuration:0.2 animations:^{
        self.activityIndicatorView.alpha = 1.0;
    }];
}

- (void)hideActivityIndicator {
    [UIView animateWithDuration:0.2 animations:^{
        self.activityIndicatorView.alpha = 0.0;
    }];
}

#pragma mark - Others

- (void)tryLoadMoreKittiesIdNeeded {
    if ([self isNeedMoreKitties]) {
        if ([self.model loadMoreKitties]) {
            [self showActivityIndicator];
        }
    }
}

- (BOOL)isNeedMoreKitties {
    if (self.kittiesTableView.contentSize.height - self.kittiesTableView.contentOffset.y <= self.kittiesTableView.bounds.size.height + 200) {
        // we are close to the bottom of the table
        // so soon we want to see more kitties
        return YES;
    }
    return NO;
}

@end
