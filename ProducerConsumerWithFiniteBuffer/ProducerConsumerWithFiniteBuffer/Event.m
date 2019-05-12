//
//  Event.m
//  ProducerConsumer
//
//  Created by Anton Kovalchuk on 04/05/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import "Event.h"

@implementation Event

- (void) process
{
    NSLog(@"process event=%@",self);
}

@end
