//
//  TRMultipleItemsViewModifierProtocol.h
//  MultipleItemsViewModify
//
//  Created by Vadim Temnogrudov on 20/02/2018.
//
#import "TRMultipleItemsViewModifierDelegate.h"
#import "TRMoveItemInfo.h"

/**
 * Prototype of modification function.
 * Body of function used to perform model modifications.
 * Result of this function is array of items (their index paths)
 * that had been modified in this block and should been modified in view.
 */
typedef NSArray<NSIndexPath *> *_Nullable (^multipleItemsViewModifyBlock)(void);

/**
 * Prototype of modification completion function.
 */
typedef  void (^multipleItemsViewModifyCompletionBlock)(BOOL finished);

/**
 * Controller-side object that performs routine update/delete/insert
 * operations with multiple items views (like UITableView or UICollectionView).
 * Object allows performing safe modifications of view and model atomically
 * that prevents from inconsistency crashes.
 */
@protocol TRMultipleItemsViewModifierProtocol

@required
@property (nullable, nonatomic, weak) NSObject<TRMultipleItemsViewModifierDelegate> *delegate;

/**
 * Method performs animated model and view modifications atomically.
 * Modification order:
 * 1. existing items are updating
 * 2. exhausted items are deleting
 * 3. new items are inserting.
 */
- (void)modifyAnimatedWithUpdateBlock:(nullable multipleItemsViewModifyBlock)updateBlock
                          deleteBlock:(nullable multipleItemsViewModifyBlock)deleteBlock
                          insertBlock:(nullable multipleItemsViewModifyBlock)insertBlock
                      completionBlock:(nullable multipleItemsViewModifyCompletionBlock)completionBlock;


// Move cells in view
- (void)modifyAnimatedWithMoveBlock:(NSArray<TRMoveItemInfo *> *_Nullable(^_Nullable)(void))moveBlock
                    completionBlock:(nullable multipleItemsViewModifyCompletionBlock)completionBlock;

// Atomically view and model modifying without any animation
- (void)modifyNotAnimatedWithBlock:(void (^_Nullable)(void))modifyBlock
                   completionBlock:(nullable multipleItemsViewModifyCompletionBlock)completionBlock;

- (void)modifyAnimated:(BOOL)animated
           updateBlock:(nullable multipleItemsViewModifyBlock)updateBlock
           deleteBlock:(nullable multipleItemsViewModifyBlock)deleteBlock
           insertBlock:(nullable multipleItemsViewModifyBlock)insertBlock
       completionBlock:(nullable multipleItemsViewModifyCompletionBlock)completionBlock;

@end

