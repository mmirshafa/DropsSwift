//
//  NSObject+deepMutableCopy.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 6/4/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "NSObject+deepMutableCopy.h"

@implementation NSObject (deepMutableCopy)

-(id)deepMutableCopy
{
    return nil;
}

@end

@implementation NSDictionary (deepMutableCopy)

-(id)deepMutableCopy
{
    id returnVal = CFBridgingRelease( CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFDictionaryRef)self, kCFPropertyListMutableContainers));
	NSAssert(returnVal != nil, @"shitttt -> %@", self);
    return returnVal;
}

@end

@implementation NSArray (deepMutableCopy)

-(id)deepMutableCopy
{
   id returnVal = CFBridgingRelease( CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFArrayRef)self, kCFPropertyListMutableContainers));
	
	NSAssert(returnVal != nil, @"shitttt -> %@", self);
	return returnVal;
	
}

@end
