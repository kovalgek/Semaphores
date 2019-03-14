//
//  main.m
//  LockTest
//
//  Created by Anton Kovalchuk on 03.03.2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pthread.h>

pthread_mutex_t mutex;

@interface MyObject : NSObject
- (void) threadA;
- (void) threadB;
@end

@implementation MyObject

- (instancetype)init
{
    self = [super init];
    
    pthread_mutex_init(&mutex, NULL);

    return self;
}

- (void) threadA
{
    NSLog(@"a1");
    pthread_mutex_lock(&mutex);
}

- (void)threadB
{
    pthread_mutex_unlock(&mutex);
    NSLog(@"b1");
}

@end

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        MyObject *obj = [[MyObject alloc] init];
        
        [NSThread detachNewThreadSelector:@selector(threadA) toTarget:obj withObject:nil];
        [NSThread detachNewThreadSelector:@selector(threadB) toTarget:obj withObject:nil];
    }
    return 0;
}
