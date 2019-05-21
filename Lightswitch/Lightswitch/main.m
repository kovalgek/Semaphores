//
//  main.m
//  Lightswitch
//
//  Created by Anton Kovalchuk on 21/05/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lightswitch.h"

static int kWritersCount = 2;
static int kReadersCount = 5;

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        Lightswitch *readLightswitch = [[Lightswitch alloc] init];
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
                
                [readLightswitch lock:roomEmpty];
                
                // critical section
                NSLog(@"reader read number=%@ thread=%@", [array objectAtIndex:0], [NSThread currentThread]);
                
                [readLightswitch unlock:roomEmpty];
            });
        }
        
        while(YES);
    }
    return 0;
}
