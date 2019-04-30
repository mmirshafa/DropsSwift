//
//  DFSharedService.m
//  df
//
//  Created by Hamidreza Vakilian on 1/9/1397 AP.
//  Copyright © 1397 Hamidreza Vakilian. All rights reserved.
//

#import "MySharedService.h"
#import "NSObject+DataObject.h"

@interface MySharedService ()

@end

@implementation MySharedService

-(instancetype)_init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    
}

+(instancetype)instance
{
    static NSString* instanceKey;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceKey = @"MySharedServiceInstance";
    });
    
    if (![self dataObjectForKey:instanceKey])
    {
        @synchronized ([self class])
        {
            if (![self dataObjectForKey:instanceKey])
                [self setDataObject:[[self alloc] _init] forKey:instanceKey];
        }
    }
    
    return [self dataObjectForKey:instanceKey];
}

@end
