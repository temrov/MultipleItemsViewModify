//
//  KittiesRetriever.h
//  KittiesCollection
//
//  Created by Vadim Temnogrudov on 23/02/2018.
//  Copyright © 2018 temrov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KittiesRetriever : NSObject

@property (nonatomic, readonly) BOOL hasNext;

- (void)retrieveWithCompletion:(void (^)(NSArray<NSString *> *kitties))completion;

@end
