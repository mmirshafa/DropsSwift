//
//  NSDictionary.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 5/2/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "NSObject+cleanNull.h"

@implementation NSObject (cleanNull)

- (void)cleanNull {
    if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSArray class]])
          NSLog(@"NSObject+cleanNull: WARNING: object is an immutable dictionary/array");
}

@end

@implementation NSMutableArray (cleanNull)

- (void)cleanNull {
    [self removeObject:[NSNull null]];
    for (NSObject *child in self) {
        [child cleanNull];
    }
}

@end

@implementation NSMutableDictionary (cleanNull)

- (void)cleanNull {
    NSNull *null = [NSNull null];
    for (NSObject *key in self.allKeys) {
        NSObject *value = self[key];
        if (value == null) {
            [self removeObjectForKey:key];
        } else {
            [value cleanNull];
        }
    }
}

@end