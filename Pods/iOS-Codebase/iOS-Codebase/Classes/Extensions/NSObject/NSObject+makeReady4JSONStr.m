//
//  NSObject+serializationMakeReady.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 6/4/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "NSObject+makeReady4JSONStr.h"

@implementation NSObject (makeReady4JSONStr)

-(void)makeReady4JSONStr
{
    
}

@end

@implementation NSMutableArray (makeReady4JSONStr)

-(void)makeReady4JSONStr
{
    for (NSObject *value in self) {
        if ([value isKindOfClass:[NSString class]] || ![value isKindOfClass:[NSNumber class]])
        {
            //its okay
        }
        else
        {
            if ([value isKindOfClass:[NSArray class]] || ![value isKindOfClass:[NSDictionary class]])
                [value makeReady4JSONStr];
            else
                [self removeObject:value];
        }
    }
}

@end

@implementation NSMutableDictionary (cleanNull)

- (void)makeReady4JSONStr {
    for (NSString *key in self.allKeys) {
        NSObject *value = self[key];
        if ([value isKindOfClass:[NSString class]] || ![value isKindOfClass:[NSNumber class]])
        {
            //its okay
        }
        else
        {
            if ([value isKindOfClass:[NSArray class]] || ![value isKindOfClass:[NSDictionary class]])
                [value makeReady4JSONStr];
            else
                [self removeObjectForKey:key];
        }
    }
}

@end