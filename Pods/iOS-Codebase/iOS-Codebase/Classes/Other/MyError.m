
//
//  MyError.m
//  mactehran
//
//  Created by Hamidreza Vakilian on 8/21/1397 AP.
//  Copyright © 1397 archibits. All rights reserved.
//

#import "MyError.h"

@interface MyError ()
@property (retain, readwrite) NSString* error;
@property (retain, readwrite) id obj;
@end

@implementation MyError

+(instancetype)withErrorString:(NSString*)error andObject:(id)obj
{
    return [[MyError alloc] initWithErrorString:error andObject:obj];
}

-(instancetype)initWithErrorString:(NSString*)error andObject:(id)obj
{
    self = [MyError errorWithDomain:NSItemProviderErrorDomain code:5000 userInfo:nil];
    if (self)
    {
        self.error = error;
        self.obj = obj;
    }
    
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@", [super description], self.error];
}

-(NSString *)localizedDescription
{
    return [NSString stringWithFormat:@"%@: %@", [super description], self.error];
}

@end
