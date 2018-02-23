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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *noContentLabel;

@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) TableViewModifier *tableViewModifier;

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
    self.tableViewModifier = [[TableViewModifier alloc] initWithTableView:self.kittiesTableView];
    self.tableViewModifier.delegate = self;
    self.model.viewModifier = self.tableViewModifier;
    
    [self.kittiesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self.activityIndicatorView startAnimating];
    [self.model loadMoreKitties];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.kittiesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    NSString *kittyName = [self.model kittyAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Kitty %@", kittyName];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self isNeedNext]) {
        [self.model loadMoreKitties];
    }
}

- (BOOL)isNeedNext {
    if (self.kittiesTableView.contentSize.height - self.kittiesTableView.contentOffset.y <= self.kittiesTableView.bounds.size.height + 200) {
        return YES;
    }
    return NO;
}

#pragma mark - MultipleItemsViewModifierDelegate

- (void)modifier:(nonnull NSObject<MultipleItemsViewModifierProtocol> *)modifier willUpdateView:(nullable UIView *)view {
    [self.activityIndicatorView stopAnimating];
}

- (void)modifier:(nonnull NSObject<MultipleItemsViewModifierProtocol> *)modifier didUpdatedView:(nullable UIView *)view {
    [UIView animateWithDuration:0.2 animations:^{
        self.noContentLabel.alpha = self.model.kittiesCount == 0 ? 1.0 : 0.0;
    }];
}

@end
