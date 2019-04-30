//
//  HyperCacheModel.h
//  mactehrannew
//
//  Created by hAmidReza on 5/1/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyperCache.h"


@interface HyperCacheModel : NSObject


+(NSDictionary*)cacheItemForURL:(NSString*)url;
+(NSMutableArray*)allCacheItems;

//ASYNC APIs
+(void)insertNewCacheItemWithURL:(NSString*)url md5:(NSString*)md5 type:(HyperCacheItemType)type fileSize:(NSUInteger)fileSize serverContentType:(NSString*)serverContentType ttl:(NSUInteger)ttl tag:(NSString*)tag path:(NSString*)path;
+(void)updateLastAccessTimeWithID:(NSUInteger)_id;
+(void)deleteCacheItemWithID:(NSUInteger)_id;

//SYNC APIs
+(BOOL)sync_insertNewCacheItemWithURL:(NSString*)url md5:(NSString*)md5 type:(HyperCacheItemType)type fileSize:(NSUInteger)fileSize serverContentType:(NSString*)serverContentType ttl:(NSUInteger)ttl tag:(NSString*)tag path:(NSString*)path;
+(BOOL)sync_updateLastAccessTimeWithID:(NSUInteger)_id;
+(BOOL)sync_deleteCacheItemWithID:(NSUInteger)_id;

@end
