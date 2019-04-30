//
//  helper_connectivity.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 5/19/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "helper_connectivity.h"
#import "helper_hashing.h"
#import "helper.h"
#import "Codebase_definitions.h"
#import "Codebase.h"

//#define _server_URL @"api.mactehran.com"
//#define _Server_API_Port 80
//#define _server_API_PATH @"app"
//#define _server_Protocol @"http"

#ifdef DEBUG
#define _ENV @"development"
#define _NOTIF_TYPE @"dev"
#define _NOTIF_TOKEN_KEY @"notif-token-dev"
#define _NOTIF_TOKEN_REGISTERED_KEY @"notif-token-registered-dev"
#else
#define _ENV @"production"
#define _NOTIF_TYPE @"prod"
#define _NOTIF_TOKEN_KEY @"notif-token-prod"
#define _NOTIF_TOKEN_REGISTERED_KEY @"notif-token-registered-prod"
#endif

typedef enum : NSUInteger {
    ServerTaskMethodPost,
    ServerTaskMethodGet,
    ServerTaskMethodPut,
    ServerTaskMethodDelete,
} ServerTaskMethod;

@implementation helper_connectivity

static NSURLSession* session;

+(void)prepareSession
{
    if (!session)
    {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfig setHTTPMaximumConnectionsPerHost:1];
        
        NSDictionary* appVersions = [helper getAppVersions];
        
        NSString* app_title_string_useragent = _str_safe(_codebaseDic[@"user_agent_title"]);
        
        [sessionConfig setHTTPAdditionalHeaders:@{@"User-Agent": _strfmt(@"%@/%@/%@; %@", app_title_string_useragent, appVersions[@"version"], appVersions[@"build"], _ENV)}];
        
        sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    }
}

+(NSURL*)serverPath:(NSString*)path
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/%@", _codebaseDic[@"connection"][@"server_protocol"], _codebaseDic[@"connection"][@"server_url"], path]];
    
    //	_infoDic(@"codebase.connection.server_protocol");
}

+(NSURL*)serverAPIPath:(NSString*)path
{
    NSString* url = _strfmt(@"%@?rnd=%u", [helper_connectivity serverAPIPathString:path], arc4random() % 100);
    return [NSURL URLWithString:url];
}

+(NSString*)serverAPIPathString:(NSString*)path
{
    
    int server_port = [_codebaseDic[@"connection"][@"server_port"] intValue];
    NSString* port = server_port == 80 ? @"" : [NSString stringWithFormat:@":%d", server_port];
    
    NSString* base =[NSString stringWithFormat:@"%@://%@%@/", _codebaseDic[@"connection"][@"server_protocol"], _codebaseDic[@"connection"][@"server_url"], port];
    
    if (_str_ok2(_codebaseDic[@"connection"][@"server_api_path"]) && ![_codebaseDic[@"connection"][@"server_api_path"] isEqualToString:@"/"])
        base = [base stringByAppendingString:[NSString stringWithFormat:@"%@/", _codebaseDic[@"connection"][@"server_api_path"]]];
    
    if ([path characterAtIndex:0] == '/')
        path = [path substringFromIndex:1];
    
    if (path && path.length && ![path isEqualToString:@"/"])
        base = [base stringByAppendingString:[NSString stringWithFormat:@"%@", path]];
    else
        base = [base substringToIndex:base.length - 2];
    
    return base;
}


+(NSURLSessionDataTask*)downloadWithURL:(NSString*)url_string completionHandler:(void (^)(long response_code, id obj))completionHandler
{
    [self prepareSession];
    NSURL* media_url = [NSURL URLWithString:url_string];
    
    NSURLSessionDataTask* mediaDownloader =
    [session dataTaskWithURL:media_url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         NSHTTPURLResponse* resp = (NSHTTPURLResponse*)response;
         if (resp)
         {
             if (resp.statusCode == 200)
             {
                 completionHandler(resp.statusCode, data);
             }
             else
             {
                 NSLog(@"response error: %@", resp);
                 completionHandler(resp.statusCode, resp);
             }
         }
         else
             completionHandler(0, error);
     }];
    
    return mediaDownloader;
}

