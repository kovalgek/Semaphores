//
//  main.m
//  BarrierWithURLRequests
//
//  Created by Anton Kovalchuk on 16/03/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

static int kMaxRequestsNumber = 2;

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        config.URLCache = nil;
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        __block int count = 0;
        dispatch_semaphore_t mutex = dispatch_semaphore_create(1);
        dispatch_semaphore_t barrier = dispatch_semaphore_create(0);
        
        for(int i = 0; i < kMaxRequestsNumber; ++i)
        {
            NSLog(@"rensezvous task0 resume %@",[NSThread currentThread]);

            NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"http://google.com"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                NSLog(@"rensezvous task0 resume %@",[NSThread currentThread]);
                
                dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
                count = count + 1;
                dispatch_semaphore_signal(mutex);
                
                if(count == kMaxRequestsNumber)
                {
                    dispatch_semaphore_signal(barrier);
                }
                
                dispatch_semaphore_wait(barrier, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_signal(barrier);
                
                NSLog(@"critical_point task0 resume %@",[NSThread currentThread]);
            }];
            
            [dataTask resume];
        }
        
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
