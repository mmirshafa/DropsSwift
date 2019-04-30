//
//  RACSignal+delayedRetry.m
//  df
//
//  Created by Hamidreza Vakilian on 1/20/1397 AP.
//  Copyright © 1397 Hamidreza Vakilian. All rights reserved.
//

#import "RACSignal+delayedRetry.h"

@implementation RACSignal (delayedRetry)

- (RACSignal *)delayedRetry:(NSTimeInterval)interval
{
    return [[self catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        return [[[RACSignal empty] delay:interval] concat:[RACSignal error:error]];
    }] retry];
}

@end
