//
//  Measurement.h
//  Pods
//
//  Created by hAmidReza on 9/11/17.
//
//

#import <Foundation/Foundation.h>

#define __event(code, arg1, arg2, pload, uid) [Measurement event:code param1:arg1 param2:arg2 payload:pload user_id:uid]

@interface Measurement : NSObject

+(NSInteger)event:(NSString*)code param1:(NSString*)param1 param2:(NSString*)param2 payload:(NSString*)payload user_id:(NSNumber*)user_id;
+(void)startDumping;


/**
 sets the dumping interval in seconds
 
 default: 10 seconds

 @param seconds interval in seconds
 */
+(void)setDumpInterval:(NSUInteger)seconds;

@end
