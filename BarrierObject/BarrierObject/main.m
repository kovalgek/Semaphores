//
//  main.m
//  BarrierObject
//
//  Created by Anton Kovalchuk on 01/04/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Barrier.h"

static int kMaxThreadNumber = 5;

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        Barrier *barrier = [[Barrier alloc] initWithThreadsCount:kMaxThreadNumber];
        
        for(int i = 0; i < kMaxThreadNumber; ++i)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                for(int j = 0; j < 3; ++j)
                {
                    [barrier wait];
                }
            });
        }
        
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
