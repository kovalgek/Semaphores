//
//  main.m
//  ProducerConsumer
//
//  Created by Anton Kovalchuk on 04/05/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventController.h"
#import "Event.h"

static int producerThreadCount = 4;
static int consumerThreadCount = 10;

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        EventController *eventController = [[EventController alloc] init];
        NSMutableArray *buffer = [[NSMutableArray alloc] init];
        dispatch_semaphore_t mutex = dispatch_semaphore_create(1);
        dispatch_semaphore_t items = dispatch_semaphore_create(0);
        
        // Consumers
        for(int i = 0; i < consumerThreadCount; ++i)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
                dispatch_semaphore_wait(items, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
                Event *event = [buffer lastObject];
                NSLog(@"get=%@ thread=%@",event,[NSThread currentThread]);
                [buffer removeLastObject];
                dispatch_semaphore_signal(mutex);
                [event process];
            });
        }
        
        // Producer
        for(int i = 0; i < producerThreadCount; ++i)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                Event *event = [eventController waitForEvent];
                dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
                [buffer addObject:event];
                NSLog(@"put=%@ thread=%@",event,[NSThread currentThread]);
                dispatch_semaphore_signal(items);
                dispatch_semaphore_signal(mutex);
            });
        }
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
