//
//  main.m
//  Mutex
//
//  Created by Anton Kovalchuk on 05.03.2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        // Thread A
        __block int count = 0;
        dispatch_semaphore_t mutex = dispatch_semaphore_create(1);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
            count = count + 1;
            dispatch_semaphore_signal(mutex);
        });
        
        // Thread B
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
            count = count + 1;
            dispatch_semaphore_signal(mutex);
        });
        
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
