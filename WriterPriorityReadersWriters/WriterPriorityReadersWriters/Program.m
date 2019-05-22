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
@property (nonatomic, strong) Lightswitch *writeSwitch;
@property (nonatomic, strong) dispatch_semaphore_t noReaders;
@property (nonatomic, strong) dispatch_semaphore_t noWriters;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation Program

- (instancetype)init
{
    self = [super init];
    
    _readSwitch = [[Lightswitch alloc] init];
    _writeSwitch = [[Lightswitch alloc] init];
    _noReaders = dispatch_semaphore_create(1);
    _noWriters = dispatch_semaphore_create(1);
    _array = [[NSMutableArray alloc] initWithObjects:@1, nil];
    
    return self;
}

- (void)run
{
    for(int i = 0; i < kReadersCount; ++i)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if(i == kReadersCount/2 ||
               i == kReadersCount/2 + 1)
            {
                [self runWriter];
            }
            else
            {
                [self runReader];
            }
        });
    }
}

- (void) runReader
{
    dispatch_semaphore_wait(self.noReaders, DISPATCH_TIME_FOREVER);
        [self.readSwitch lock:self.noWriters];
    dispatch_semaphore_signal(self.noReaders);

        // critical section
        NSLog(@"reader read number=%@ thread=%@", [self.array objectAtIndex:0], [NSThread currentThread]);
    
    [self.readSwitch unlock:self.noWriters];
}

- (void) runWriter
{
    [self.writeSwitch lock:self.noReaders];
        dispatch_semaphore_wait(self.noWriters, DISPATCH_TIME_FOREVER);
    
            // critical section
            int randomNumber = arc4random_uniform(100);
            [self.array addObject:[NSNumber numberWithInt:randomNumber]];
            NSLog(@"writer added number=%d thread=%@", randomNumber, [NSThread currentThread]);
    
        dispatch_semaphore_signal(self.noWriters);
    [self.writeSwitch unlock:self.noReaders];
}

@end
