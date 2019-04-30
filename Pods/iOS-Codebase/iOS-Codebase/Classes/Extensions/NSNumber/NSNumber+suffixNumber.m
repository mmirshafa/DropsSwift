//
//  NSNumber.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 5/2/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "NSNumber+suffixNumber.h"

@implementation NSNumber (suffixNumber)

-(NSString*)suffixNumber
{
    long long num = [self longLongValue];
    
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    
    num = llabs(num);
    
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log10(num) / 3.f); //log(1000));
    
    
    NSArray* units = @[@"K",@"M",@"G",@"T",@"P",@"E"];
    
    return [NSString stringWithFormat:@"%@%.1f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}

@end
