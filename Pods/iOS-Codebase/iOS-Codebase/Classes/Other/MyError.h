//
//  MyError.h
//  mactehran
//
//  Created by Hamidreza Vakilian on 8/21/1397 AP.
//  Copyright © 1397 archibits. All rights reserved.
//

#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN

@interface MyError : NSError

@property (retain, readonly) NSString* error;
@property (retain, readonly) id obj;

+(instancetype)withErrorString:(NSString*)error andObject:(id)obj;
-(instancetype)initWithErrorString:(NSString*)error andObject:(id)obj;
@end

//NS_ASSUME_NONNULL_END
