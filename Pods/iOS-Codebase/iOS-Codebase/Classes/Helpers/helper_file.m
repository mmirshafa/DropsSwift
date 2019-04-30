//
//  FileManagement.m
//  RAS
//
//  Created by Hamidreza Vakilian on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "helper_file.h"
#include <CommonCrypto/CommonDigest.h>

@implementation helper_file

- (id)init
{
	self = [super init];
	if (self) {
		// Initialization code here.
	}
	
	return self;
}

+(NSString*)fileMD5:(NSString*)path
{
	NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
	if( handle== nil ) return @"ERROR GETTING FILE MD5"; // file didnt exist
	
	CC_MD5_CTX md5;
	
	CC_MD5_Init(&md5);
	
	BOOL done = NO;
	while(!done)
	{
		@autoreleasepool {
			NSData* fileData = [handle readDataOfLength: FILE_MD5_CHUNK_SIZE ];
			CC_MD5_Update(&md5, [fileData bytes], (uint32_t)[fileData length]);
			if( [fileData length] == 0 ) done = YES;
		}
	}
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5_Final(digest, &md5);
	NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				   digest[0], digest[1],
				   digest[2], digest[3],
				   digest[4], digest[5],
				   digest[6], digest[7],
				   digest[8], digest[9],
				   digest[10], digest[11],
				   digest[12], digest[13],
				   digest[14], digest[15]];
	return s;
}

//+ (NSMutableDictionary*)eMenu_getConfigPlist
//{
//	NSString *_path = [preferences_DIR stringByAppendingPathComponent:preferences_plist_name];
//	return [NSMutableDictionary dictionaryWithContentsOfFile:_path];
//}
//
//+(NSString*)eMenu_configPlistPath
//{
//	NSString *_path = [preferences_DIR stringByAppendingPathComponent:preferences_plist_name];
//	return _path;
//}

+ (NSString *)pathInDocumentDIR:(NSString*)path
{
	NSString *_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	return [_path stringByAppendingPathComponent:path];
}

//+(NSString*)eMenu_pathInDataDIR:(NSString*)path
//{
//	return [eMenu_Data_DIR stringByAppendingPathComponent:path];
//}
//
//+(NSString*)eMenu_pathInDocumentDIR:(NSString*)path
//{
//	NSString *_path = [eMenu_Data_DIR stringByAppendingPathComponent:@"Documents"];
//	return [_path stringByAppendingPathComponent:path];
//}

+ (NSString *)pathInLibraryDIR:(NSString*)path
{
	NSString *_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
	return [_path stringByAppendingPathComponent:path];
	
	//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	//    NSString *LibraryDirectory = [paths objectAtIndex:0];
	//    return [LibraryDirectory stringByAppendingPathComponent:path];
	
}

+ (NSString *)LibraryDIR
{
	NSString *_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
	return _path;
	
	//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	//    return [paths objectAtIndex:0];
}


+ (NSString *)documentDIR
{
	NSString *_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	return _path;
	
	//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//    return [paths objectAtIndex:0];
}

+ (BOOL) pathExistInDocumentsDIR:(NSString*) path
{
	BOOL isDIR;
	
	if (! [[NSFileManager defaultManager] fileExistsAtPath:[helper_file pathInDocumentDIR:path] isDirectory:&isDIR] )
		return false; ////no file or directory exist with name: "images"
	else
		return true;
}

+(NSUInteger)fileSizeAtPath:(NSString*)path
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (!error && attrs) {
        return [attrs[@"NSFileSize"] unsignedIntegerValue];
    }
    
    return 0;
}

+ (BOOL) pathExistInLibraryDIR:(NSString*) path
{
	BOOL isDIR;
	
	if (! [[NSFileManager defaultManager] fileExistsAtPath:[helper_file pathInLibraryDIR:path] isDirectory:&isDIR] )
		return false; ////no file or directory exist with name: "images"
	else
		return true;
}

+ (BOOL)createDIRInDocumentDir:(NSString*)DIRName
{
	BOOL res = [[NSFileManager defaultManager] createDirectoryAtPath:[self pathInDocumentDIR:DIRName] withIntermediateDirectories:YES attributes:nil error:nil] ;
	
	return res;
}

