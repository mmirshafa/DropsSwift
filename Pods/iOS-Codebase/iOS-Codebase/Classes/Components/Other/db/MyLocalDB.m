//
//  MyLocalDB.m
//  oncost
//
//  Created by Hamidreza Vakilian on 3/21/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "MyLocalDB.h"
#import "codebase_definitions.h"
#import "helper_file.h"
#import "NSObject+MD5.h"

@interface MyLocalDB ()

@end

@implementation MyLocalDB

-(void)initialize
{
    [super initialize];
    
    serialQ = [[MySerialQueue alloc] initWithClass:self.class];
    
    [serialQ dispatch:^{
        [self initDB];
    } synchronous:YES];
}

-(void)reopenDB
{
    NSString* filePath = [self.class sqliteFilePath];
    
    NSLog(@"SQLITEPATH: %@", filePath);
    database = [MyBaseDB databaseWithPath:filePath];
    
    if (![database open])
    {
        NSLog(@"***** Error: couldn't open database! *****");
        [[[NSFileManager alloc] init] removeItemAtPath:filePath error:nil];
        
        [self initDB];
        
        return;
    }
    
    [[NSURL fileURLWithPath:filePath] setResourceValue:@(true) forKey:NSURLIsExcludedFromBackupKey error:nil];
    
    [database setShouldCacheStatements:true];
    [database setLogsErrors:true];
    
    if ([self isCurrentDatabaseEncrypted])
    {
        sqlite3_exec([database sqliteHandle], _strfmt(@"PRAGMA key=\"%@\"", [self.class dbKey]).UTF8String, NULL, NULL, NULL);
    }
    
    sqlite3_exec([database sqliteHandle], "PRAGMA encoding=\"UTF-8\"", NULL, NULL, NULL);
    sqlite3_exec([database sqliteHandle], "PRAGMA synchronous=NORMAL", NULL, NULL, NULL);
    sqlite3_exec([database sqliteHandle], "PRAGMA journal_mode=TRUNCATE", NULL, NULL, NULL);
    
    MyDBResultSet *result = [database executeQuery:@"PRAGMA journal_mode"];
    if ([result next])
    {
        NSLog(@"journal_mode = %@", [result stringForColumnIndex:0]);
    }
}

- (bool)isCurrentDatabaseEncrypted
{
    return true;
}

-(void)initDB
{
    [self reopenDB];
    
    [self upgradeTables];
}

-(void)upgradeTables
{
    //        [database executeUpdate:_strfmt(@"CREATE TABLE IF NOT EXISTS %@ (id CHAR(50) PRIMARY KEY, phonesMD5 CHAR(32), nameMD5 CHAR(32), createdAt TIMESTAMP DEFAULT (strftime('%%Y-%%m-%%dT%%H:%%M:%%fZ', 'now')))", db_addressBookSyncTableName)];
}

+(NSString*)getFullFname
{
    return _strfmt(@"%@.%@", self.dbFileName, self.dbFileExtension);
}

+(NSString*)sqliteFilePath
{
    return [helper_file pathInDocumentDIR:[self getFullFname]];
}

+(NSString*)dbFileName
{
    return NSStringFromClass(self);
}

+(NSString*)dbFileExtension
{
    return @"sqlite";
}

-(BOOL)testDB
{
    MyDBResultSet* result = [database executeQuery:@"SELECT count(*) from sqlite_master;"];
    bool success = [result next];
    return success;
}

+(NSString*)dbKey
{
    return [NSStringFromClass(self.class) MD5];
}

@end
