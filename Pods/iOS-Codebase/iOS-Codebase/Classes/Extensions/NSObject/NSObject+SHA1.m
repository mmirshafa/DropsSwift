//
//  NSDictionary+SHA1.m
//  PrediScoreApp
//
//  Created by hAmidReza on 3/19/15.
//  Copyright (c) 2015 pxlmind.com. All rights reserved.
//

#import "NSObject+SHA1.h"
#import "helper.h"
#include <CommonCrypto/CommonDigest.h>
#import "Codebase.h"

@implementation NSObject (SHA1)
-(NSString*)SHA1
{
    return nil;
}
@end

@implementation NSDictionary (SHA1)

- (NSString*)SHA1
{
	NSData *data = [[self jsonStr] dataUsingEncoding:NSUTF8StringEncoding];
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	
	CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
	{
		[output appendFormat:@"%02x", digest[i]];
	}
	
	return output;
}

@end

@implementation NSString (SHA1)

- (NSString*)SHA1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
