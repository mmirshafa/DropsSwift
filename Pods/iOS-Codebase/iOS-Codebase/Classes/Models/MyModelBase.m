//
//  DFModelBase.m
//  deepfinity
//
//  Created by Hamidreza Vakilian on 12/24/1396 AP.
//  Copyright © 1396 nizek. All rights reserved.
//

#import "MyModelBase.h"
#import "MySerialQueue.h"
#import "objc/runtime.h"
#import "NSMapTable+Extensions.h"
#import "NSObject+DataObject.h"
#import "Codebase_definitions.h"

@interface MyModelBase ()
@property (class, nonatomic, readonly) NSMapTable* modelsTable;
@end

@implementation MyModelBase

+(MySerialQueue*)serialQ
{
    static NSString* serialQKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQKey = @"serialQ";
    });
    
    @synchronized (self)
    {
        if (![self dataObjectForKey:serialQKey])
        {
            MySerialQueue* serialQ = [[MySerialQueue alloc] initWithClass:self];
            [self setDataObject:serialQ forKey:serialQKey];
        }
        return [self dataObjectForKey:serialQKey];
    }
}

+(void)storeInMapTable:(MyModelBase*)model withUID:(NSString*)uid
{
    if (!model || !_str_ok2(uid))
        return;
    
    [[self serialQ] dispatch:^{
        
        [MyModelBase.modelsTable setObject:model forKey:uid];
        
    } synchronous:YES];
}

+(NSArray*)allModels
{
    NSMutableArray* result = [NSMutableArray new];
    
    [[self serialQ] dispatch:^{
        
        NSString* moodelUIDPrefix = NSStringFromClass(self.class);
        
        for (NSString* aModelUID in MyModelBase.modelsTable)
        {
            if (self.class == MyModelBase.class)
                [result addObject:MyModelBase.modelsTable[aModelUID]];
            else if ([aModelUID hasPrefix:moodelUIDPrefix])
                [result addObject:MyModelBase.modelsTable[aModelUID]];
        }
        
    } synchronous:YES];
    
    return result;
}

//must be subclassed if the subclass want to use default acquire methods
-(instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self)
    {
        __builtin_trap();
    }
    return self;
}

+(void)load
{
    NSMapTable *modelsTable = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                                    valueOptions:NSMapTableWeakMemory];
    
    [self setDataObject:modelsTable forKey:@"modelsTable"];
}

+(NSMapTable *)modelsTable
{
    return [self dataObjectForKey:@"modelsTable"];
}

#pragma mark Acquision Methods

+(instancetype)acquireWithID:(NSString*)id
{
    NSString* uid = [self uidForID:id];
    
    return [self acquireWithUID:uid forceCreateWithModel:nil];
}

+(instancetype)acquireWithModel:(id)model forceCreate:(BOOL)forceCreate
{
    return [self acquireWithModel:model forceCreate:forceCreate update:nil];
}

+(instancetype)acquireWithModel:(id)model forceCreate:(BOOL)forceCreate update:(void (^_Nullable)(id match, id model))updateCB
{
    NSString* uid = [self uidForModel:model];
    
    return [self acquireWithUID:uid forceCreateWithModel:forceCreate ? model : nil update:updateCB];
}


+(instancetype)acquireWithUID:(NSString*)uid forceCreateWithModel:(id)model
{
    return [self acquireWithUID:uid forceCreateWithModel:model update:nil];
}

+(void)purgeModels
{
    [[self serialQ] dispatch:^{
        
        if (self.class == MyModelBase.class)
            [MyModelBase.modelsTable removeAllObjects];
        else
        {
            NSMutableArray* modelIDs2Remove = [NSMutableArray new];
            NSString* moodelUIDPrefix = NSStringFromClass(self.class);
            
            for (NSString* aModelUID in MyModelBase.modelsTable)
            {
                
                if ([aModelUID hasPrefix:moodelUIDPrefix])
                    [modelIDs2Remove addObject:aModelUID];
            }
            
            for (NSString* modelUID2Remove in modelIDs2Remove)
                [MyModelBase.modelsTable removeObjectForKey:modelUID2Remove];
        }
        
    } synchronous:YES];
}

+(instancetype)acquireWithUID:(NSString*)uid forceCreateWithModel:(id)model update:(void (^_Nullable)(id match, id model))updateCB
{
    __block MyModelBase* possible_model;
    [[self serialQ] dispatch:^{
        possible_model = MyModelBase.modelsTable[uid];
        
        if (!possible_model && model)
        {
            possible_model = [[self alloc] initWithModel:model];
            [self storeInMapTable:possible_model withUID:uid];
        }
        else if (updateCB && possible_model)
        {
            updateCB(possible_model, model);
        }
    } synchronous:YES];
    
    return possible_model;
}

#pragma mark UID computation methods

// subclass this method if you want other implementations
+(NSString*)uidForModel:(id)model
{
    return [self uidForID:[model valueForKey:[self modelIDFieldKey]]];
}

+(NSString*)modelIDFieldKey
{
    return @"id";
}

+(NSString*)uidForID:(NSString*)id
{
    if (!_str_ok2(id))
        return nil;
    return _strfmt(@"%@/%@", NSStringFromClass([self class]), id);
}

+(NSArray<__kindof MyModelBase*>*)acquireMultipleWithModels:(NSArray<id>*)models forceCreate:(BOOL)force
{
    return [self acquireMultipleWithModels:models forceCreate:force update:nil];
}

+(NSArray<__kindof MyModelBase*>*)acquireMultipleWithModels:(NSArray<id>*)models forceCreate:(BOOL)force  update:(void (^_Nullable)(id match, id model))updateCB
{
    NSMutableArray* result = [NSMutableArray new];
    for (NSDictionary* dic in models)
        [result addObject:[self acquireWithModel:dic forceCreate:force update:updateCB]];
    return result;
}

@end
