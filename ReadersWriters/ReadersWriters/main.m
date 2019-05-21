//
//  main.m
//  ReadersWriters
//
//  Created by Anton Kovalchuk on 21/05/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

static int kWritersCount = 2;
static int kReadersCount = 5;

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        __block int readers = 0;
        dispatch_semaphore_t mutex = dispatch_semaphore_create(1);
        dispatch_semaphore_t roomEmpty = dispatch_semaphore_create(1);
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@1, nil];
        
        // writers
        for(int i = 0; i < kWritersCount; ++i)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_semaphore_wait(roomEmpty, DISPATCH_TIME_FOREVER);
                    // critical section
                    int randomNumber = arc4random_uniform(100);
                    [array addObject:[NSNumber numberWithInt:randomNumber]];
                    NSLog(@"writer added number=%d thread=%@", randomNumber, [NSThread currentThread]);
                dispatch_semaphore_signal(roomEmpty);
            });
        }
        
        // readers
        for(int i = 0; i < kReadersCount; ++i)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
                    readers += 1;
                    if(readers == 1)
                    {
                        dispatch_semaphore_wait(roomEmpty, DISPATCH_TIME_FOREVER);
                    }
                dispatch_semaphore_signal(mutex);
                
                // critical section
                NSLog(@"reader read number=%@ thread=%@", [array objectAtIndex:0], [NSThread currentThread]);

                dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
                    readers -= 1;
                    if(readers == 0)
                    {
                        dispatch_semaphore_signal(roomEmpty);
                    }
                dispatch_semaphore_signal(mutex);
            });
        }
        
        while(YES);
    }
    return 0;
}
