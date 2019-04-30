//
//  RACSignal+ignoreWhile.h
//  oncost
//
//  Created by Hamidreza Vakilian on 5/9/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal (ignoreWhile)

/**
 Live ignoring signal output. calls the block each time a next value has come.
 
 @param ignoreWhileBlock the block which returns a boolean value. if true the next value will be ignored. if false it will be passed.
 @return the signal
 */
-(RACSignal*)ignoreWhile:(BOOL (^_Nonnull)(void))ignoreWhileBlock;

@end
