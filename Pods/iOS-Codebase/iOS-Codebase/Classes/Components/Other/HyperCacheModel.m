//
//  HyperCacheModel.m
//  mactehrannew
//
//  Created by hAmidReza on 5/1/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "HyperCacheModel.h"
#import <SQLCipher/sqlite3.h>
#import "helper_file.h"
#import "PodAsset.h"
#import "helper.h"
#import "Codebase_definitions.h"

@implementation HyperCacheModel

+(sqlite3*)get_db
{
	static sqlite3* db;
	
	if (db)
		return db;
	
//    [helper makeSqliteThreadSafeIfNeeded];
	
	if (![helper_file pathExistInDocumentsDIR:@"HyperCache.sqlite"])
	{
		NSString* template_file_path = [[helper theBundle] pathForResource:@"HyperCache" ofType:@"sqlite"];
		NSString* dest_path = [helper_file pathInDocumentDIR:@"HyperCache.sqlite"];
		
		NSError* error;
		if (![[NSFileManager defaultManager] copyItemAtPath:template_file_path toPath:dest_path error:&error])
		{
			NSLog(@"error copying the database from bundle: %@", error);
		}
		else //successful copying of database file
		{
			if (sqlite3_open([dest_path UTF8String], &db) == SQLITE_OK)
			return db;
			else //error
			{
				NSLog(@"Failed to open database!");
				return nil;
			}
		}
	}
	else
	{
		NSString* dest_path = [helper_file pathInDocumentDIR:@"HyperCache.sqlite"];
		if (sqlite3_open([dest_path UTF8String], &db) == SQLITE_OK)
		return db;
		else //error
		{
			NSLog(@"Failed to open database!");
			return nil;
		}
	}
	
	return nil;
}

////////////////
+(void)insertNewCacheItemWithURL:(NSString*)url md5:(NSString*)md5 type:(HyperCacheItemType)type fileSize:(NSUInteger)fileSize serverContentType:(NSString*)serverContentType ttl:(NSUInteger)ttl tag:(NSString*)tag path:(NSString*)path
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		[HyperCacheModel sync_insertNewCacheItemWithURL:url md5:md5 type:type fileSize:fileSize serverContentType:serverContentType ttl:ttl tag:tag path:path];
	});
}

