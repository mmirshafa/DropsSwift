//
//  _modelbase.m
//  oncost
//
//  Created by Hamidreza Vakilian on 3/8/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "_modelbase.h"
#import "objc/runtime.h"

@implementation _modelbase

-(BOOL)description_shouldPrintKey:(NSString*)key
{
    return true;
}

-(NSString *)description
{
    NSMutableString* str = [NSMutableString new];
    
    [str appendString:[super description]];
    
    [str appendString:@" {\n"];
    
    NSMutableArray<NSDictionary*>* props = [NSMutableArray new];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            if ([self description_shouldPrintKey:propertyName])
            {
                id propertyValue = [self valueForKey:propertyName];
                [props addObject:@{@"name": propertyName, @"value": propertyValue ? propertyValue : [NSNull null]}];
            }
        }
    }
    free(properties);
    
    [props sortUsingComparator:^NSComparisonResult(NSDictionary*  _Nonnull obj1, NSDictionary*  _Nonnull obj2) {
        return [obj1[@"name"] compare:obj2[@"name"]];
    }];
    
    for (NSDictionary* dic in props)
        [str appendFormat:@"\t%@: %@\n", dic[@"name"], dic[@"value"]];
    
    [str appendString:@"}"];
    
    return str;
}

@end
