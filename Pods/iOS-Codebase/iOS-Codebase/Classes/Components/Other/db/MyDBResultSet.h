//
//  DFResultSet.h
//  deepfinity
//
//  Created by Hamidreza Vakilian on 10/28/1396 AP.
//  Copyright © 1396 nizek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyBaseDB;
@class DFStatement;

@interface MyDBResultSet : NSObject {
    MyBaseDB          *_parentDB;
    DFStatement         *_statement;
    
    NSString            *_query;
    NSMutableDictionary *_columnNameToIndexMap;
    BOOL                _columnNamesSetup;
}

@property (nonatomic, retain) NSString *query;
@property (nonatomic, retain) NSMutableDictionary *columnNameToIndexMap;
@property (nonatomic, retain) DFStatement *statement;


/**
 default: false; affects objectForColumnName, objectForColumnIndex, resultDictionary
 */
@property (assign, nonatomic) BOOL returnNSNullInsteadOfNaN;

+ (id)resultSetWithStatement:(DFStatement *)statement usingParentDatabase:(MyBaseDB*)aDB;

- (void)close;

- (void)setParentDB:(MyBaseDB *)newDb;

- (BOOL)next;
- (BOOL)hasAnotherRow;

- (int)columnCount;

- (int)columnIndexForName:(NSString*)columnName;
- (NSString*)columnNameForIndex:(int)columnIdx;

- (int)intForColumn:(NSString*)columnName;
- (int)intForColumnIndex:(int)columnIdx;

- (long)longForColumn:(NSString*)columnName;
- (long)longForColumnIndex:(int)columnIdx;

- (long long int)longLongIntForColumn:(NSString*)columnName;
- (long long int)longLongIntForColumnIndex:(int)columnIdx;

- (unsigned long long int)unsignedLongLongIntForColumn:(NSString*)columnName;
- (unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIdx;

- (BOOL)boolForColumn:(NSString*)columnName;
- (BOOL)boolForColumnIndex:(int)columnIdx;

- (double)doubleForColumn:(NSString*)columnName;
- (double)doubleForColumnIndex:(int)columnIdx;

- (NSString*)stringForColumn:(NSString*)columnName;
- (NSString*)stringForColumnIndex:(int)columnIdx;

- (NSDate*)dateForColumn:(NSString*)columnName;
- (NSDate*)dateForColumnIndex:(int)columnIdx;

- (NSData*)dataForColumn:(NSString*)columnName;
- (NSData*)dataForColumnIndex:(int)columnIdx;

- (const unsigned char *)UTF8StringForColumnIndex:(int)columnIdx;
- (const unsigned char *)UTF8StringForColumnName:(NSString*)columnName;

// returns one of NSNumber, NSString, NSData, or NSNull
- (id)objectForColumnName:(NSString*)columnName;
- (id)objectForColumnIndex:(int)columnIdx;

/*
 If you are going to use this data after you iterate over the next row, or after you close the
 result set, make sure to make a copy of the data first (or just use dataForColumn:/dataForColumnIndex:)
 If you don't, you're going to be in a world of hurt when you try and use the data.
 */
- (NSData*)dataNoCopyForColumn:(NSString*)columnName NS_RETURNS_NOT_RETAINED;
- (NSData*)dataNoCopyForColumnIndex:(int)columnIdx NS_RETURNS_NOT_RETAINED;

- (BOOL)columnIndexIsNull:(int)columnIdx;
- (BOOL)columnIsNull:(NSString*)columnName;


/* Returns a dictionary of the row results mapped to case sensitive keys of the column names. */
- (NSMutableDictionary*)resultDictionary;

/* Please use resultDictionary instead.  Also, beware that resultDictionary is case sensitive! */
- (NSDictionary*)resultDict  __attribute__ ((deprecated));

- (void)kvcMagic:(id)object;

- (unsigned long)unsignedLongForColumn:(NSString*)columnName;
- (unsigned long)unsignedLongForColumnIndex:(int)columnIdx;
@end
