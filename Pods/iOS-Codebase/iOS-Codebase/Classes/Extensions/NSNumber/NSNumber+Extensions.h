//
//  NSNumber+Extensions.h
//  DZNEmptyDataSet
//
//  Created by Hamidreza Vakilian on 3/1/1397 AP.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Extensions)

-(NSNumber*)safe_number; // sometimes you may call safe_number on an object that we think its NSString however its NSNumber indeed. this  method prevents exception!
-(NSNumber*)safe_number2; // sometimes you may call safe_number on an object that we think its NSString however its NSNumber indeed. this  method prevents exception!

@end
