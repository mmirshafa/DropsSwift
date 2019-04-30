//
//  NSString+base64.m
//  PrediScoreApp
//
//  Created by hAmidReza on 3/28/15.
//  Copyright (c) 2015 pxlmind.com. All rights reserved.
//

#import "NSString+base64.h"

@implementation NSString (base64)

-(NSString*)base64Encode
{
	NSData *encodeData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
	return base64String;
}

-(NSString*)base64Decode
{
	NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
	NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
	return decodedString;
}

-(NSData*)base64Decode2
{
	NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
	return decodedData;
}

@end
