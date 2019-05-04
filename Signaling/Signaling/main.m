//
//  main.m
//  Signaling
//
//  Created by Anton Kovalchuk on 04.03.2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        dispatch_semaphore_t a1Done = dispatch_semaphore_create(0);

        // Thread A
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"a1 thread=%@", [NSThread currentThread]);
            dispatch_semaphore_signal(a1Done);
        });
        
        // Thread B
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_wait(a1Done, DISPATCH_TIME_FOREVER);
            NSLog(@"b1 thread=%@", [NSThread currentThread]);
        });
        
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
