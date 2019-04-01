//
//  main.m
//  Barrier
//
//  Created by Anton Kovalchuk on 16/03/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

static int kMaxThreadNumber = 3;

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        // kMaxThreadNumber - max number of threads
        // count - current thread
        // mutex - protects count
        // barrier - protects critical point
        
        __block int count = 0;
        dispatch_semaphore_t mutex = dispatch_semaphore_create(1);
        dispatch_semaphore_t barrier = dispatch_semaphore_create(0);
        
        for(int i = 0; i < kMaxThreadNumber; ++i)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                // rendezvous
                NSLog(@"rendezvous thread=%@", [NSThread currentThread]);
                
                dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
                count = count + 1;
                dispatch_semaphore_signal(mutex);
                
                if(count == kMaxThreadNumber)
                {
                    dispatch_semaphore_signal(barrier);
                }
                
                dispatch_semaphore_wait(barrier, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_signal(barrier);
                
                // crititcal point
                NSLog(@"crititcal point thread=%@", [NSThread currentThread]);
            });
        }
        
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