+(BOOL)sync_insertNewCacheItemWithURL:(NSString*)url md5:(NSString*)md5 type:(HyperCacheItemType)type fileSize:(NSUInteger)fileSize serverContentType:(NSString*)serverContentType ttl:(NSUInteger)ttl tag:(NSString*)tag path:(NSString*)path
{
	NSString *insertSQL = _strfmt(@"INSERT INTO `HyperCache` (`url`,`md5`,`type`,`fileSize`, `serverContentType`,`ttl`,`tag`,`path`) VALUES (?,?,?,?,?,?,?,?)");
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2([HyperCacheModel get_db], [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		//bind url
		if(sqlite3_bind_text(statement, 1, [url UTF8String], -1, NULL) != SQLITE_OK)
		{
			NSLog(@"errrrrrrrr");
			return false;
		}
		
		//bind md5
		if(sqlite3_bind_text(statement, 2, [md5 UTF8String], -1, NULL) != SQLITE_OK)
		{
			NSLog(@"errrrrrrrr");
			return false;
		}
		
		//bind type
		if(sqlite3_bind_int64(statement, 3, type) != SQLITE_OK)
		{
			NSLog(@"errrrrrrrr");
			return false;
		}
		
		//bind filesize
		if(sqlite3_bind_int64(statement, 4, fileSize) != SQLITE_OK)
		{
			NSLog(@"errrrrrrrr");
			return false;
		}
		
		//bind serverContentType
		if (serverContentType)
		{
			if(sqlite3_bind_text(statement, 5, [serverContentType UTF8String], -1, NULL) != SQLITE_OK)
			{
				NSLog(@"errrrrrrrr");
				return false;
			}
		}
		else
		{
			if(sqlite3_bind_null(statement, 5) != SQLITE_OK)
			{
				NSLog(@"errrrrrrrr");
				return false;
			}
		}
		
		//bind ttl
		if(sqlite3_bind_int64(statement, 6, ttl) != SQLITE_OK)
		{
			NSLog(@"errrrrrrrr");
			return false;
		}
		
		//bind tag
		if (tag)
		{
			if(sqlite3_bind_text(statement, 7, [tag UTF8String], -1, NULL) != SQLITE_OK)
			{
				NSLog(@"errrrrrrrr");
				return false;
			}
		}
		else
		{
			if(sqlite3_bind_null(statement, 7) != SQLITE_OK)
			{
				NSLog(@"errrrrrrrr");
				return false;
			}
		}
		
		//bind path
		if(sqlite3_bind_text(statement, 8, [path UTF8String], -1, NULL) != SQLITE_OK)
		{
			NSLog(@"errrrrrrrr");
			return false;
		}
		
		//EXECUTE QUERY
		if (sqlite3_step(statement) == SQLITE_DONE)
		{
			//			NSMutableDictionary* item = [NSMutableDictionary new];
			//			item[@"id"] = @(;
			//			item[@"url"] = url;
			//			item[@"md5"] = md5;
			//			item[@"type"] = @(type);
			//			item[@"fileSize"] = @(fileSize);
			NSUInteger last_insert_id = sqlite3_last_insert_rowid([HyperCacheModel get_db]);
			NSDictionary* newItem = [HyperCacheModel diskCacheItemWithID:last_insert_id];
			[HyperCacheModel memoryLookupTable][newItem[@"url"]] = newItem;
			return true;
		}
		else
		{
			NSLog(@"%s",  sqlite3_errmsg([HyperCacheModel get_db]));
			return false;
		}
	}
	else
	{
		NSLog(@"%s",  sqlite3_errmsg([HyperCacheModel get_db]));
		return false;
	}
}

+(NSMutableDictionary*)memoryLookupTable
{
	static NSMutableDictionary* memoryLookupTable;
	if (!memoryLookupTable)
		memoryLookupTable = [NSMutableDictionary new];
	return memoryLookupTable;
}

+(void)fillMemoryLookupTable_full
{
	NSString *query = @"SELECT * FROM `HyperCache`";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2([HyperCacheModel get_db], [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		NSMutableDictionary* memoryLookupTable = [HyperCacheModel memoryLookupTable];
		
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSMutableDictionary* anItem = [HyperCacheModel dictionaryFromHyperCacheItemRow:statement];
			memoryLookupTable[anItem[@"url"]] = anItem;
		}
		
		sqlite3_finalize(statement);
	}
}

+(NSDictionary*)diskCacheItemWithID:(NSUInteger)_id
{
	NSString *query = @"SELECT * FROM `HyperCache` WHERE `id`=?";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2([HyperCacheModel get_db], [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		if(sqlite3_bind_int64(statement, 1, _id) != SQLITE_OK)
		{
			NSLog(@"errrrrrrrr");
			return nil;
		}
		
		NSDictionary* result;
		
		if (sqlite3_step(statement) == SQLITE_ROW) {
			
			result = [HyperCacheModel dictionaryFromHyperCacheItemRow:statement];
		}
		
		sqlite3_finalize(statement);
		
		return result;
	}
	
	return nil;
}

+(NSDictionary*)memoryCacheItemForURL:(NSString*)url
{
	return [HyperCacheModel memoryLookupTable][url];
}

+(NSDictionary*)cacheItemForURL:(NSString*)url
{
	return [HyperCacheModel memoryCacheItemForURL:url];
}

+(void)updateLastAccessTimeWithID:(NSUInteger)_id
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		[HyperCacheModel sync_updateLastAccessTimeWithID:_id];
	});
}

+(BOOL)sync_updateLastAccessTimeWithID:(NSUInteger)_id
{
	NSString *updateSQL = _strfmt(@"UPDATE `HyperCache` SET `lastAccessTime`=datetime('now','localtime'), `accessCount` = `accessCount` + 1 WHERE `ID`=?");
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2([HyperCacheModel get_db], [updateSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		//bind url
		if(sqlite3_bind_int64(statement, 1, _id) != SQLITE_OK)
		{
			NSLog(@"errrrrrrrr");
			return false;
		}
		//EXECUTE QUERY
		if (sqlite3_step(statement) == SQLITE_DONE)
		{
			NSDictionary* updatedItem = [HyperCacheModel diskCacheItemWithID:_id];
			[HyperCacheModel memoryLookupTable][updatedItem[@"url"]] = updatedItem;
			return true;
		}
		else
		{
			NSLog(@"%s",  sqlite3_errmsg([HyperCacheModel get_db]));
			return false;
		}
	}
	else
	{
		NSLog(@"%s",  sqlite3_errmsg([HyperCacheModel get_db]));
		return false;
	}
}

+(NSMutableArray*)_allCacheItems
{
	NSString *query = @"SELECT * FROM `HyperCache`";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2([HyperCacheModel get_db], [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		NSMutableArray* result = [NSMutableArray new];
		
		while (sqlite3_step(statement) == SQLITE_ROW)
		{
			[result addObject:[HyperCacheModel dictionaryFromHyperCacheItemRow:statement]];
		}
		
		sqlite3_finalize(statement);
		
		return result;
	}
	else
		return nil;
}

+(NSMutableArray*)allCacheItems
{
	return [[HyperCacheModel memoryLookupTable] allValues];
}

+(void)deleteCacheItemWithID:(NSUInteger)_id
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		[HyperCacheModel sync_deleteCacheItemWithID:_id];
	});
}


