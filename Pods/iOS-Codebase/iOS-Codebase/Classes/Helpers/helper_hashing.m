//
//  helper_hashing.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 5/19/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "helper_hashing.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSObject+jsonStr.h"
#import "DBModel.h"
#import "NSObject+SHA1.h"
#import "Codebase_definitions.h"

#define _hash_key1 @"XNkaSIsJ3N0YXRlSUQnOjEsJ2xvY2FsVGltZ"
#define _hash_key2 @"2FsVGltZSc6MTIzNCwnY2F0ZWdvcnlJRCc6MSwndHlwZSc6InZp"

@implementation helper_hashing

static NSString* _hash1;
static NSString* _hash2;
+(void)setHash:(NSString*)hash1 hash2:(NSString*)hash2
{
    _hash1 = hash1;
    _hash2 = hash2;
}

+(NSString*)hmacForPutDataMD5:(NSString*)md5
{
    return [helper_hashing hmacForKey:_str_ok2(_hash1) ? _hash1 : _hash_key1 andData:md5];
}

+(NSString*)hmacForKey:(NSString*)key andData:(NSString*)data //hmacsha256 algorithm
{
    NSString * parameters = data;
    NSString *salt = key;
    NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    int cc_length = CC_SHA256_DIGEST_LENGTH;
    CCHmacAlgorithm cc_algorithm = kCCHmacAlgSHA256;
    unsigned char cHMAC[cc_length];
    CCHmac(cc_algorithm, saltData.bytes, saltData.length, paramData.bytes, paramData.length, cHMAC);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:cc_length * 2];
    
    for(int i = 0; i < cc_length; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    return output;
}

+(NSString*)calculateRN
{
    return _str_ok2(_hash2) ? _hash2 : _hash_key2;
}

+(NSData*)hashDictionary:(NSDictionary *)dic
{
    NSString* dicJSON = [dic jsonStr];
    
    NSString* hmac = [helper_hashing hmacForKey:_str_ok2(_hash1) ? _hash1 : _hash_key1 andData:dicJSON];
    
    NSString* body = [NSString stringWithFormat:@"%@.%@", dicJSON, hmac];
    
    return [body dataUsingEncoding:NSUTF8StringEncoding];
}

+(NSString*)hashString:(NSString*)str
{
    NSString* hmac = [helper_hashing hmacForKey:_str_ok2(_hash1) ? _hash1 : _hash_key1 andData:str];
    return hmac;
}

+(NSData*)hashDictionary:(NSDictionary *)dic andKey:(NSString*)key
{
    NSString* dicJSON = [dic jsonStr];
    
    NSString* hmac = [helper_hashing hmacForKey:key andData:dicJSON];
    
    NSString* body = [NSString stringWithFormat:@"%@.%@", dicJSON, hmac];
    
    return [body dataUsingEncoding:NSUTF8StringEncoding];
}

+(NSString*)hashString:(NSString*)str andKey:(NSString*)key
{
    NSString* hmac = [helper_hashing hmacForKey:key andData:str];
    return hmac;
}

static NSString* cached_udid;
static NSLock* request_id_lock;
+(NSString*)uniqueDeviceID
{
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        request_id_lock = [NSLock new];
    });
    
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        cached_udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    });
    
    [request_id_lock lock];
    
//    NSNumber* req_seq_id = _loadPref(@"request-sequence-id");
    NSNumber* req_seq_id =  [DBModel getValueForKey:@"request-sequence-id"];
    if (!req_seq_id)
        req_seq_id = @(0);
    else
        req_seq_id = @(req_seq_id.intValue + 1);
//    _savePref(req_seq_id, @"request-sequence-id");
    [DBModel updateValue:req_seq_id forKey:@"request-sequence-id"];
    [request_id_lock unlock];
    
    NSString* string2hash = [cached_udid stringByAppendingFormat:@"-%@", req_seq_id];
    
    NSLog(@"uniqueDeviceID---> SEQUENCE: %@ FINAL_REQ_ID: %@", req_seq_id, [string2hash SHA1]);
    
    return [string2hash SHA1];
}

@end
