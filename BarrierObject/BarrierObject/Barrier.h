//
//  Barrier.h
//  BarrierObject
//
//  Created by Anton Kovalchuk on 01/04/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Barrier : NSObject

- (instancetype)initWithThreadsCount:(NSUInteger)threadsCount NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void) wait;

@end

NS_ASSUME_NONNULL_END
