//
//  Program.m
//  NoStarveReadersWriters
//
//  Created by Anton Kovalchuk on 21/05/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import "Program.h"
#import "Lightswitch.h"

static int kReadersCount = 10;

@interface Program()
@property (nonatomic, strong) Lightswitch *readSwitch;
@property (nonatomic, strong) dispatch_semaphore_t roomEmpty;
@property (nonatomic, strong) dispatch_semaphore_t turnstile;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation Program

- (instancetype)init
{
    self = [super init];
    
    _readSwitch = [[Lightswitch alloc] init];
    _roomEmpty = dispatch_semaphore_create(1);
    _turnstile = dispatch_semaphore_create(1);
    _array = [[NSMutableArray alloc] initWithObjects:@1, nil];
    
    return self;
}

- (void)run
{
    for(int i = 0; i < kReadersCount; ++i)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self runReader];
            if(i == kReadersCount/2)
            {
                [self runWriter];
            }
        });
    }
}

- (void) runReader
{
    dispatch_semaphore_wait(self.turnstile, DISPATCH_TIME_FOREVER);
    dispatch_semaphore_signal(self.turnstile);
    
    [self.readSwitch lock:self.roomEmpty];
    
    // critical section
    NSLog(@"reader read number=%@ thread=%@", [self.array objectAtIndex:0], [NSThread currentThread]);
    
    [self.readSwitch unlock:self.roomEmpty];
}

- (void) runWriter
{
    dispatch_semaphore_wait(self.turnstile, DISPATCH_TIME_FOREVER);
    
    {
        dispatch_semaphore_wait(self.roomEmpty, DISPATCH_TIME_FOREVER);
        
        // critical section
        int randomNumber = arc4random_uniform(100);
        [self.array addObject:[NSNumber numberWithInt:randomNumber]];
        NSLog(@"writer added number=%d thread=%@", randomNumber, [NSThread currentThread]);
    }
    
    dispatch_semaphore_signal(self.turnstile);
    
    dispatch_semaphore_signal(self.roomEmpty);
}

@end
