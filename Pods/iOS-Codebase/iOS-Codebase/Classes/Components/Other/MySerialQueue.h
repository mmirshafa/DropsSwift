//
//  SerialQueue.h
//  DZNEmptyDataSet
//
//  Created by Hamidreza Vakilian on 1/15/1397 AP.
//

#import <Foundation/Foundation.h>

@interface MySerialQueue : NSObject

#define DEBUG_SERIALQUEUE_INVOCATIONS


-(instancetype)initWithClass:(Class)class;

@property (nonatomic, readonly) dispatch_queue_t queue;

//#ifdef DEBUG_SERIALQUEUE_INVOCATIONS
//- (void)dispatchDebug:(const char *)file line:(int)line block:(dispatch_block_t)block synchronous:(bool)synchronous;
//#else
- (void)dispatch:(dispatch_block_t)block synchronous:(bool)synchronous;
//#endif

//#ifdef DEBUG_SERIALQUEUE_INVOCATIONS
//#define dispatch dispatchDebug:__FILE__ line:__LINE__ block
//#endif

@end
