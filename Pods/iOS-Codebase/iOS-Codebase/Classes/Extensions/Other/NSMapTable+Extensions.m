//
//  NSMapTable+NSMapTableExtensions.m
//  deepfinity
//
//  Created by Hamidreza Vakilian on 12/26/1396 AP.
//  Copyright © 1396 nizek. All rights reserved.
//

#import "NSMapTable+Extensions.h"

@implementation NSMapTable (Extensions)


- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    if (obj != nil) {
        [self setObject:obj forKey:key];
    } else {
        [self removeObjectForKey:key];
    }
}


@end
