//
//  RACSignal+ignoreWhile.m
//  oncost
//
//  Created by Hamidreza Vakilian on 5/9/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "RACSignal+ignoreWhile.h"

@implementation RACSignal (ignoreWhile)

-(RACSignal*)ignoreWhile:(BOOL (^_Nonnull)(void))ignoreWhileBlock
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [self subscribeNext:^(id  _Nullable x) {
            if (ignoreWhileBlock() == false)
                [subscriber sendNext:x];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
    }];
}

@end
