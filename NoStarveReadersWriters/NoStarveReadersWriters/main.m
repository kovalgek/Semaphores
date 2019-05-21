//
//  main.m
//  NoStarveReadersWriters
//
//  Created by Anton Kovalchuk on 21/05/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Program.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        Program *program = [[Program alloc] init];
        [program run];

        while (YES);
    }
    return 0;
}

