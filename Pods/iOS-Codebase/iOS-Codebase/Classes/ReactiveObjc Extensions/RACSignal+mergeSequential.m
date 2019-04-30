//
//  RACSignal+mergeSequential.m
//  rac_tets
//
//  Created by Hamidreza Vakilian on 3/9/1397 AP.
//  Copyright © 1397 Hamidreza Vakilian. All rights reserved.
//

#import "RACSignal+mergeSequential.h"

@implementation RACSignal (mergeSequential)

+ (RACSignal *)mergeSequential:(id<NSFastEnumeration>)signals {
    NSMutableArray *copiedSignals = [NSMutableArray new];
    for (RACSignal *signal in signals) {
        [copiedSignals addObject:signal];
    }
    
    if (copiedSignals.count == 0)
        return [RACSignal return:nil];
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        __block RACCompoundDisposable* disposable = [RACCompoundDisposable new];
        
        __block __weak void(^execSignalWeak)(int);
        void(^execSignal)(int) = ^(int i) {
            if (i >= copiedSignals.count)
            {
                [subscriber sendCompleted];
                return;
            }
            RACDisposable* dis = [copiedSignals[i] subscribeNext:^(id  _Nullable x) {
                [subscriber sendNext:x];
            } error:^(NSError * _Nullable error) {
                [subscriber sendError:error];
            } completed:^{
                execSignalWeak(i+1);
            }];
            
            [disposable addDisposable:dis];
        };
        
        execSignalWeak = execSignal;
        
        execSignal(0);
        
        return [RACDisposable disposableWithBlock:^{
            id k = execSignal; //just to make sure our block is alive until disposal
            k = nil;
            [disposable dispose];
        }];
    }];
}

+ (RACSignal<RACTuple*>*)mergeSequential:(id<NSFastEnumeration>)signals signalNames:(id<NSFastEnumeration>)signalNames {
    NSMutableArray *copiedSignals = [NSMutableArray new];
    NSMutableArray *copiedNames = [NSMutableArray new];
    for (RACSignal *signal in signals) {
        [copiedSignals addObject:signal];
    }
    
    for (NSString *signalName in signalNames) {
        [copiedNames addObject:signalName];
    }
    
    NSAssert(copiedSignals.count == copiedNames.count, @"signals and signal names array count must be equal!");
    
    if (copiedSignals.count == 0)
        return [RACSignal return:nil];
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        __block RACCompoundDisposable* disposable = [RACCompoundDisposable new];
        
        __block __weak void(^execSignalWeak)(int);
        void(^execSignal)(int) = ^(int i) {
            if (i >= copiedSignals.count)
            {
                [subscriber sendCompleted];
                return;
            }
            RACDisposable* dis = [copiedSignals[i] subscribeNext:^(id  _Nullable x) {
                [subscriber sendNext:[RACTuple tupleWithObjects:copiedNames[i], x, nil]];
            } error:^(NSError * _Nullable error) {
                [subscriber sendError:error];
            } completed:^{
                execSignalWeak(i+1);
            }];
            
            [disposable addDisposable:dis];
        };
        
        execSignalWeak = execSignal;
        
        execSignal(0);
        
        return [RACDisposable disposableWithBlock:^{
            id k = execSignal; //just to make sure our block is alive until disposal
            k = nil;
            [disposable dispose];
        }];
    }];
}


@end
