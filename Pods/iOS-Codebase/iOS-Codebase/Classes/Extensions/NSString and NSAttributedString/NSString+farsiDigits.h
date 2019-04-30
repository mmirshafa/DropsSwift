//
//  NSString+farsiDigits.h
//  Kababchi
//
//  Created by hAmidReza on 5/14/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (farsiDigits)

-(NSString*)farsiDigits;
-(NSString*)englishDigits;

@end


@interface NSNumber (farsiDigits)

-(NSString*)farsiDigits;
-(NSString*)englishDigits;

@end