+(BOOL)sync_deleteCacheItemWithID:(NSUInteger)_id
{
	NSString *deleteSQL = @"DELETE FROM `HyperCache` WHERE `ID` = ?";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2([HyperCacheModel get_db], [deleteSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		if(sqlite3_bind_int64(statement, 1, _id) != SQLITE_OK)
		{
			NSLog(@"errrrrrrrr");
			return nil;
		}
		
		if (sqlite3_step(statement) == SQLITE_DONE)
		{
			NSDictionary* item2Delete;
			for (NSMutableDictionary* anItem in [[HyperCacheModel memoryLookupTable] allValues])
			{
				if ([anItem[@"id"] unsignedIntegerValue] == _id)
				{
					item2Delete = anItem;
					break;
				}
			}
			[[HyperCacheModel memoryLookupTable] removeObjectForKey:item2Delete[@"url"]];
			return true;
		}
		else
		return false;
	}
	else
	return false;
}

+(NSMutableDictionary*)dictionaryFromHyperCacheItemRow:(sqlite3_stmt*)statement
{
	NSMutableDictionary* result = [NSMutableDictionary new];
	
	int64_t _id = sqlite3_column_int64(statement, 0);
	result[@"id"] = @(_id);
	
	char* _url_cstr = (char*)sqlite3_column_text(statement, 1);
	NSString* _url = [NSString stringWithCString:_url_cstr encoding:NSUTF8StringEncoding];
	result[@"url"] = _url;
	
	char* _md5_cstr = (char*)sqlite3_column_text(statement, 2);
	NSString* _md5 = [NSString stringWithCString:_md5_cstr encoding:NSUTF8StringEncoding];
	result[@"md5"] = _md5;
	
	int64_t _type = sqlite3_column_int64(statement, 3);
	result[@"type"] = @(_type);
	
	int64_t _fileSize = sqlite3_column_int64(statement, 4);
	result[@"fileSize"] = @(_fileSize);
	
	
	if (sqlite3_column_type(statement, 5) != SQLITE_NULL)
	{
		char* _serverContentType_cstr = (char*)sqlite3_column_text(statement, 5);
		NSString* _serverContentType = [NSString stringWithCString:_serverContentType_cstr encoding:NSUTF8StringEncoding];
		result[@"serverContentType"] = _serverContentType;
	}
	
	char* _creationTime_cstr = (char*)sqlite3_column_text(statement, 6);
	NSString* _creationTime_str = [NSString stringWithCString:_creationTime_cstr encoding:NSUTF8StringEncoding];
	NSDate* _creationTime = [[HyperCacheModel df] dateFromString:_creationTime_str];
	result[@"creationTime"] = _creationTime;
	
	char* _lastAccessTime_cstr = (char*)sqlite3_column_text(statement, 7);
	NSString* _lastAccessTime_str = [NSString stringWithCString:_lastAccessTime_cstr encoding:NSUTF8StringEncoding];
	NSDate* _lastAccessTime = [[HyperCacheModel df] dateFromString:_lastAccessTime_str];
	result[@"lastAccessTime"] = _lastAccessTime;
	
	int64_t _ttl = sqlite3_column_int64(statement, 8);
	result[@"ttl"] = @(_ttl);
	
	if (sqlite3_column_type(statement, 9) != SQLITE_NULL)
	{
		char* _tag_cstr = (char*)sqlite3_column_text(statement, 9);
		NSString* _tag = [NSString stringWithCString:_tag_cstr encoding:NSUTF8StringEncoding];
		result[@"tag"] = _tag;
	}
	
	char* _path_cstr = (char*)sqlite3_column_text(statement, 10);
	NSString* _path = [NSString stringWithCString:_path_cstr encoding:NSUTF8StringEncoding];
	result[@"path"] = _path;
	
	int64_t _accessCount = sqlite3_column_int64(statement, 11);
	result[@"accessCount"] = @(_accessCount);
	
	
	return result;
}

+(NSDateFormatter*)df
{
	static NSDateFormatter* df;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		df = [NSDateFormatter new];
		df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	});
	return df;
}

+(void)load
{
	[super load];
	[self fillMemoryLookupTable_full];
}

@end
