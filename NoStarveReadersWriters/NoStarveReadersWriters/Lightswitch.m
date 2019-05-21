//
//  Lightswitch.m
//  Lightswitch
//
//  Created by Anton Kovalchuk on 21/05/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import "Lightswitch.h"

@interface Lightswitch()
@property (nonatomic, assign) int counter;
@property (nonatomic, strong) dispatch_semaphore_t mutex;
@end

@implementation Lightswitch

- (instancetype)init
{
    self = [super init];
    
    _counter = 0;
    _mutex = dispatch_semaphore_create(1);
    
    return self;
}

- (void)lock:(dispatch_semaphore_t)semaphore
{
    dispatch_semaphore_wait(self.mutex, DISPATCH_TIME_FOREVER);
        self.counter += 1;
        if(self.counter == 1)
        {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    dispatch_semaphore_signal(self.mutex);
}

- (void)unlock:(dispatch_semaphore_t)semaphore
{
    dispatch_semaphore_wait(self.mutex, DISPATCH_TIME_FOREVER);
        self.counter -= 1;
        if(self.counter == 0)
        {
            dispatch_semaphore_signal(semaphore);
        }
    dispatch_semaphore_signal(self.mutex);
}

@end
