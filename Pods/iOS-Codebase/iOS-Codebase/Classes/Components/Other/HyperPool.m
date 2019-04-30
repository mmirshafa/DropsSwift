//
//  HyperPool.m
//  Aiywa2
//
//  Created by Hamidreza Vakilian on 8/27/1396 AP.
//  Copyright © 1396 nizek. All rights reserved.
//

#import "HyperPool.h"
#import "NSObject+DataObject.h"
#import "Codebase_definitions.h"

//#define debug

@implementation NSObject (HyperPool)

-(void)HyperPoolReleaseObject
{
    void (^hyperpool_release_block)() = [self dataObjectForKey:@"_hyperPool_releaseBlock"];
    NSAssert(_block_ok(hyperpool_release_block), @"%@ this object is not hyperpooled!", NSStringFromSelector(_cmd));
    hyperpool_release_block();
}

@end

@implementation HyperPool

+(NSMutableDictionary*)pools
{
    static NSMutableDictionary* pools;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pools = [NSMutableDictionary new];
    });
    return pools;
}

+(NSMutableDictionary*)createPoolDic
{
    NSMutableDictionary* poolDic = [NSMutableDictionary new];
    poolDic[@"idle_objects"] = [NSMutableArray new];
    poolDic[@"inuse_objects"] = [NSMutableArray new];
    return poolDic;
}

+(void)destroyPoolWithIdentifier:(NSString* _Nonnull)ident
{
    NSAssert(_str_ok2(ident), @"%@: ident not acceptable %@", NSStringFromSelector(_cmd), ident);
    [self pools][ident] = nil;
}

+(NSMutableDictionary*)getPoolDicWithIdentifier:(NSString*)ident
{
    NSAssert(_str_ok2(ident), @"%@: ident not acceptable %@", NSStringFromSelector(_cmd), ident);
    return [self pools][ident];
}

+(void)createPoolWithIdentifier:(NSString* _Nonnull)ident minCount:(NSUInteger)minCount objectCreationBlock:(_Nonnull id (^_Nonnull)(NSString* _Nonnull pool_ident))objectCreationBlock objectBeforeReuseBlock:(void (^_Nullable)(id _Nonnull object2bereused, NSString* _Nonnull pool_ident))reuseBlock
{
    NSAssert(_str_ok2(ident), @"%@: ident not acceptable %@", NSStringFromSelector(_cmd), ident);
    NSAssert(_block_ok(objectCreationBlock), @"%@: objectCreationBlock not acceptable %@", NSStringFromSelector(_cmd), objectCreationBlock);
    
    NSMutableDictionary* poolDic = [HyperPool createPoolDic];
    poolDic[@"identifier"] = ident;
    poolDic[@"creationBlock"] = objectCreationBlock;
    poolDic[@"reuseBlock"] = reuseBlock;
    poolDic[@"minCount"] = @(minCount);
    
    if (minCount > 0)
    {
        for (int i = 0; i < minCount; i++)
        {
            [self __createNewObjectForPoolWithDic:poolDic];
        }
    }
    
    [HyperPool pools][ident] = poolDic;
}

+(id)__createNewObjectForPoolWithDic:(NSMutableDictionary*)poolDic
{
#ifdef debug
    NSLog(@"HyperPool creating an object for pool: %@", poolDic[@"identifier"]);
#endif
    
    id (^objectCreationBlock)(NSString* pool_ident) = poolDic[@"creationBlock"];
    NSString* ident = poolDic[@"identifier"];
    id newObj = objectCreationBlock(ident);
    _defineWeakObject(newObj);
    _defineWeakObject2(poolDic);
    id releaseBlock = ^void () {[HyperPool __unlockObject:weakObj forPoolWithDictionary:weakObj2];};
    [newObj setDataObject:releaseBlock forKey:@"_hyperPool_releaseBlock"];
    [poolDic[@"idle_objects"] addObject:newObj];
    return newObj;
}

+(void)__lockObject:(id)obj forPoolWithDictionary:(NSMutableDictionary*)poolDic
{
    [poolDic[@"idle_objects"] removeObject:obj];
    [poolDic[@"inuse_objects"] addObject:obj];
#ifdef debug
    NSLog(@"[HYPERPOOL: %@] IDLE/INUSE: %lu/%lu", poolDic[@"identifier"], [poolDic[@"idle_objects"] count], [poolDic[@"inuse_objects"] count]);
#endif
}

+(void)__unlockObject:(id)obj forPoolWithDictionary:(NSMutableDictionary*)poolDic
{
    [poolDic[@"inuse_objects"] removeObject:obj];
    [poolDic[@"idle_objects"] addObject:obj];
#ifdef debug
    NSLog(@"[HYPERPOOL: %@] IDLE/INUSE: %lu/%lu", poolDic[@"identifier"], [poolDic[@"idle_objects"] count], [poolDic[@"inuse_objects"] count]);
#endif
}

+(_Nonnull id)acquireObjectFromPoolWithIdent:(NSString* _Nonnull)ident
{
    NSAssert(_str_ok2(ident), @"%@: ident not acceptable %@", NSStringFromSelector(_cmd), ident);
    
    NSMutableDictionary* poolDic = [HyperPool getPoolDicWithIdentifier:ident];
    
    id newObj;
    
    if ([poolDic[@"idle_objects"] count] == 0)
    {
        newObj = [HyperPool __createNewObjectForPoolWithDic:poolDic];
        [HyperPool __lockObject:newObj forPoolWithDictionary:poolDic];
        [HyperPool prepareObject:newObj forReuseFromPoolWithDictionary:poolDic];
    }
    else
    {
        newObj = poolDic[@"idle_objects"][0];
        [HyperPool __lockObject:newObj forPoolWithDictionary:poolDic];
        [HyperPool prepareObject:newObj forReuseFromPoolWithDictionary:poolDic];
    }
    
    return newObj;
}

+(void)prepareObject:(id)obj forReuseFromPoolWithDictionary:(NSMutableDictionary*)poolDic
{
    void (^reuseBlock)(id object2bereused, NSString* pool_ident) = poolDic[@"reuseBlock"];
    if (_block_ok(reuseBlock))
    {
        reuseBlock(obj, poolDic[@"identifier"]);
    }
}

@end
