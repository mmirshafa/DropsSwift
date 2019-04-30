//
//  NSURLSessionTask+retry.m
//  Prediscore
//
//  Created by hAmidReza on 10/19/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "NSURLSessionTask+retryTask.h"
#import "helper_connectivity.h"

@implementation NSURLSessionTask (retryTask)


-(NSURLSessionTask*)retryTask
{
	NSURLSessionTask* newTask = [helper_connectivity createRetryTaskForTask:self];
	
	return newTask;
}

@end
