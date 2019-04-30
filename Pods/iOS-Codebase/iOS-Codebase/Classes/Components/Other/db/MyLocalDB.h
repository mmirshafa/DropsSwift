//
//  MyLocalDB.h
//  oncost
//
//  Created by Hamidreza Vakilian on 3/21/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyBaseDB.h"
#import "MySerialQueue.h"
#import "MyDBResultSet.h"
#import "MySharedService.h"

@interface MyLocalDB : MySharedService
{
    @protected
    MyBaseDB* database;
    MySerialQueue* serialQ;
}


/**
 This method is called on this Class's serialQ.
 */
-(void)upgradeTables;


/**
 if encryption is enabled or not, you can use this method to test if you can read from the DB.

 @return success status
 */
-(BOOL)testDB;


/**
 Determines if the DB must be treated as encrypted or not. WARNING: You shouldn't change this value across app sessions, since this class currently doesn't support migrating from encrypt<->unencrypted database.

 @return should encrypt boolean
 */
- (bool)isCurrentDatabaseEncrypted;


/**
 detabase encryption key

 @return encryption key for the database. if you don't override it, it will use the MD5 of the current class string.
 */
+(NSString*)dbKey;
@end
