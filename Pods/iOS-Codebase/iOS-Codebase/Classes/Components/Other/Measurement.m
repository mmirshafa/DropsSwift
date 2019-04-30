//
//  Measurement.m
//  Pods
//
//  Created by hAmidReza on 9/11/17.
//
//

#import "Measurement.h"
#import "MeasurementModel.h"
#import "Codebase_definitions.h"
#import "helper.h"
#import "helper_connectivity.h"

@implementation Measurement

static NSUInteger interval;

+(void)startDumping
{
	NSAssert(_str_ok2(_codebaseDic[@"measurement_post_url"]), @"##Measurement: put the measurement_post_url in codebase dic in info.plist");
	
	NSLog(@"##Measurement: dumping started");
	
	interval = 10;
	[self __schedule_dump];
}

+(void)setDumpInterval:(NSUInteger)seconds
{
	NSLog(@"##Measurement: dumping interval set to %lu", seconds);
	interval = seconds;
}

+(void)dumpEvents
{
	static NSURLSessionTask* dumpTask;
	
	[dumpTask cancel];
	
	NSArray* items = [MeasurementModel fetchAllEvents];
	
	if (_arr_ok2(items))
	{
		NSMutableDictionary* postDic = [NSMutableDictionary new];
		postDic[@"items"] = items;
		postDic[@"device_uuid"] = [helper device_uuid];
		postDic[@"toffset"] = @([[NSTimeZone localTimeZone] secondsFromGMT]);
		
		dumpTask = [helper_connectivity serverPostWithPath:_codebaseDic[@"measurement_post_url"] bodyDic:@{@"items": items} completionHandler:^(long response_code, id obj) {
			if (response_code == 200)
			{
				BOOL purgeResult = [MeasurementModel purgeEventsToID:[[items lastObject][@"id"] unsignedIntegerValue]];
				if (purgeResult)
					NSLog(@"##Measurement: %lu events dumped and purged successfully", [items count]);
				else
					NSLog(@"##Measurement: %lu events dumped but purge error", [items count]);
			}
		}];
		
		[dumpTask resume];
	}
	
	[self __schedule_dump];
}

+(void)__schedule_dump
{
	_backThreadDefAfter(^{
		[self dumpEvents];
	}, interval);
}

+(NSInteger)event:(NSString *)code param1:(NSString *)param1 param2:(NSString *)param2 payload:(NSString *)payload user_id:(NSNumber *)user_id
{
	return [MeasurementModel appendEvent:code param1:param1 param2:param2 payload:payload user_id:user_id];
}

@end
