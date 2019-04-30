//
//  SerialQueue.m
//  DZNEmptyDataSet
//
//  Created by Hamidreza Vakilian on 1/15/1397 AP.
//

#import "MySerialQueue.h"
#import "Codebase_definitions.h"

@interface MySerialQueue ()
{
    char *queueIdentifier;
    dispatch_queue_t dispatchQ;
}
@end

@implementation MySerialQueue

-(dispatch_queue_t)queue
{
    return dispatchQ;
}

-(instancetype)initWithClass:(Class)class
{
    self = [super init];
    if (self)
    {
        queueIdentifier = malloc(sizeof(char) * 40);
        [_strfmt(@"SerialQueue.%@", NSStringFromClass(class)) getCString:queueIdentifier maxLength:40 encoding:NSUTF8StringEncoding];
    }
    return self;
}

-(void)dealloc
{
    free(queueIdentifier);
}

- (dispatch_queue_t)databaseQueue
{
    @synchronized(self)
    {
        if (!dispatchQ)
        {
            dispatchQ = dispatch_queue_create(queueIdentifier, 0);
            
            dispatch_queue_set_specific(dispatchQ, queueIdentifier, (void *)queueIdentifier, NULL);
        }
        return dispatchQ;
    }
}

- (bool)isCurrentQueueThisQueue
{
    return dispatch_get_specific(queueIdentifier) != NULL;
}

//#ifdef DEBUG_SERIALQUEUE_INVOCATIONS
//- (void)dispatchDebug:(const char *)file line:(int)line block:(dispatch_block_t)block synchronous:(bool)synchronous
//#else
- (void)dispatch:(dispatch_block_t)block synchronous:(bool)synchronous
//#endif
{
    if ([self isCurrentQueueThisQueue])
    {
        
        @autoreleasepool
        {
            //#ifdef DEBUG_SERIALQUEUE_INVOCATIONS
            //            CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
            //#endif
            block();
            //#ifdef DEBUG_SERIALQUEUE_INVOCATIONS
            //            CFAbsoluteTime executionTime = (CFAbsoluteTimeGetCurrent() - startTime);
            //            if (executionTime > 0.3)
            //                NSLog(@"***** [%@] Dispatch from %s:%d took %f s", [NSString stringWithCString:queueIdentifier encoding:NSASCIIStringEncoding], file, line, executionTime);
            //#endif
        }
    }
    else
    {
        if (synchronous)
        {
            dispatch_sync([self databaseQueue], ^
                          {
                              @autoreleasepool
                              {
                                  //#ifdef DEBUG_SERIALQUEUE_INVOCATIONS
                                  //                                  CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
                                  //#endif
                                  block();
                                  //#ifdef DEBUG_SERIALQUEUE_INVOCATIONS
                                  //                                  CFAbsoluteTime executionTime = (CFAbsoluteTimeGetCurrent() - startTime);
                                  //                                  if (executionTime > 0.3)
                                  //                                      NSLog(@"***** [%@] Dispatch from %s:%d took %f s", [NSString stringWithCString:queueIdentifier encoding:NSASCIIStringEncoding], file, line, executionTime);
                                  //#endif
                              }
                              
                          });
        }
        else
        {
            dispatch_async([self databaseQueue], ^
                           {
                               @autoreleasepool
                               {
                                   //#ifdef DEBUG_SERIALQUEUE_INVOCATIONS
                                   //                                   CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
                                   //#endif
                                   block();
                                   //#ifdef DEBUG_SERIALQUEUE_INVOCATIONS
                                   //                                   CFAbsoluteTime executionTime = (CFAbsoluteTimeGetCurrent() - startTime);
                                   //                                   if (executionTime > 0.3)
                                   //                                       NSLog(@"***** [%@] Dispatch from %s:%d took %f s", [NSString stringWithCString:queueIdentifier encoding:NSASCIIStringEncoding], file, line, executionTime);
                                   //#endif
                               }
                           });
        }
    }
}

@end
