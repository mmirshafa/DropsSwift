//
//  NSObject+DataObject.m
//  SetarehShowNew
//
//  Created by hAmidReza on 8/21/1393 AP.
//  Copyright (c) 1393 setarehsho.ir. All rights reserved.
//

#import "NSObject+DataObject.h"
#import <objc/runtime.h>

static char const * const ObjectDataKey = "MyObjectDataKey";
static char const * const ObjectLockKey = "MyObjectLockKey";

#define default_obj_key @"__defaultObjKey"

@implementation NSObject (NSObjectAdditions)
@dynamic objectData;

-(NSLock*)getLock
{
    NSLock* possibleLock = objc_getAssociatedObject(self,ObjectLockKey);
    if (!possibleLock)
    {
        possibleLock = [NSLock new];
        objc_setAssociatedObject(self, ObjectLockKey, possibleLock, OBJC_ASSOCIATION_RETAIN);
    }
    
    return possibleLock;
}

-(id)objectData {
    return [self dataObjectForKey:default_obj_key];
}
- (void)setObjectData:(id)newObjectData {
    [self setDataObject:newObjectData forKey:default_obj_key];
}

-(void)setDataObject:(id)obj forKey:(NSString*)key
{
    [[self getLock] lock];
    NSMutableDictionary* possibleDic = objc_getAssociatedObject(self,ObjectDataKey);
    if (possibleDic)
    {
        possibleDic[key] = obj;
    }
    else
    {
        possibleDic = [NSMutableDictionary new];
        possibleDic[key] = obj;
        objc_setAssociatedObject(self, ObjectDataKey, possibleDic, OBJC_ASSOCIATION_RETAIN);
    }
    [[self getLock] unlock];
}

-(id)dataObjectForKey:(NSString*)key
{
    [[self getLock] lock];
    NSMutableDictionary* possibleDic = objc_getAssociatedObject(self,ObjectDataKey);
    id result = nil;
    if (possibleDic)
    {
        result = possibleDic[key];
    }
    [[self getLock] unlock];
    
    return result;
}
@end

