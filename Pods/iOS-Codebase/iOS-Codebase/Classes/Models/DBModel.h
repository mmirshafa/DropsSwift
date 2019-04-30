//
//  DBModel.h
//  Prediscore
//
//  Created by Hamidreza Vaklian on 5/26/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SQLCipher/sqlite3.h>

@interface DBModel : NSObject

+(id)getValueForKey:(NSString *)key;
+(BOOL)updateValue:(id)value forKey:(NSString *)key;
+(BOOL)deleteValueForKey:(NSString*)key;

+(BOOL)deleteAllPermissions;
+(BOOL)addPermission:(NSString*)value;
+(BOOL)hasPermission:(NSString *)permission;

+ (BOOL)purgeTable;
+ (sqlite3*)get_db;
+(int)modelVersion;
+(NSString*)sqliteFilePath;
@end
