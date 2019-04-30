//
//  RACSignal+debounce.m
//  rac_tets
//
//  Created by Hamidreza Vakilian on 1/6/1397 AP.
//  Copyright © 1397 Hamidreza Vakilian. All rights reserved.
//

#import "RACSignal+debounce.h"

@implementation RACSignal (debounce)

- (RACSignal *)debounce:(NSTimeInterval)interval type:(RACDebounceType)type {
    return [[self debounce:interval valuesPassingTest:^(id _) {
        return YES;
    } type:type] setNameWithFormat:@"[%@] -debounce: %f", self.name, (double)interval];
}

- (RACSignal *)debounce:(NSTimeInterval)interval valuesPassingTest:(BOOL (^)(id next))predicate type:(RACDebounceType)type {
    NSCParameterAssert(interval >= 0);
    NSCParameterAssert(predicate != nil);
    
    return [[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        RACCompoundDisposable *compoundDisposable = [RACCompoundDisposable compoundDisposable];
        
        // We may never use this scheduler, but we need to set it up ahead of
        // time so that our scheduled blocks are run serially if we do.
        RACScheduler *scheduler = [RACScheduler scheduler];
        
        // Information about any currently-buffered `next` event.
        __block id nextValue = nil;
        __block BOOL hasNextValue = NO;
        __block BOOL shouldSendThisValue = YES;
        RACSerialDisposable *nextDisposable = [[RACSerialDisposable alloc] init];
        
        void (^flushNext)(BOOL send) = ^(BOOL send) {
            @synchronized (compoundDisposable) {
                [nextDisposable.disposable dispose];
                
                if (!hasNextValue) return;
                if (send) [subscriber sendNext:nextValue];
                
                nextValue = nil;
                hasNextValue = NO;
                shouldSendThisValue = NO;
            }
        };
        
        __block __weak void(^weakScheduleDisposable)(RACScheduler* delayScheduler);
        
        void(^scheduleDisposable)(RACScheduler* scheduler) = ^(RACScheduler* delayScheduler) {
            nextDisposable.disposable = [delayScheduler afterDelay:interval schedule:^{
                shouldSendThisValue = YES;
                if (type == RACDebounceTypeII)
                {
                    flushNext(YES);
                    shouldSendThisValue = YES;
                }
                else if (type == RACDebounceTypeIII)
                {
                    if (hasNextValue)
                    {
                        flushNext(YES);
                        if (weakScheduleDisposable)
                            weakScheduleDisposable(delayScheduler);
                    }
                    else
                    {
                        //                        NSLog(@"no next value");
                    }
                }
            }];
        };
        
        weakScheduleDisposable = scheduleDisposable;
        
        RACDisposable *subscriptionDisposable = [self subscribeNext:^(id x) {
            RACScheduler *delayScheduler = RACScheduler.currentScheduler ?: scheduler;
            BOOL shouldDebounce = predicate(x);
            
            @synchronized (compoundDisposable) {
                
                if (!shouldDebounce) {
                    [subscriber sendNext:x];
                    return;
                }
                
                nextValue = x;
                hasNextValue = YES;
                
                if (shouldSendThisValue)
                {
                    flushNext(YES);
                    scheduleDisposable(delayScheduler);
                }
            }
        } error:^(NSError *error) {
            [compoundDisposable dispose];
            [subscriber sendError:error];
        } completed:^{
            if (type == RACDebounceTypeII || type == RACDebounceTypeIII)
                flushNext(YES);
            [subscriber sendCompleted];
        }];
        
        [compoundDisposable addDisposable:subscriptionDisposable];
        
        return compoundDisposable;
    }] setNameWithFormat:@"[%@] -deboune: %f valuesPassingTest:", self.name, (double)interval];
}

@end
