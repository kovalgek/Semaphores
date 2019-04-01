//
//  Barrier.m
//  BarrierObject
//
//  Created by Anton Kovalchuk on 01/04/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import "Barrier.h"

@interface Barrier()
@property (nonatomic, assign) NSUInteger threadsCount;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) dispatch_semaphore_t mutex;
@property (nonatomic, strong) dispatch_semaphore_t turnstile;
@property (nonatomic, strong) dispatch_semaphore_t turnstile2;
@end

@implementation Barrier

- (instancetype)initWithThreadsCount:(NSUInteger)threadsCount
{
    self = [super init];
    _threadsCount = threadsCount;
    _count = 0;
    self.mutex = dispatch_semaphore_create(1);
    self.turnstile = dispatch_semaphore_create(0);
    self.turnstile2 = dispatch_semaphore_create(0);
    return self;
}

- (void) phase1
{
    dispatch_semaphore_wait(self.mutex, DISPATCH_TIME_FOREVER);
        ++self.count;
        if(self.count == self.threadsCount)
        {
            for(int i = 0; i < self.threadsCount; ++i)
            {
                dispatch_semaphore_signal(self.turnstile);
            }
        }
    dispatch_semaphore_signal(self.mutex);
    
    dispatch_semaphore_wait(self.turnstile, DISPATCH_TIME_FOREVER);
}

- (void) phase2
{
    dispatch_semaphore_wait(self.mutex, DISPATCH_TIME_FOREVER);
        --self.count;
        if(self.count == 0)
        {
            for(int i = 0; i < self.threadsCount; ++i)
            {
                dispatch_semaphore_signal(self.turnstile2);
            }
        }
    dispatch_semaphore_signal(self.mutex);
    
    dispatch_semaphore_wait(self.turnstile2, DISPATCH_TIME_FOREVER);
}

- (void)wait
{
    NSLog(@"rendezvous %@",[NSThread currentThread]);
    [self phase1];
    NSLog(@"crititcal %@",[NSThread currentThread]);
    [self phase2];
}


@end
