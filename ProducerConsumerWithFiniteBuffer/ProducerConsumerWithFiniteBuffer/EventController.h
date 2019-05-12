//
//  EventController.h
//  ProducerConsumer
//
//  Created by Anton Kovalchuk on 04/05/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;

NS_ASSUME_NONNULL_BEGIN

@interface EventController : NSObject
- (Event *)waitForEvent;
@end

NS_ASSUME_NONNULL_END
