//
//  RACSignal+delayedRetry.h
//  df
//
//  Created by Hamidreza Vakilian on 1/20/1397 AP.
//  Copyright © 1397 Hamidreza Vakilian. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal (delayedRetry)

- (RACSignal *)delayedRetry:(NSTimeInterval)interval;

@end
