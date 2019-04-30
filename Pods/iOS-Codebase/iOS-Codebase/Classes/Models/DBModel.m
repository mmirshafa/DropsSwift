//
//  DBModel.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 5/26/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "DBModel.h"
#import "helper.h"
//#import "Codebase.h"
#import "helper_file.h"
#import "NSObject+DataObject.h"
#import "Codebase_definitions.h"
#import "MySerialQueue.h"

@implementation DBModel

+(int)modelVersion
{
    return 110;
}

+(NSString*)sqliteFilePath
{
    return [helper_file pathInDocumentDIR:@"essentials.sqlite"];
}

+(MySerialQueue*)serialQ
{
    @synchronized (self)
    {
        if (![self dataObjectForKey:@"serialQ"])
        {
            MySerialQueue* serialQ = [[MySerialQueue alloc] initWithClass:self];
            [self setDataObject:serialQ forKey:@"serialQ"];
        }
        return [self dataObjectForKey:@"serialQ"];
    }
}

+(sqlite3*)get_db
{
    static sqlite3* db;
    
    if (db)
        return db;
    
    //    __block bool result = false;
    [[self serialQ] dispatch:^{
        
        
        if ([helper_file pathExistInDocumentsDIR:@"essentials.sqlite"])
        {
            NSString* file_path = [self sqliteFilePath];
            
            if (sqlite3_open([file_path UTF8String], &db) == SQLITE_OK)
            {
                ///////
                BOOL shouldReplaceNewSqliteFile = YES;
                NSString *query = @"SELECT * FROM `option` WHERE `key` = 'db_version'";
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2(db, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
                    while (sqlite3_step(statement) == SQLITE_ROW) {
                        int64_t intVal = sqlite3_column_int64(statement, 2);
                        if (intVal >= [self modelVersion])
                            shouldReplaceNewSqliteFile = NO;
                    }
                    
                    sqlite3_finalize(statement);
                }
                
                if (shouldReplaceNewSqliteFile)
                {
                    
                    sqlite3_close(db);
                    NSString* template_file_path = [[helper theBundle] pathForResource:@"essentials" ofType:@"sqlite"];
                    NSString* dest_path =  [self sqliteFilePath];
                    
                    NSError* error;
                    
                    [[NSFileManager defaultManager] removeItemAtPath:dest_path error:&error];
                    
                    if (error)
                    {
                        NSLog(@"could not delete old sqlite file: %@", error);
                        return;
                    }
                    
                    if (![[NSFileManager defaultManager] copyItemAtPath:template_file_path toPath:dest_path error:&error])
                    {
                        NSLog(@"error copying the database from bundle: %@", error);
                        return;
                    }
                    else //successful copying of database file
                    {
                        if (sqlite3_open([dest_path UTF8String], &db) == SQLITE_OK)
                        {
                            NSLog(@"database copied and opened.");
                            return;
                        }
                        else //error
                        {
                            NSLog(@"Failed to open database!");
                            return;
                        }
                    }
                    
                }
                else
                    return;
            }
            else //error
            {
                NSLog(@"Failed to open database!");
                return;
            }
        }
        else //file not exists so copy if from the bundle
        {
            NSString* template_file_path = [[helper theBundle] pathForResource:@"essentials" ofType:@"sqlite"];
            NSString* dest_path =  [self sqliteFilePath];
            
            NSError* error;
            if (![[NSFileManager defaultManager] copyItemAtPath:template_file_path toPath:dest_path error:&error])
            {
                NSLog(@"error copying the database from bundle: %@", error);
                return;
            }
            else //successful copying of database file
            {
                if (sqlite3_open([dest_path UTF8String], &db) == SQLITE_OK)
                {
                    NSLog(@"database copied and opened.");
                    return;
                }
                else //error
                {
                    NSLog(@"Failed to open database!");
                    return;
                }
            }
        }
        
    } synchronous:YES];
    return db;
    
    //    return nil;
}

