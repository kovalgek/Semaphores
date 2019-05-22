//
//  Lightswitch.h
//  Lightswitch
//
//  Created by Anton Kovalchuk on 21/05/2019.
//  Copyright © 2019 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Lightswitch : NSObject

- (void)lock:(dispatch_semaphore_t)semaphore;
- (void)unlock:(dispatch_semaphore_t)semaphore;

@end

NS_ASSUME_NONNULL_END
