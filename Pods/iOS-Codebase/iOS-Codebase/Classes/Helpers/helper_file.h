//
//  FileManagement.h
//  RAS
//
//  Created by Hamidreza Vakilian on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define temp_size_for_concatenate 1*1000000 //this valuse is the nsdata length used to concatenate files in concatenateFilesWithFileNames:: . the more value the faster combination of files and more memory usage (consider it for devices with limited RAM)

#define FILE_MD5_CHUNK_SIZE 1024*1024

@interface helper_file : NSObject

+(NSUInteger)fileSizeAtPath:(NSString*)path;
+ (NSString*)fileMD5:(NSString*)path;
+ (NSString *)stringByDecodingURLFormat:(NSString*) str;
+ (NSString*)pathInDocumentDIR:(NSString*)filename;
+ (NSString*)pathInLibraryDIR:(NSString*)filename;
+ (NSString*)documentDIR;
+ (NSString*)LibraryDIR;
+(BOOL)directoryExistsAtPath:(NSString*)path;
+ (BOOL)pathExistInDocumentsDIR:(NSString*) path;
+ (BOOL)pathExistInLibraryDIR:(NSString*) path;
+ (BOOL)createDIRInDocumentDir:(NSString*)DIRName;
+(BOOL)createDIRAtPath:(NSString*)path;
+ (BOOL)createDIRInLibraryDir:(NSString*)DIRName;
+ (NSString*)forceCreateDIRInLibraryDIR:(NSString*)DIRName;//if a dir exists with the same name, an _## prefix will be added to the new DIR name so that there will be no conflicts
+ (NSString*)createFileWithUUIDInLibraryDIR:(NSString*)DIRName;
+ (NSString*)createUUID;
+ (uint64_t) concatenateFilesWithFileNames:(NSArray*) filenames ToDestinationFileName: (NSString*) destinationfilename;//concatenate files with filenames in the NSArray; returns the number of total bytes concatenated; set temp_size_for_concatenate for the buffer size ;)
+ (NSArray*) filePathsAtPath: (NSString*) path WhichContainString: (NSString*) con;
+ (BOOL) validateUrl: (NSString *) candidate;
+ (NSString*) extractFileNameFromPath: (NSString*) path;
+ (NSString*) prepareUUIDForFileCreationInPath: (NSString*) path WithFileExtention: (NSString*) ext;

+(NSString*) detectPayLoadNameFromURL: (NSString*) url;//fetchgroup
+(BOOL) URLisDownloadLink:(NSString*) url;
@end
