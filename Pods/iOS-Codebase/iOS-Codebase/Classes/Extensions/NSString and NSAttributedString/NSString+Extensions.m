//
//  NSString+Extensions.m
//  iOS-Codebase
//
//  Created by Hamidreza Vakilian on 7/3/1396 AP.
//

#import "NSString+Extensions.h"
#import "Codebase_definitions.h"
#import "NSObject+DataObject.h"

@implementation NSString (Extensions)

-(NSNumber*)safe_number
{
    return [[helper decimalStrFormatter] numberFromString:self];
}

+(NSRegularExpression*)safe_number2_regex
{
    if ([NSString dataObjectForKey:@"_safe_number2_regex"])
    {
        return [NSString dataObjectForKey:@"_safe_number2_regex"];
    }
    else
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d+\\.\\d+|\\d+\\.|\\d+|\\.\\d+)" options:0 error:nil];
        
        [NSString setDataObject:regex forKey:@"_safe_number2_regex"];
        
        return regex;
    }
}

-(NSNumber*)safe_number2
{
    NSRegularExpression* regex = [NSString safe_number2_regex];
    
    NSTextCheckingResult* result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (result)
    {
        NSString* substr = [self substringWithRange:result.range];
        return [substr safe_number];
    }
    
    return nil;
}

-(NSString*)normalCaseString
{
    if (!_str_ok2(self))
        return self;
    NSString* lowerCased = [self lowercaseString];
    NSString* firstCharString = [lowerCased substringWithRange:NSMakeRange(0, 1)];
    return _strfmt(@"%@%@", [firstCharString uppercaseString], [lowerCased substringFromIndex:1]);
}

-(NSString*)normalCaseString2
{
    if (!_str_ok2(self))
        return self;
    
    NSArray* words = [self componentsSeparatedByString:@" "];
    
    NSString* result = @"";
    for (NSString* aWord in words)
        result = _strfmt(@"%@%@", _str_ok2(result) ? [NSString stringWithFormat:@"%@ ", result] : @"", [aWord normalCaseString]);
    return result;
}

@end
