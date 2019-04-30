//
//  helper_regex.h
//  Prediscore
//
//  Created by hAmidReza on 10/17/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _regexFirstMatchWeakSelf(pattern, str) [helper_regex firstMatchWithRegex:[helper_regex regexWithPattern:pattern owner:weakSelf] string:str]
#define _regexWeakSelf(pattern) [helper_regex regexWithPattern:pattern owner:weakSelf]
#define _regex(pattern) [helper_regex regexWithPattern:pattern owner:self]
#define _regexMatch(pattern, str) [_regex(pattern) matchesString:str]
#define _regexWeakSelfMatch(pattern, str) [_regexWeakSelf(pattern) matchesString:str]

@interface helper_regex : NSObject

+(NSRegularExpression*)username_validation_regex;
+(NSRegularExpression*)username_typing_regex;

+(BOOL)validateNumber:(NSString*)str;

+(NSString*)firstMatchWithRegex:(NSRegularExpression*)regex string:(NSString*)str;

/**
 same as regexWithPattern:options:owner but with ignorecase option
 
 @param pattern regex pattern
 @param object corresponding object to cache the NSRegularExpression instance on it
 @return the NSRegularExpression instance
 */
+(NSRegularExpression*)regexWithPattern:(NSString*)pattern owner:(id)object;


/**
 creates the NSRegularExpression instance and caching it on the corresponding object. (memory leaks will be also handled this way)
 
 @param pattern regex pattern
 @param options regex options
 @param object the corresponding object to cache the NSRegularExpression instance on it
 @return the NSRegularExpression instance
 */
+(NSRegularExpression*)regexWithPattern:(NSString*)pattern options:(NSRegularExpressionOptions)options owner:(id)object;

@end