+(BOOL)createDIRAtPath:(NSString*)path
{
	BOOL res = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil] ;
	
	return res;
}

//+ (BOOL)eMenu_createDIRInDocumentDir:(NSString*)DIRName
//{
//	if (![FileManagement eMenu_pathExistInDocumentsDIR:DIRName])
//	{
//		BOOL res = [[NSFileManager defaultManager] createDirectoryAtPath:[self eMenu_pathInDocumentDIR:DIRName] withIntermediateDirectories:YES attributes:nil error:nil];
//		[FileManagement eMenu_resetPermissionsOnDataDIR];
//		return res;
//	}
//	else
//		return YES;
//}

//+(BOOL)eMenu_resetPermissionsOnDataDIR
//{
//	return [FileManagement eMenu_executeSystemCommand:[NSString stringWithFormat:@"chmod -R 777 %@", eMenu_Data_DIR]];
//}
//
//+(BOOL)eMenu_executeSystemCommand:(NSString*)cmd
//{
//	return (!system([[NSString stringWithFormat:@"echo alpine | su -c \"%@\"", cmd] cStringUsingEncoding:NSASCIIStringEncoding]));
//}

+ (BOOL)createDIRInLibraryDir:(NSString*)DIRName
{
	
	BOOL res = [[NSFileManager defaultManager] createDirectoryAtPath:[self pathInLibraryDIR:DIRName] withIntermediateDirectories:YES attributes:nil error:nil] ;
	
	return res;
}

+ (NSString*) prepareUUIDForFileCreationInPath: (NSString*) path WithFileExtention: (NSString*) ext
{
	NSString* uuid;
	
	uuid = [helper_file createUUID];
	
	while ([[NSFileManager defaultManager] fileExistsAtPath: [NSString stringWithFormat:@"%@/%@.%@", path, uuid, ext]]) {
		uuid = [helper_file createUUID];
	}
	
	return uuid;
	
}

+ (NSString*)forceCreateDIRInLibraryDIR:(NSString*)DIRName
{
	BOOL DIR_exists;
	DIR_exists = [[NSFileManager defaultManager] fileExistsAtPath:[self pathInLibraryDIR:DIRName]];
	
	if (!DIR_exists) {
		if([self createDIRInLibraryDir:DIRName])
			return [self pathInLibraryDIR:DIRName];
		else
			return @"";
	}
	else
	{
		NSMutableString* newDIRName = [DIRName mutableCopy];
		
		for (int i = 0; i != 1000; i++) {
			[newDIRName setString:[NSString stringWithFormat:@"%@_%03d", DIRName, i+1]];
			if (![[NSFileManager defaultManager] fileExistsAtPath:[self pathInLibraryDIR:newDIRName]]) {
				if ([self createDIRInLibraryDir:newDIRName])
					return [self pathInLibraryDIR:newDIRName];
				else
					return @"";
			}
		}
		
		return @"";
	}
	
}

+ (NSString*) createUUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	//    NSString* result = (__bridge NSString *)string;
	//    CFRelease(string);
	return (__bridge NSString*)string;
}

+ (NSString*)createFileWithUUIDInLibraryDIR:(NSString*)DIRName
{
	NSString* filename = [self createUUID];
	
	while ([self pathExistInLibraryDIR:[NSString stringWithFormat:@"%@/%@.plist", DIRName, filename]] ) {
		filename = [self createUUID];
	}
	
	if ([[NSFileManager defaultManager] createFileAtPath:[helper_file pathInLibraryDIR: [NSString stringWithFormat:@"%@/%@.plist", DIRName, filename]] contents:nil attributes:nil]) {
		return [helper_file pathInLibraryDIR: [NSString stringWithFormat:@"%@/%@.plist", DIRName, filename]];
	}
	else
	{
		NSLog(@"ERROR in FileManagement->createFileWithUUIDInLibraryDIR");
		return @"?";
	}
	
	
	
}