+(NSURLSessionDataTask*)serverTaskWithPath:(NSString*)api_path method:(ServerTaskMethod)method postDic:(NSDictionary*)dic putData:(NSData*)data completionHandler:(void (^)(long response_code, id obj))completionHandler
{
    if (!api_path)
        return nil;
    
    [self prepareSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_serverAPIPath(api_path)
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString* req_id = [helper_hashing uniqueDeviceID];
    //    //------------ DELETE THIS
    NSLog(@"UNIQUE ID IS ---> %@ url: %@", req_id, request.URL);
    [request addValue:req_id forHTTPHeaderField:@"x-reqid"];
    
    NSString* token = [DBModel getValueForKey:@"token"];
    
    switch (method) {
        case ServerTaskMethodPost:
        {
            [request setHTTPMethod:@"POST"];
            
            [request addValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
            
            if (dic)
                request.HTTPBody = [helper_hashing hashDictionary:dic];
            
            if (token)
            {
                [request addValue:token forHTTPHeaderField:@"x-token"];
                
                NSString* string2hash = _strfmt(@"%@%lu%@", req_id, request.HTTPBody.length, token);
                
                [request addValue:[helper_hashing hashString:string2hash] forHTTPHeaderField:@"x-hash"];
            }
            else
            {
                NSString* string2hash = _strfmt(@"%@%lu", req_id, request.HTTPBody.length);
                [request addValue:[helper_hashing hashString:string2hash] forHTTPHeaderField:@"x-hash"];
            }
        }
            break;
            
        case ServerTaskMethodDelete:
        {
            [request setHTTPMethod:@"DELETE"];
            
            if (token)
            {
                [request addValue:token forHTTPHeaderField:@"x-token"];
                
                NSString* string2hash = _strfmt(@"%@%lu%@", req_id, request.HTTPBody ? request.HTTPBody.length : 0, token);
                
                [request addValue:[helper_hashing hashString:string2hash] forHTTPHeaderField:@"x-hash"];
            }
            else
            {
                NSString* string2hash = req_id;
                [request addValue:[helper_hashing hashString:string2hash] forHTTPHeaderField:@"x-hash"];
            }
        }
            break;
            
        case ServerTaskMethodGet:
        {
            [request setHTTPMethod:@"GET"];
            
            if (token)
            {
                [request addValue:token forHTTPHeaderField:@"x-token"];
                
                NSString* string2hash = _strfmt(@"%@%@", req_id, token);
                
                [request addValue:[helper_hashing hashString:string2hash] forHTTPHeaderField:@"x-hash"];
            }
            else
            {
                NSString* string2hash = req_id;
                [request addValue:[helper_hashing hashString:string2hash] forHTTPHeaderField:@"x-hash"];
            }
        }
            break;
            
        case ServerTaskMethodPut:
        {
            [request setHTTPMethod:@"PUT"];
            NSString* md5 = [data MD5];
            
            NSLog(@"%@", md5);
            NSString* hash = [helper_hashing hmacForPutDataMD5:md5];
            [request addValue:hash forHTTPHeaderField:@"x-checksum"];
            request.HTTPBody = data;
            
            if (token)
            {
                [request addValue:token forHTTPHeaderField:@"x-token"];
                
                NSString* string2hash = _strfmt(@"%@%lu%@", req_id, request.HTTPBody.length, token);
                
                [request addValue:[helper_hashing hashString:string2hash] forHTTPHeaderField:@"x-hash"];
            }
            else
            {
                NSString* string2hash = _strfmt(@"%@%lu", req_id, request.HTTPBody.length);
                [request addValue:[helper_hashing hashString:string2hash] forHTTPHeaderField:@"x-hash"];
            }
        }
            break;
            
        default:
            NSLog(@"NOT SUPPORTED COMMAND!");
            break;
    }
    
    __block NSURLSessionDataTask* task;
    
    void (^taskCompletionBlock)(NSData*, NSURLResponse*, NSError*) = ^void((NSData *data, NSURLResponse *response, NSError *error)) {
        NSHTTPURLResponse* resp = (NSHTTPURLResponse*)response;
        if (resp)
        {
            if (resp.statusCode == 403) //we need token!!!!!
            {
                //				_defineAppDelegate;
                
                _mainThread(^{
                    //					[theAppDelegate handleInvalidToken];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"codebase_handle_invalid_token" object:nil];
                });
                
                completionHandler(resp.statusCode, nil);
            }
            else if (resp.statusCode == 408)
            {
                //				_defineAppDelegate;
                
                _mainThread(^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"codebase_handle_invalid_hash" object:nil];
                });
                
                completionHandler(resp.statusCode, nil);
            }
            else if (resp.statusCode < 500)
            {
                id jsonDic = [data jsonDic];
                [jsonDic cleanNull];
                if (jsonDic)
                    completionHandler(resp.statusCode, jsonDic);
                else
                {
                    NSLog(@"serverTaskWithPath(%@): Error: %@", [request.URL absoluteString], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    completionHandler(resp.statusCode, nil);
                }
            }
            else
            {
                NSLog(@"response error: %@", resp);
                completionHandler(resp.statusCode, resp);
            }
        }
        else
            completionHandler(0, error);
        task.objectData = nil;
    };
    
    task = [session dataTaskWithRequest:request completionHandler:
            taskCompletionBlock];
    
    NSMutableDictionary* dataObject = [@{@"path": api_path, @"type": @(method)} mutableCopy];
    
    if (dic)
        dataObject[@"postDic"] = dic;
    if (taskCompletionBlock)
        dataObject[@"completionBlock"] = completionHandler;
    if (data)
        dataObject[@"putData"] = data;
    
    
    task.objectData = dataObject;
    
    return task;
}

+(NSURLSessionTask*)createRetryTaskForTask:(NSURLSessionTask*)task
{
    NSDictionary* dataObject = task.objectData;
    NSString* path = dataObject[@"path"];
    NSUInteger method = [dataObject[@"method"] unsignedIntegerValue];
    NSDictionary* postDic = dataObject[@"postDic"];
    NSData* putData = dataObject[@"putData"];
    id taskCompletion = dataObject[@"completionBlock"];
    
    NSURLSessionTask* newTask = [helper_connectivity serverTaskWithPath:path method:method postDic:postDic putData:putData completionHandler:taskCompletion];
    return newTask;
}

+(NSURLSessionDataTask*)serverDeleteWithPath:(NSString*)api_path andData:(NSData*)data completionHandler:(void (^)(long response_code, id obj))completionHandler
{
    return [self serverTaskWithPath:api_path method:ServerTaskMethodDelete postDic:nil putData:nil completionHandler:completionHandler];
}

+(NSURLSessionDataTask*)serverPutWithPath:(NSString*)api_path andData:(NSData*)data completionHandler:(void (^)(long response_code, id obj))completionHandler
{
    return [self serverTaskWithPath:api_path method:ServerTaskMethodPut postDic:nil putData:data completionHandler:completionHandler];
}

+(NSURLSessionDataTask*)serverGetWithPath:(NSString*)api_path completionHandler:(void (^)(long response_code, id obj))completionHandler
{
    return [self serverTaskWithPath:api_path method:ServerTaskMethodGet postDic:nil putData:nil completionHandler:completionHandler];
}

+(NSURLSessionDataTask*)serverPostWithPath:(NSString*)api_path bodyDic:(NSDictionary*)dic completionHandler:(void (^)(long response_code, id obj))completionHandler
{
    return [self serverTaskWithPath:api_path method:ServerTaskMethodPost postDic:dic putData:nil completionHandler:completionHandler];
}
@end
