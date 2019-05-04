//
//  main.m
//  PreloadedTurstile
//
//  Created by Anton Kovalchuk on 04/05/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

static int kMaxThreadNumber = 3;

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        __block int count = 0;
        dispatch_semaphore_t mutex = dispatch_semaphore_create(1);
        dispatch_semaphore_t turstile = dispatch_semaphore_create(0);
        dispatch_semaphore_t turstile2 = dispatch_semaphore_create(0);
        
        for(int i = 0; i < kMaxThreadNumber; ++i)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                for(int j = 0; j < 3; ++j)
                {
                    // rendezvous
                    NSLog(@"rendezvous thread=%@", [NSThread currentThread]);
                    
                    dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
                    ++count;
                    if(count == kMaxThreadNumber)
                    {
                        for(int x = 0; x < kMaxThreadNumber; ++x)
                        {
                            dispatch_semaphore_signal(turstile);
                        }
                    }
                    dispatch_semaphore_signal(mutex);
                    
                    dispatch_semaphore_wait(turstile, DISPATCH_TIME_FOREVER);

                    // crititcal
                    NSLog(@"crititcal point thread=%@", [NSThread currentThread]);
                    
                    dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
                    --count;
                    if(count == 0)
                    {
                        for(int x = 0; x < kMaxThreadNumber; ++x)
                        {
                            dispatch_semaphore_signal(turstile2);
                        }
                    }
                    dispatch_semaphore_signal(mutex);
                    
                    dispatch_semaphore_wait(turstile2, DISPATCH_TIME_FOREVER);
                }
            });
        }
        
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
