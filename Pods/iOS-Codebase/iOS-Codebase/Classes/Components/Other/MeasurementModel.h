//
//  MeasurementModel.h
//  Pods
//
//  Created by hAmidReza on 9/11/17.
//
//

#import <Foundation/Foundation.h>

@interface MeasurementModel : NSObject

+(NSMutableArray*)fetchAllEvents;
+(NSInteger)appendEvent:(NSString*)code param1:(NSString*)param1 param2:(NSString*)param2 payload:(NSString*)payload user_id:(NSNumber*)user_id;
+(BOOL)purgeEventsToID:(NSUInteger)_id;

@end
