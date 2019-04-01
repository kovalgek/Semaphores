//
//  main.m
//  ReusableBarrier
//
//  Created by Anton Kovalchuk on 20/03/2019.
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
        dispatch_semaphore_t turnstile = dispatch_semaphore_create(0);
        dispatch_semaphore_t turnstile2 = dispatch_semaphore_create(1);
        dispatch_semaphore_t mutex = dispatch_semaphore_create(1);
        
        for(int i = 0; i < kMaxThreadNumber; ++i)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                for(int j = 0; j < 3; ++j)
                {
                    
                    // rendezvous
                    NSLog(@"rendezvous thread=%@ subjob=%d", [NSThread currentThread], j);
                    
                    dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
                    count = count + 1;
                    if(count == kMaxThreadNumber)
                    {
                        dispatch_semaphore_wait(turnstile2, DISPATCH_TIME_FOREVER);
                        dispatch_semaphore_signal(turnstile);
                    }
                    dispatch_semaphore_signal(mutex);
                    
                    dispatch_semaphore_wait(turnstile, DISPATCH_TIME_FOREVER);
                    dispatch_semaphore_signal(turnstile);
                    
                    
                    // crititcal point
                    NSLog(@"crititcal point thread=%@ subjob=%d", [NSThread currentThread], j);
                    
                    
                    dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
                    count = count - 1;
                    if(count == 0)
                    {
                        dispatch_semaphore_wait(turnstile, DISPATCH_TIME_FOREVER);
                        dispatch_semaphore_signal(turnstile2);
                    }
                    dispatch_semaphore_signal(mutex);
                    
                    dispatch_semaphore_wait(turnstile2, DISPATCH_TIME_FOREVER);
                    dispatch_semaphore_signal(turnstile2);
                    
               
                    
                }
            });
        }
        
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