+(uint64_t) concatenateFilesWithFileNames:(NSArray*) filenames ToDestinationFileName: (NSString*) destinationfilename;
{
	[[NSFileManager defaultManager] createFileAtPath:destinationfilename contents:nil attributes:nil];
	NSFileHandle* destinationFileHandle = [NSFileHandle fileHandleForWritingAtPath:destinationfilename];
	
	for (NSString* filename in filenames)
	{
		NSFileHandle* tempfilehandle = [NSFileHandle fileHandleForReadingAtPath:filename];
		uint64_t end = [tempfilehandle seekToEndOfFile];//holding the size of the current file under concatenation
		[tempfilehandle seekToFileOffset:0];
		
		while (tempfilehandle.offsetInFile < end)
		{
			@autoreleasepool {
				NSData* temp = [tempfilehandle readDataOfLength: temp_size_for_concatenate];
				[destinationFileHandle truncateFileAtOffset:[destinationFileHandle seekToEndOfFile]];
				[destinationFileHandle writeData:temp];
			}
		}
		
		[tempfilehandle closeFile];
	}
	
	uint64_t result = [destinationFileHandle offsetInFile];
	
	[destinationFileHandle closeFile];
	
	return result;
}

+(NSArray*) filePathsAtPath: (NSString*) path WhichContainString: (NSString*) con
{
	NSArray* dir_contents_names = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
	
	if (!dir_contents_names) { NSLog(@"ERROR in FileManagement: filePathsAtPath"); return nil; }
	NSString* predicate_cmd = [NSString stringWithFormat:@"self CONTAINS '%@'", con];
	dir_contents_names = [dir_contents_names filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicate_cmd]];
	NSMutableArray* filepaths = [[NSMutableArray alloc] init];
	
	for (NSString* a_name in dir_contents_names) {
		[filepaths addObject: [NSString stringWithFormat:@"%@/%@", path, a_name] ];
	}
	
	return filepaths;
}

+(NSString*) extractFileNameFromPath: (NSString*) path
{
	NSString* fullFileName = [[path componentsSeparatedByString:@"/"] lastObject];
	return [[fullFileName componentsSeparatedByString:@"."] objectAtIndex:0];//separating the name from the fullFileName
}

+(BOOL) validateUrl: (NSString *) candidate
{
	return YES;
//	NSString *urlRegEx =
//	@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
//	NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
//	return [urlTest evaluateWithObject:candidate];
}

+(BOOL)directoryExistsAtPath:(NSString *)path
{
	BOOL isDir;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
	if (exists && isDir) {
		return YES;
 }
	return NO;
}

+(NSString*) detectPayLoadNameFromURL: (NSString*) url
{
	//////TO DO: file name here is temporary for now! because encoded urls does not work this way!!!
	NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"[^/?<>\\:*|”.=]+\\.[^/?<>\\:*|”]+$" options:NSRegularExpressionCaseInsensitive error:nil];
	NSTextCheckingResult* result = [regex firstMatchInString:url options:0 range:NSMakeRange(0, [url length])];
	
	return [url substringWithRange:result.range];
}

+(BOOL) URLisDownloadLink:(NSString*) url
{
	
	NSString* fname = [helper_file detectPayLoadNameFromURL:url];
	NSArray* fname_parts = [fname componentsSeparatedByString:@"."];
	if ([fname_parts count] < 2) return false;//because there is no extension; so we cannot make sure whether it is a download link or not
	
	NSPredicate* predic = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^([^:])+\\.([^:])+$"];
	if (![predic evaluateWithObject:fname]) return false;
	
	NSArray* web_extensions = [[NSArray alloc] initWithObjects:@"htm", @"html", @"php", nil];
	if (![web_extensions containsObject:[[fname_parts lastObject] lowercaseString]])//this is not a webpage; we consider it a download link
	{ NSLog(@"\n %@ \n %@ \n", url, fname);return true;}
	return false;
	
	
	
}

+(NSString *)stringByDecodingURLFormat:(NSString*) str
{
	NSString *result = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
	result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return result;
}


@end

