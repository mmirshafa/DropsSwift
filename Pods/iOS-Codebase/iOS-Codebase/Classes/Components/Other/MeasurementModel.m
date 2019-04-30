//
//  MeasurementModel.m
//  Pods
//
//  Created by hAmidReza on 9/11/17.
//
//

#import "MeasurementModel.h"
#import <SQLCipher/sqlite3.h>
#import "helper_file.h"
#import "PodAsset.h"
#import "helper.h"
#import "Codebase_definitions.h"

@implementation MeasurementModel

+(sqlite3*)get_db
{
    static sqlite3* db;
    
    if (db)
        return db;
    
//    [helper makeSqliteThreadSafeIfNeeded];
    
    if (![helper_file pathExistInDocumentsDIR:@"Measurement.sqlite"])
    {
        NSString* template_file_path = [[helper theBundle] pathForResource:@"Measurement" ofType:@"sqlite"];
        NSString* dest_path = [helper_file pathInDocumentDIR:@"Measurement.sqlite"];
        
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
        NSString* dest_path = [helper_file pathInDocumentDIR:@"Measurement.sqlite"];
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

+(NSInteger)appendEvent:(NSString*)code param1:(NSString*)param1 param2:(NSString*)param2 payload:(NSString*)payload user_id:(NSNumber*)user_id
{
    NSString *insertSQL = _strfmt(@"INSERT INTO `Event` (`code`,`param1`,`param2`,`payload`, `user_id`, `build`) VALUES (?,?,?,?,?,?)");
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2([self get_db], [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        
        if(sqlite3_bind_text(statement, 1, [code UTF8String], -1, NULL) != SQLITE_OK)
        {
            NSLog(@"errrrrrrrr");
            return -1;
        }
        
        if (_str_ok2(param1))
        {
            if(sqlite3_bind_text(statement, 2, [param1 UTF8String], -1, NULL) != SQLITE_OK)
            {
                NSLog(@"errrrrrrrr");
                return -1;
            }
        }
        else
            sqlite3_bind_null(statement, 2);
        
        if (_str_ok2(param2))
        {
            if(sqlite3_bind_text(statement, 3, [param2 UTF8String], -1, NULL) != SQLITE_OK)
            {
                NSLog(@"errrrrrrrr");
                return -1;
            }
        }
        else
            sqlite3_bind_null(statement, 3);
        
        
        if (_str_ok2(payload))
        {
            if(sqlite3_bind_text(statement, 4, [payload UTF8String], -1, NULL) != SQLITE_OK)
            {
                NSLog(@"errrrrrrrr");
                return -1;
            }
        }
        else
            sqlite3_bind_null(statement, 4);
        
        if (_num_ok1(user_id))
        {
            if(sqlite3_bind_int64(statement, 5, [user_id unsignedIntegerValue]) != SQLITE_OK)
            {
                NSLog(@"errrrrrrrr");
                return -1;
            }
        }
        else
            sqlite3_bind_null(statement, 5);
        
        
        if(sqlite3_bind_int64(statement, 6, [[helper getAppVersions][@"build"] unsignedIntegerValue]) != SQLITE_OK)
        {
            NSLog(@"errrrrrrrr");
            return -1;
        }
        
        
        
        //EXECUTE QUERY
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSUInteger last_insert_id = sqlite3_last_insert_rowid([self get_db]);
            return last_insert_id;
        }
        else
        {
            NSLog(@"%s",  sqlite3_errmsg([self get_db]));
            return -1;
        }
    }
    else
    {
        NSLog(@"%s",  sqlite3_errmsg([self get_db]));
        return -1;
    }
}

+(NSMutableArray*)fetchAllEvents
{
    NSString *query = @"SELECT * FROM `Event` ORDER By `id` ASC";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2([self get_db], [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        NSMutableArray* result = [NSMutableArray new];
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            [result addObject:[self dictionaryFromEventItem:statement]];
        }
        
        sqlite3_finalize(statement);
        
        return result;
    }
    else
        return nil;
}


+(NSMutableDictionary*)dictionaryFromEventItem:(sqlite3_stmt*)statement
{
    NSMutableDictionary* result = [NSMutableDictionary new];
    
    int64_t _id = sqlite3_column_int64(statement, 0);
    result[@"id"] = @(_id);
    
    char* _code_str = (char*)sqlite3_column_text(statement, 1);
    NSString* _code = [NSString stringWithCString:_code_str encoding:NSUTF8StringEncoding];
    result[@"code"] = _code;
    
    if (sqlite3_column_type(statement, 2) == SQLITE_TEXT)
    {
        char* _param1_str = (char*)sqlite3_column_text(statement, 2);
        NSString* _param1 = [NSString stringWithCString:_param1_str encoding:NSUTF8StringEncoding];
        result[@"param1"] = _param1;
    }
    
    if (sqlite3_column_type(statement, 3) == SQLITE_TEXT)
    {
        char* _param2_str = (char*)sqlite3_column_text(statement, 3);
        NSString* _param2 = [NSString stringWithCString:_param2_str encoding:NSUTF8StringEncoding];
        result[@"param2"] = _param2;
    }
    
    if (sqlite3_column_type(statement, 4) == SQLITE_TEXT)
    {
        char* _payload_str = (char*)sqlite3_column_text(statement, 4);
        NSString* _payload = [NSString stringWithCString:_payload_str encoding:NSUTF8StringEncoding];
        result[@"payload"] = _payload;
    }
    
    if (sqlite3_column_type(statement, 5) == SQLITE_INTEGER)
    {
        int64_t _user_id = sqlite3_column_int64(statement, 5);
        result[@"user_id"] = @(_user_id);
    }
    
    
    int64_t _timestamp = sqlite3_column_int64(statement, 7);
    result[@"time"] = @(_timestamp);
    
    int64_t _bld_no = sqlite3_column_int64(statement, 6);
    result[@"build"] = @(_bld_no);
    
    return result;
}

+(BOOL)purgeEventsToID:(NSUInteger)_id
{
    NSString *deleteSQL = @"DELETE FROM `Event` WHERE `id` <= ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2([self get_db], [deleteSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        if(sqlite3_bind_int64(statement, 1, _id) != SQLITE_OK)
        {
            NSLog(@"errrrrrrrr");
            return nil;
        }
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return true;
        }
        else
            return false;
    }
    else
        return false;
}

@end
