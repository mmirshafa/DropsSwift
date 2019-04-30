//
//  NSString+farsiDigits.m
//  Kababchi
//
//  Created by hAmidReza on 5/14/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "NSString+farsiDigits.h"

@implementation NSString (farsiDigits)

-(NSString*)farsiDigits
{
	NSString* duplicate = self;
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"0" withString:@"\u06f0"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"1" withString:@"\u06f1"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"2" withString:@"\u06f2"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"3" withString:@"\u06f3"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"4" withString:@"\u06f4"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"5" withString:@"\u06f5"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"6" withString:@"\u06f6"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"7" withString:@"\u06f7"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"8" withString:@"\u06f8"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"9" withString:@"\u06f9"];
	
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0660" withString:@"\u06f0"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0661" withString:@"\u06f1"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0662" withString:@"\u06f2"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0663" withString:@"\u06f3"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0664" withString:@"\u06f4"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0665" withString:@"\u06f5"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0666" withString:@"\u06f6"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u06f7" withString:@"\u06f7"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0668" withString:@"\u06f8"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0669" withString:@"\u06f9"];
	
	return duplicate;
}

-(NSString*)englishDigits
{
	NSString* duplicate = self;
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u06f0" withString:@"0"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u06f1" withString:@"1"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u06f2" withString:@"2"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u06f3" withString:@"3"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u06f4" withString:@"4"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u06f5" withString:@"5"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u06f6" withString:@"6"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u06f7" withString:@"7"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u06f8" withString:@"8"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u06f9" withString:@"9"];
	
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0660" withString:@"0"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0661" withString:@"1"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0662" withString:@"2"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0663" withString:@"3"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0664" withString:@"4"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0665" withString:@"5"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0666" withString:@"6"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0667" withString:@"7"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0668" withString:@"8"];
	duplicate = [duplicate stringByReplacingOccurrencesOfString:@"\u0669" withString:@"9"];
	
	return duplicate;
}

@end

@implementation NSNumber (farsiDigits)

-(NSString*)farsiDigits
{
	return [[NSString stringWithFormat:@"%@", self] farsiDigits];
}

-(NSString*)englishDigits
{
	return [[NSString stringWithFormat:@"%@", self] englishDigits];
}

@end
