//
//  helper_connectivity.h
//  Prediscore
//
//  Created by Hamidreza Vaklian on 5/19/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _serverAPIPath(path) [helper_connectivity serverAPIPath:path]
#define _serverAPIPathString(path) [helper_connectivity serverAPIPathString:path]
#define _serverPath(path) [helper_connectivity serverPath:path]

@interface helper_connectivity : NSObject

+(NSURL*)serverAPIPath:(NSString*)path;
//----------------------
//+(NSURLSessionDataTask*)serverGetWithPath:(NSString*)api_path loadToken:(BOOL)load_token completionHandler:(void (^)(NSDictionary* jsonDic))completionHandler;
//+(NSURLSessionDataTask*)serverGetWithPath:(NSString*)api_path loadToken:(BOOL)load_token session:(NSURLSession*)asession completionHandler:(void (^)(NSDictionary* jsonDic))completionHandler;
//+(NSURLSessionDataTask*)serverPostWithPath:(NSString*)api_path bodyDic:(NSDictionary*)dic completionHandler:(void (^)(long response_code, id obj))completionHandler;
+(NSURLSessionDataTask*)downloadWithURL:(NSString*)url_string completionHandler:(void (^)(long response_code, id obj))completionHandler;
//----------------------------------------
+(NSURLSessionDataTask*)serverGetWithPath:(NSString*)api_path completionHandler:(void (^)(long response_code, id obj))completionHandler;
+(NSURLSessionDataTask*)serverPostWithPath:(NSString*)api_path bodyDic:(NSDictionary*)dic completionHandler:(void (^)(long response_code, id obj))completionHandler;
+(NSURLSessionDataTask*)serverPutWithPath:(NSString*)api_path andData:(NSData*)data completionHandler:(void (^)(long response_code, id obj))completionHandler;
+(NSURLSessionDataTask*)serverDeleteWithPath:(NSString*)api_path andData:(NSData*)data completionHandler:(void (^)(long response_code, id obj))completionHandler;

+(NSURLSessionTask*)createRetryTaskForTask:(NSURLSessionTask*)task;
@end
