//
//  ViewController.m
//  KittiesCollection
//
//  Created by Vadim Temnogrudov on 22/02/2018.
//  Copyright © 2018 temrov. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import <TRTableViewModifier.h>

static CGFloat const kAnimationTimeDefault = 0.2;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, TRMultipleItemsViewModifierDelegate>

@property (weak, nonatomic) IBOutlet UITableView *kittiesTableView;
@property (strong, nonatomic) TRTableViewModifier *tableViewModifier;

@property (weak, nonatomic) IBOutlet UIView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *noContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

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
    self.tableViewModifier = [[TRTableViewModifier alloc] initWithTableView:self.kittiesTableView];
    self.tableViewModifier.delegate = self;
    
    // model interacts with view modifier telling him what to do
    self.model.viewModifier = self.tableViewModifier;
    
    [self tryLoadMoreKittiesIfNeeded];
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
    [self tryLoadMoreKittiesIfNeeded];
}

#pragma mark - TRMultipleItemsViewModifierDelegate

- (void)modifier:(nonnull NSObject<TRMultipleItemsViewModifierProtocol> *)modifier willUpdateView:(nullable UIView *)view {
    [self hideActivityIndicator];
    [self setNoContentLabelVisible:NO];
}

- (void)modifier:(nonnull NSObject<TRMultipleItemsViewModifierProtocol> *)modifier didUpdatedView:(nullable UIView *)view {
    [self setNoContentLabelVisible:!self.model.kittiesCount];
    self.resetButton.enabled = !self.model.hasNext;
    // items are inserted and may be we have some space to display more of them
    [self tryLoadMoreKittiesIfNeeded];
}

#pragma mark - Actions

- (IBAction)resetDidTapped:(id)sender {
    [self.model reset];
}

- (IBAction)shuffleDidTapped:(id)sender {
    [self.model shuffleKitties];
}

#pragma mark - Actitvity indicator view

- (void)showActivityIndicator {
    [UIView animateWithDuration:kAnimationTimeDefault animations:^{
        self.activityIndicatorView.alpha = 1.0;
    }];
}

- (void)hideActivityIndicator {
    [UIView animateWithDuration:kAnimationTimeDefault animations:^{
        self.activityIndicatorView.alpha = 0.0;
    }];
}

- (void)setNoContentLabelVisible:(BOOL)visible {
    [UIView animateWithDuration:kAnimationTimeDefault animations:^{
        self.noContentLabel.alpha = visible ? 1.0 : 0.0;
    }];
}

#pragma mark - Others

- (void)tryLoadMoreKittiesIfNeeded {
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