+ (BOOL)purgeTable
{
    __block bool result = false;
    [[self serialQ] dispatch:^{
        
        NSString *deleteSQL = _strfmt(@"DELETE FROM `Essentials`");
        sqlite3_stmt *statement;
        sqlite3_prepare_v2([DBModel get_db], [deleteSQL UTF8String], -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
            result = true;
        //    else
        //        return false;
    } synchronous:YES];
    return result;
}

+(BOOL)deleteValueForKey:(NSString*)key
{
    __block bool result = false;
    [[self serialQ] dispatch:^{
        
        NSString *deleteSQL = _strfmt(@"DELETE FROM `option` WHERE `key` = '%@'", key);
        sqlite3_stmt *statement;
        sqlite3_prepare_v2([DBModel get_db], [deleteSQL UTF8String], -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
            result = true;
        //    else
        //        return false;
        
    } synchronous:YES];
    return result;
}

+(BOOL)deleteAllPermissions
{
    __block bool result = false;
    [[self serialQ] dispatch:^{
        
        NSString *deleteSQL = @"DELETE FROM `permission`";
        sqlite3_stmt *statement;
        sqlite3_prepare_v2([DBModel get_db], [deleteSQL UTF8String], -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
            result = true;
        //    else
        //        return false;
        
    } synchronous:YES];
    return result;
}

+(BOOL)hasPermission:(NSString *)permission
{
    __block bool result = false;
    [[self serialQ] dispatch:^{
        NSString *query = _strfmt(@"SELECT * FROM `permission` WHERE `permission` = '%@'", permission);
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2([DBModel get_db], [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *type_cstr = (char *) sqlite3_column_text(statement, 0);
                NSString* type_str = [NSString stringWithCString:type_cstr encoding:NSUTF8StringEncoding];
                if ([type_str isEqualToString:permission])
                    result = true;
                //            else
                //                return false;
            }
            sqlite3_finalize(statement);
        }
    } synchronous:YES];
    return result;
}

+(BOOL)addPermission:(NSString*)value
{
    __block bool result = false;
    
    [[self serialQ] dispatch:^{
        
        
        NSString *insertSQL = @"INSERT OR REPLACE INTO `permission` (`permission`) VALUES (?)";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2([DBModel get_db], [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_bind_text(statement, 1, [value UTF8String], -1, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                    result = true;
                //            else
                //                return false;
            }
            else
                NSLog(@"begayi zamane insert kardane string");
        }
        else
            NSLog(@"inja bga raftim 34314");
        
    } synchronous:YES];
    
    return result;
}

+(BOOL)updateValue:(id)value forKey:(NSString *)key
{
    if (!value)
        return [self deleteValueForKey:key];
    
    
    __block bool result = false;
    
    [[self serialQ] dispatch:^{
        
        if ([value isKindOfClass:[NSString class]])
        {
            NSString *insertSQL = _strfmt(@"INSERT OR REPLACE INTO `option` (`key`, `type`, `stringValue`) VALUES ('%@', '%@', ?)", key, @"str");
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2([DBModel get_db], [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                if(sqlite3_bind_text(statement, 1, [value UTF8String], -1, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_DONE)
                        result = true;
                    //                else
                    //                    return false;
                }
                else
                    NSLog(@"begayi zamane insert kardane string");
            }
            else
                NSLog(@"inja bga raftim 34314");
        }
        else if ([value isKindOfClass:[NSNumber class]])
        {
            if (strcmp([value objCType], @encode(double)) == 0 || strcmp([value objCType], @encode(float)) == 0)
            {
                NSString *insertSQL = _strfmt(@"INSERT OR REPLACE INTO `option` (`key`, `type`, `doubleValue`) VALUES ('%@', '%@', %@)", key, @"dbl", value);
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2([DBModel get_db], [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_DONE)
                        result = true;
                    //                else
                    //                    return false;
                }
                else
                    NSLog(@"inja bga raftim 3434234234");
                
                
            }
            else if (strcmp([value objCType], [@(YES) objCType]) == 0)
            {
                NSString *insertSQL = _strfmt(@"INSERT OR REPLACE INTO `option` (`key`, `type`, `boolValue`) VALUES ('%@', '%@', %@)", key, @"bool", [value boolValue] ? @"1" : @"0");
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2([DBModel get_db], [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_DONE)
                        result = true;
                    //                else
                    //                    return false;
                }
                else
                    NSLog(@"inja bga raftim 3434xcv");
            }
            else
            {
                NSString *insertSQL = _strfmt(@"INSERT OR REPLACE INTO `option` (`key`, `type`, `intValue`) VALUES ('%@', '%@', %@)", key, @"int", value);
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2([DBModel get_db], [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_DONE)
                        result = true;
                    //                else
                    //                    return false;
                }
                else
                    NSLog(@"inja bga raftim 3434");
            }
            //
            //        else
            //            NSLog(@"unsupported nsnumber: %@", value);
        }
        else
            NSLog(@"unsupported value class: %@ value:%@", NSStringFromClass([value class]), value);
        
        
        
    } synchronous:YES];
    
    return result;
}

+(id)getValueForKey:(NSString *)key
{
    __block id returnVal = nil;
    [[self serialQ] dispatch:^{
        
        NSString *query = _strfmt(@"SELECT * FROM `option` WHERE `key` = '%@'", key);
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2([DBModel get_db], [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *type_cstr = (char *) sqlite3_column_text(statement, 1);
                NSString* type_str = [NSString stringWithCString:type_cstr encoding:NSUTF8StringEncoding];
                if ([type_str isEqualToString:@"int"])
                {
                    int64_t intVal = sqlite3_column_int64(statement, 2);
                    returnVal = @(intVal);
                }
                else if ([type_str isEqualToString:@"str"])
                {
                    char* strVal = (char *) sqlite3_column_text(statement, 3);
                    returnVal = [NSString stringWithCString:strVal encoding:NSUTF8StringEncoding];
                }
                else if ([type_str isEqualToString:@"dbl"])
                {
                    double doubleVal = sqlite3_column_double(statement, 4);
                    returnVal = @(doubleVal);
                }
                else if ([type_str isEqualToString:@"bool"])
                {
                    bool boolVal = sqlite3_column_int(statement, 5);
                    returnVal = @(boolVal);
                }
            }
            
            sqlite3_finalize(statement);
        }
        
    } synchronous:YES];
    
    
    return returnVal;
}

+(void)setValue:(id)value forKey:(NSString *)key
{
    [self updateValue:value forKey:key];
}

+(id)valueForKey:(NSString *)key
{
    return [self getValueForKey:key];
}

@end

