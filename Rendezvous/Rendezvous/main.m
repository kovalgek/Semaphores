//
//  main.m
//  Rendezvous
//
//  Created by Anton Kovalchuk on 05.03.2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        dispatch_semaphore_t aArrived = dispatch_semaphore_create(0);
        dispatch_semaphore_t bArrived = dispatch_semaphore_create(0);

        // Thread A
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"a1");
            dispatch_semaphore_signal(aArrived);
            dispatch_semaphore_wait(bArrived, DISPATCH_TIME_FOREVER);
            NSLog(@"a2");
        });
        
        // Thread B
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"b1");
            dispatch_semaphore_signal(bArrived);
            dispatch_semaphore_wait(aArrived, DISPATCH_TIME_FOREVER);
            NSLog(@"b2");
        });
        
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
