//
//  RACSignal+mergeSequential.h
//  rac_tets
//
//  Created by Hamidreza Vakilian on 3/9/1397 AP.
//  Copyright © 1397 Hamidreza Vakilian. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal (mergeSequential)

+ (RACSignal *)mergeSequential:(id<NSFastEnumeration>)signals;
+ (RACSignal<RACTuple*>*)mergeSequential:(id<NSFastEnumeration>)signals signalNames:(id<NSFastEnumeration>)signalNames;

@end
