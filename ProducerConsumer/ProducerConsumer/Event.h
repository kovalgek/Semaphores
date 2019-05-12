//
//  Event.h
//  ProducerConsumer
//
//  Created by Anton Kovalchuk on 04/05/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Event : NSObject
@property (nonatomic, assign) NSUInteger eventId;
- (void) process;
@end

NS_ASSUME_NONNULL_END
