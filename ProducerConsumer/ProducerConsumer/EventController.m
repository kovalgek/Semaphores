//
//  EventController.m
//  ProducerConsumer
//
//  Created by Anton Kovalchuk on 04/05/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import "EventController.h"
#import "Event.h"

@implementation EventController

- (Event *)waitForEvent
{
    return [[Event alloc] init];
}

@end
