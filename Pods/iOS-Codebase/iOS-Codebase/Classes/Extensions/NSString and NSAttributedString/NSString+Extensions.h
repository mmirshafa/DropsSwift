//
//  NSString+Extensions.h
//  iOS-Codebase
//
//  Created by Hamidreza Vakilian on 7/3/1396 AP.
//

#import <Foundation/Foundation.h>
#import "helper.h"

@interface NSString (Extensions)


/**
 This azmaing method extracts a number from a string. but the string must only consists of digits.
 
 @return the matched NSNumber or nil
 */
-(NSNumber*)safe_number;

/**
 This amazing method, extracts the first correct occurance of a number from this string. Since we have string matching and heavy regular expression processing, please use this method with caution.
 
 @return the matched NSNumber or nil
 */
-(NSNumber*)safe_number2;


/**
 example:
 BABY -> Baby
 hello -> Hello
 HoW aRe You -> How are you
 
 @return result
 */
-(NSString*)normalCaseString;


/**
 BABY -> Baby
 hello -> Hello
 HoW aRe You -> How Are You
 
 @return result
 */
-(NSString*)normalCaseString2;
@end
