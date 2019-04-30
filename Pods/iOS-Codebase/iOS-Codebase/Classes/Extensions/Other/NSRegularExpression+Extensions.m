//
//  NSRegularExpression+Extensions.m
//  Pods
//
//  Created by hAmidReza on 8/16/17.
//
//

#import "NSRegularExpression+Extensions.h"

@implementation NSRegularExpression (Extensions)

-(BOOL)matchesString:(NSString*)str
{
	return [self numberOfMatchesInString:str options:0 range:NSMakeRange(0, str.length)] > 0 ? true : false;
}

@end
