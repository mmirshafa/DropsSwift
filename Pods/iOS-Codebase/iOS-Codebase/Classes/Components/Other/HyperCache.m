//
//  HyperCache.m
//  Aiywa2
//
//  Created by hAmidReza on 2/17/17.
//  Copyright © 2017 nizek. All rights reserved.
//

#import "HyperCache.h"
#import "HyperCacheModel.h"
#import "Codebase_definitions.h"
#import "NSObject+MD5.h"
#import "NSObject+DataObject.h"
#import "helper.h"
#import "UIView+SDCAutoLayout.h"
#import "HyperPool.h"
#import "helper_file.h"

typedef enum : NSUInteger {
    HyperCacheOptionsIsImageTask = 0,
    HyperCacheOptionsImageView = 1 << 0,
} HyperCacheOptions;

#define _taskDic_callbacks_key @"__callbacks"
#define _taskDic_linkedImageViews_key @"__linkedImageViews"

#define _general_cache_dir_name @"__all__"

//ANIMATION CONSTANTS
#define _setImage_default_animation_enabled    YES
#define _setImage_default_should_fade        YES
#define _setImage_default_should_enlarge    YES
#define _setImage_default_duration            .30f
#define _setImage_default_fade_fromValue    0.0f
#define _setImage_default_enlarge_fromValue 1.3

//#define _hypercache_debug
//#define _hypercache_debug_verbose

#ifndef _hypercache_debug
#define _callback_safe(status, obj) if(callback) callback(status, obj);
#else
#define _callback_safe(status, obj) NSLog(@"[HYPERCACHE] STATUS: %@", [HyperCache stringFromHyperCacheStatus:status]);if(callback) callback(status, obj);
#endif

#define _default_task_priority    NSURLSessionTaskPriorityDefault




typedef enum : NSUInteger {
    HyperCacheCallbackModeDefault, //returns NSData; if the type is image, returns uiimage
    HyperCacheCallbackModeFile, //returns the path of the downloaded file
} HyperCacheCallbackMode;


@interface NSString (Paths)

- (NSString*)stringWithPathRelativeTo:(NSString*)anchorPath;

@end

@implementation NSString (Paths)

- (NSString*)stringWithPathRelativeTo:(NSString*)anchorPath {
    NSArray *pathComponents = [self pathComponents];
    NSArray *anchorComponents = [anchorPath pathComponents];
    
    NSInteger componentsInCommon = MIN([pathComponents count], [anchorComponents count]);
    for (NSInteger i = 0, n = componentsInCommon; i < n; i++) {
        if (![[pathComponents objectAtIndex:i] isEqualToString:[anchorComponents objectAtIndex:i]]) {
            componentsInCommon = i;
            break;
        }
    }
    
    NSUInteger numberOfParentComponents = [anchorComponents count] - componentsInCommon;
    NSUInteger numberOfPathComponents = [pathComponents count] - componentsInCommon;
    
    NSMutableArray *relativeComponents = [NSMutableArray arrayWithCapacity:
                                          numberOfParentComponents + numberOfPathComponents];
    for (NSInteger i = 0; i < numberOfParentComponents; i++) {
        [relativeComponents addObject:@".."];
    }
    [relativeComponents addObjectsFromArray:
     [pathComponents subarrayWithRange:NSMakeRange(componentsInCommon, numberOfPathComponents)]];
    return [NSString pathWithComponents:relativeComponents];
}

@end

@implementation HyperCache

+(NSString *)stringFromHyperCacheStatus:(HyperCacheStatus)status
{
    NSMutableString* str = [NSMutableString new];
    
    if ((status & HyperCacheStatusInvalidURL) == HyperCacheStatusInvalidURL)
        [str appendFormat:@"%@ | ", @"HyperCacheStatusInvalidURL"];
    
    if ((status & HyperCacheStatusCacheFoundButFileError) == HyperCacheStatusCacheFoundButFileError)
        [str appendFormat:@"%@ | ", @"HyperCacheStatusCacheFoundButFileError"];
    
    if ((status & HyperCacheStatusReadFromCache) == HyperCacheStatusReadFromCache)
        [str appendFormat:@"%@ | ", @"HyperCacheStatusReadFromCache"];
    
    if ((status & HyperCacheStatusSuccess) == HyperCacheStatusSuccess)
        [str appendFormat:@"%@ | ", @"HyperCacheStatusSuccess"];
    
    if ((status & HyperCacheStatusFailure) == HyperCacheStatusFailure)
        [str appendFormat:@"%@ | ", @"HyperCacheStatusFailure"];
    
    if ((status & HyperCacheStatusDownloaded) == HyperCacheStatusDownloaded)
        [str appendFormat:@"%@ | ", @"HyperCacheStatusDownloaded"];
    
    if ((status & HyperCacheStatusCached) == HyperCacheStatusCached)
        [str appendFormat:@"%@ | ", @"HyperCacheStatusCached"];
    
    if ((status & HyperCacheStatusConnectionError) == HyperCacheStatusConnectionError)
        [str appendFormat:@"%@ | ", @"HyperCacheStatusConnectionError"];
    
    if ((status & HyperCacheStatusWillStartFetch) == HyperCacheStatusWillStartFetch)
        [str appendFormat:@"%@ | ", @"HyperCacheStatusWillStartFetch"];
    
    if ((status & HyperCacheStatusUsedFailoverImage) == HyperCacheStatusUsedFailoverImage)
        [str appendFormat:@"%@ | ", @"HyperCacheStatusUsedFailoverImage"];
    
    if ((status & HyperCacheStatusIsBeingDownloaded) == HyperCacheStatusIsBeingDownloaded)
        [str appendFormat:@"%@ | ", @"HyperCacheStatusIsBeingDownloaded"];
    
    [str deleteCharactersInRange:NSMakeRange(str.length-3, 2)];
    
    return str;
}

/*************     sssss ******/
/*
 "http://www.aiywa.com/thumbnail.ashx?Size=300&Cat=c&Image=files/categories/12_040617164955842.jpg" =     {
 "__callbacks" =         (
 "<__NSMallocBlock__: 0x608000453e30>"
 );
 "__linkedImageViews" =         (
 0x7f8dc6c836e0
 );
 task = "<__NSCFLocalDataTask: 0x7f8dc6c8a070>{ taskIdentifier: 45 } { running }";
 url = "http://www.aiywa.com/thumbnail.ashx?Size=300&Cat=c&Image=files/categories/12_040617164955842.jpg";
 };
 */
+(NSMutableDictionary*)ongoingTasks
{
    static NSMutableDictionary* ongoingTasks;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ongoingTasks = [NSMutableDictionary new];
    });
    return ongoingTasks;
}

+(NSMutableDictionary*)imageViewCallbacks
{
    static NSMutableDictionary* imageViewCallbacks;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageViewCallbacks = [NSMutableDictionary new];
    });
    return imageViewCallbacks;
}

+(NSURLSession*)session
{
    static NSURLSession* session;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    });
    return session;
}


+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    return [HyperCache DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:nil postprocessBlock:nil callbackMode:HyperCacheCallbackModeDefault group:nil tag:nil ttl:0 cacheOptions:HyperCachePolicyDefault priority:NSURLSessionTaskPriorityDefault callback:callback];
}

+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag imagePreprocessorBlock:(UIImage* (^)(UIImage*))imagePreprocessorBlock priority:(float)priority group:(NSString*)group callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    return [HyperCache DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:imagePreprocessorBlock postprocessBlock:nil callbackMode:HyperCacheCallbackModeDefault group:group tag:tag ttl:0 cacheOptions:HyperCachePolicyDefault priority:priority callback:callback];
}

+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag imagePreprocessorBlock:(UIImage* (^)(UIImage*))imagePreprocessorBlock priority:(float)priority callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    return [HyperCache DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:imagePreprocessorBlock postprocessBlock:nil callbackMode:HyperCacheCallbackModeDefault group:nil tag:tag ttl:0 cacheOptions:HyperCachePolicyDefault priority:priority callback:callback];
}


+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag imagePreprocessorBlock:(UIImage* (^)(UIImage*))imagePreprocessorBlock callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    return [HyperCache DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:imagePreprocessorBlock postprocessBlock:nil callbackMode:HyperCacheCallbackModeDefault group:nil tag:tag ttl:0 cacheOptions:HyperCachePolicyDefault priority:NSURLSessionTaskPriorityDefault callback:callback];
}

+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    return [HyperCache DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:nil postprocessBlock:nil callbackMode:HyperCacheCallbackModeDefault group:nil tag:tag ttl:0 cacheOptions:HyperCachePolicyDefault priority:NSURLSessionTaskPriorityDefault callback:callback];
}

+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag priority:(float)priority callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    return [HyperCache DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:nil postprocessBlock:nil callbackMode:HyperCacheCallbackModeDefault group:nil tag:tag ttl:0 cacheOptions:HyperCachePolicyDefault priority:priority callback:callback];
}

+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag priority:(float)priority group:(NSString*)group callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    return [HyperCache DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:nil postprocessBlock:nil callbackMode:HyperCacheCallbackModeDefault group:group tag:tag ttl:0 cacheOptions:HyperCachePolicyDefault priority:priority callback:callback];
}

+(void)DownloadFileWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag priority:(float)priority callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [HyperCache DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:nil postprocessBlock:nil callbackMode:HyperCacheCallbackModeFile group:nil tag:tag ttl:0 cacheOptions:HyperCachePolicyDefault priority:priority callback:callback];
}

+(void)DownloadFileWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [HyperCache DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:nil postprocessBlock:nil callbackMode:HyperCacheCallbackModeFile group:nil tag:tag ttl:0 cacheOptions:HyperCachePolicyDefault priority:NSURLSessionTaskPriorityDefault callback:callback];
}

+(void)DownloadFileWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag group:(NSString*)group callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [HyperCache DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:nil postprocessBlock:nil callbackMode:HyperCacheCallbackModeFile group:group tag:tag ttl:0 cacheOptions:HyperCachePolicyDefault priority:NSURLSessionTaskPriorityDefault callback:callback];
}

+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type ttl:(NSUInteger)ttl callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [HyperCache DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:nil postprocessBlock:nil callbackMode:HyperCacheCallbackModeDefault group:nil tag:nil ttl:ttl cacheOptions:HyperCachePolicyDefault priority:NSURLSessionTaskPriorityDefault callback:callback];
}

+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag ttl:(NSUInteger)ttl callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [HyperCache DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:nil postprocessBlock:nil callbackMode:HyperCacheCallbackModeDefault group:nil tag:tag ttl:ttl cacheOptions:HyperCachePolicyDefault priority:NSURLSessionTaskPriorityDefault callback:callback];
}

+(void)cancelTaskWithURL:(NSString*)url mode:(HyperCacheCancelMode)cancelMode
{
    dispatch_async([HyperCache getDispatchQueue], ^{
        NSDictionary* taskDic = [HyperCache ongoingTasks][url];
        [HyperCache cancelTask:taskDic mode:cancelMode];
    });
}

+(void)cancelTaskWithImageView:(UIImageView*)imgview mode:(HyperCacheCancelMode)cancelMode
{
    dispatch_async([HyperCache getDispatchQueue], ^{
        NSArray* allTasks = [[HyperCache ongoingTasks] allValues];
        NSString* unique_ident = [HyperCache uniqueIdentForImageView:imgview];
        for (NSDictionary* aTaskDic in allTasks)
        {
            if ([aTaskDic[_taskDic_linkedImageViews_key] containsObject:unique_ident] && [aTaskDic[_taskDic_linkedImageViews_key] count] == 1)
                [HyperCache cancelTask:aTaskDic mode:cancelMode];
        }
    });
}

+(void)cancelTask:(NSDictionary*)taskDic mode:(HyperCacheCancelMode)cancelMode
{
    if (!taskDic)
        return;
    
    if (cancelMode == HyperCacheCancelModeKill)
    {
        [taskDic[_taskDic_callbacks_key] removeAllObjects];
        [taskDic[_taskDic_linkedImageViews_key] removeAllObjects];
        [taskDic[@"task"] cancel];
        [HyperCache removeTaskDicFromOngoings:taskDic];
    }
    else if (cancelMode == HyperCacheCancelModeCancelCallback)
    {
        [taskDic[_taskDic_callbacks_key] removeAllObjects];
        [taskDic[_taskDic_linkedImageViews_key] removeAllObjects];
    }
}

+(void)cancelTasksInGroup:(NSString*)group
{
    if (!_str_ok1(group))
        return;
    
    NSArray* ongoingTasks = [[HyperCache ongoingTasks] allValues];
    
    for (NSMutableDictionary* taskDic in ongoingTasks)
        if ([taskDic[@"group"] isEqualToString:group])
        {
            [taskDic[_taskDic_callbacks_key] removeAllObjects];
            [taskDic[_taskDic_linkedImageViews_key] removeAllObjects];
            [taskDic[@"task"] cancel];
            [HyperCache removeTaskDicFromOngoings:taskDic];
        }
}

+(dispatch_queue_t)getDispatchQueue
{
    static dispatch_queue_t dis;
    if (!dis)
        dis = dispatch_queue_create("hypercache_dispatch_queue", DISPATCH_QUEUE_SERIAL);
    return dis;
}

+(void)BatchDownloadWithURLArray:(NSArray*)urls type:(HyperCacheItemType)type callback:(void (^)(HyperCacheBatchStatus status, id obj))callback
{
    [HyperCache BatchDownloadWithURLArray:urls type:type preprocessBlock:nil postprocessBlock:nil callbackMode:HyperCacheCallbackModeDefault group:nil tag:nil ttl:0 cacheOptions:HyperCachePolicyDefault priority:NSURLSessionTaskPriorityDefault callback:callback];
}

+(void)BatchDownloadWithURLArray:(NSArray*)urls type:(HyperCacheItemType)type preprocessBlock:(id (^) (id))preprocessBlock postprocessBlock:(id (^) (id))postprocessBlock callbackMode:(HyperCacheCallbackMode)callbackMode group:(NSString*)group tag:(NSString*)tag ttl:(NSUInteger)ttl cacheOptions:(HyperCachePolicy)cacheOptions priority:(float)priority callback:(void (^)(HyperCacheBatchStatus status, id obj))callback
{
    NSLock* lock = [NSLock new];
    __block int successCount = 0;
    __block int failCount = 0;
    
    NSLock* resultLock = [NSLock new];
    __block BOOL callBackIsCalled = false;
    
    for (NSString* url in urls)
    {
        NSMutableArray* result = [NSMutableArray new];
        [self DownloadWithURL:url type:type isImageTask:NO imageView:nil preprocessBlock:preprocessBlock postprocessBlock:postprocessBlock callbackMode:callbackMode group:nil tag:nil ttl:0 cacheOptions:cacheOptions priority:priority callback:^(HyperCacheStatus status, id obj) {
            [lock lock];
            if ((status & HyperCacheStatusSuccess) == HyperCacheStatusSuccess)
            {
                [url setDataObject:obj forKey:@"payload"];
                successCount++;
            }
            else if ((status & HyperCacheStatusFailure) == HyperCacheStatusFailure)
            {
                [url setDataObject:[NSNull null] forKey:@"payload"];
                failCount++;
            }
            else
            {
                NSLog(@"why here?");
            }
            
            [lock unlock];
            
            if (successCount + failCount == [urls count])
            {
                [resultLock lock];
                
                if (callBackIsCalled)
                    return;
                
                callBackIsCalled = YES;
                for (NSString* url in urls)
                    [result addObject:[url dataObjectForKey:@"payload"]];
                
                if (successCount == 0)
                    callback(HyperCacheBatchStatusAllFailed, result);
                else if (failCount == 0)
                    callback(HyperCacheBatchStatusAllSucceed, result);
                else
                    callback(HyperCacheBatchStatusSuccessWithFailures, result);
                
                [resultLock unlock];
            }
            
        }];
    }
}

//THREAD SAFE
+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type isImageTask:(BOOL)isImageTask imageView:(UIImageView*)imageView preprocessBlock:(id (^) (id))preprocessBlock postprocessBlock:(id (^) (id))postprocessBlock callbackMode:(HyperCacheCallbackMode)callbackMode group:(NSString*)group tag:(NSString*)tag ttl:(NSUInteger)ttl cacheOptions:(HyperCachePolicy)cacheOptions priority:(float)priority callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    if (!_str_ok2(url))
    {
        _callback_safe(HyperCacheStatusFailure | HyperCacheStatusInvalidURL, nil);
        return;
    }
    
    dispatch_async([HyperCache getDispatchQueue], ^{
        
        //CHECK IF WE HAVE CACHED THIS FILE BEFORE
        NSDictionary* cacheItem = [HyperCacheModel cacheItemForURL:url];
        NSString* relativePath = cacheItem[@"path"];
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:relativePath];
        NSUInteger fileSize = [helper_file fileSizeAtPath:path];
        
        if (cacheItem && fileSize > 0)
        {
            // WE MUST DETACH THE IMAGEVIEW FROM IMAGEVIEWCALLBACKS TO AVOID REDUNDANT IMAGE SETTING
            if (isImageTask)
            {
                NSAssert(imageView, @"HyperCache: imageView is null. When imageTask is set to true; you have to provide imageView");
                [HyperCache detachImageViewFromImageViewCallbacks:imageView];
            }
            
            if (callbackMode == HyperCacheCallbackModeDefault)
            {
                NSError* error;
                NSData* data = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:&error];
                if (!error)
                {
                    [HyperCacheModel updateLastAccessTimeWithID:[cacheItem[@"id"] unsignedIntegerValue]];
                    if (type == HyperCacheItemTypeImage)
                    {
                        _backThreadDef(^{
                            UIImage* image = [UIImage imageWithData:data];
                            if (postprocessBlock)
                                image = postprocessBlock(image);
                            _callback_safe(HyperCacheStatusSuccess | HyperCacheStatusReadFromCache, image);
                        });
                    }
                    else if (type == HyperCacheItemTypeData)
                    {
                        _callback_safe(HyperCacheStatusSuccess | HyperCacheStatusReadFromCache, data);
                    }
                }
                else
                {
#ifdef _hypercache_debug_verbose
                    NSLog(@"--> %@", error);
#endif
                    
                    _callback_safe(HyperCacheStatusFailure | HyperCacheStatusCacheFoundButFileError, error);
                }
                
            }
            else if (callbackMode == HyperCacheCallbackModeFile)
            {
                _callback_safe(HyperCacheStatusSuccess | HyperCacheStatusReadFromCache, path);
            }
        }
        else //NO CACHE FOUND FOR THE URL
        {
            NSMutableDictionary* possibleTaskDic = [HyperCache taskForURL:url];
            if (possibleTaskDic) // FOUND AN ONGOING TASK FOR THIS URL, ATTACH THE CALLBACK TO IT
            {
                _callback_safe(HyperCacheStatusIsBeingDownloaded, url);
                
                if (isImageTask) // ATTACH TO IMAGEVIEWCALLBACKS
                {
                    NSAssert(imageView, @"imageview is nil");
                    [HyperCache attachImageView:imageView toTaskDictionary:possibleTaskDic];
                    [HyperCache attachCallbackToImageViewCallbacks:imageView url:possibleTaskDic[@"url"] postprocessBlock:postprocessBlock callback:callback];
                }
                else // ATTACH TO ORDINARY CALLBACKS
                {
                    [HyperCache attachCallback:callback toTaskDictionary:possibleTaskDic];
                }
            }
            else // NO CAHCE, NO ONGOING TASK: WE HAVE TO INITIATE THE TASK
            {
                NSMutableDictionary* taskDic = [HyperCache newTaskDicWithURL:url];
                [HyperCache addTaskDicToOngoings:taskDic withURL:url];
                
                taskDic[@"group"] = group;
                
                if (isImageTask) // ATTACH TO IMAGEVIEWCALLBACKS
                {
                    NSAssert(imageView, @"imageview is nil");
                    [HyperCache attachImageView:imageView toTaskDictionary:taskDic];
                    [HyperCache attachCallbackToImageViewCallbacks:imageView url:taskDic[@"url"] postprocessBlock:postprocessBlock callback:callback];
                }
                else // ATTACH TO ORDINARY CALLBACKS
                {
                    [HyperCache attachCallback:callback toTaskDictionary:taskDic];
                }
                
                _callback_safe(HyperCacheStatusIsBeingDownloaded, url);
                
                NSURLSessionTask* task = [[HyperCache session] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    NSHTTPURLResponse* resp = (NSHTTPURLResponse*)response;
                    if (resp.statusCode == 200 && data.length)
                    {
                        // EXECUTE CALLBACKS
                        id resultObj = data;
                        
                        if (type == HyperCacheItemTypeImage)
                            resultObj = [UIImage imageWithData:data];
                        
                        if (callbackMode == HyperCacheCallbackModeDefault)
                        {
                            if (preprocessBlock)
                            {
                                resultObj = preprocessBlock(resultObj);
                                
                                if (type == HyperCacheItemTypeImage)
                                {
                                    NSAssert([resultObj isKindOfClass:[UIImage class]], @"HyperCache: image preprocessor block didn't return a valid UIImage* object");
                                    
                                    UIImage* theResultingImage = resultObj;
                                    data = UIImageJPEGRepresentation(theResultingImage, 1.0);
                                }
                                
                            }
                        }
                        
                        // WRITE TO DISK
                        NSUInteger fileSize = data.length;
                        
                        NSString* path = [HyperCache determinePathForItemWithTag:tag ttl:ttl fileSize:fileSize url:url];
                        
                        
                        BOOL cached = false;
                        if (cacheOptions == HyperCachePolicyCache)
                        {
                            
                            BOOL writtenSuccessfully = [data writeToFile:path atomically:YES];
                            
                            if (writtenSuccessfully)
                            {
                                NSString* relativePath = [path stringWithPathRelativeTo:NSHomeDirectory()];
                                cached = [HyperCacheModel sync_insertNewCacheItemWithURL:url md5:[url MD5] type:type fileSize:data.length serverContentType:nil ttl:ttl tag:tag path:relativePath];
                            }
                        }
                        
                        dispatch_async([HyperCache getDispatchQueue], ^{
                            
                            
                            if (callbackMode == HyperCacheCallbackModeDefault)
                            {
                                [HyperCache executeCallbacksForTaskWithDic:taskDic status:HyperCacheStatusSuccess | HyperCacheStatusDownloaded | (cached ? HyperCacheStatusCached : 0) andObj:resultObj];
                                
                                [HyperCache executeImageCallbacksForTaskWithDic:taskDic status:HyperCacheStatusSuccess | HyperCacheStatusDownloaded | (cached ? HyperCacheStatusCached : 0) andObj:resultObj];
                            }
                            else if (callbackMode == HyperCacheCallbackModeFile)
                            {
                                NSAssert(cacheOptions == HyperCachePolicyCache, @"HyperCache: <no cache> is not supported when using downloadfile...");
                                
                                [HyperCache executeCallbacksForTaskWithDic:taskDic status:HyperCacheStatusSuccess | HyperCacheStatusDownloaded | (cached ? HyperCacheStatusCached : 0) andObj:path];
                            }
                            
                        });
                    }
                    else
                    {
                        if (error.code == NSURLErrorCancelled)
                        {
                            
                        }
                        else if (error.code == NSURLErrorTimedOut)
                        {
                            NSLog(@"here!!!");
                        }
                        else
                        {
                            dispatch_async([HyperCache getDispatchQueue], ^{
                                [HyperCache executeCallbacksForTaskWithDic:taskDic status:HyperCacheStatusFailure | HyperCacheStatusConnectionError andObj:error];
                                [HyperCache executeImageCallbacksForTaskWithDic:taskDic status:HyperCacheStatusFailure | HyperCacheStatusConnectionError andObj:error];
                            });
                        }
                    }
                    
                    dispatch_async([HyperCache getDispatchQueue], ^{
                        [HyperCache removeTaskDicFromOngoings:taskDic];
                    });
                    
                }];
                
                taskDic[@"task"] = task;
                
                task.priority = priority;
                
                [task resume];
            }
        }
        
    });
}

+(void)addTaskDicToOngoings:(NSDictionary*)taskDic withURL:(NSString*)url
{
    [HyperCache ongoingTasks][url] = taskDic;
}

+(void)removeTaskDicFromOngoings:(NSDictionary*)taskDic
{
    [[HyperCache ongoingTasks] removeObjectForKey:taskDic[@"url"]];
}

+(void)executeCallbacksForTaskWithDic:(NSDictionary*)taskDic status:(HyperCacheStatus)status andObj:(id)obj
{
    //    NSLog(@"%@ %@", NSStringFromSelector(_cmd), [self ongoingTasks]);
    NSMutableArray* callbacks = taskDic[_taskDic_callbacks_key];
    for (void (^cb)(HyperCacheStatus status, id obj) in callbacks)
    {
        cb(status, obj);
    }
}

+(void)executeImageCallbacksForTaskWithDic:(NSDictionary*)taskDic status:(HyperCacheStatus)status andObj:(id)obj
{
    //    NSLog(@"%@ %@", NSStringFromSelector(_cmd), [self ongoingTasks]);
    NSMutableDictionary* imageViewCallbacks = [HyperCache imageViewCallbacks];
    NSMutableArray* linkedImageViews = taskDic[_taskDic_linkedImageViews_key];
    for (NSString* imageViewIdent in linkedImageViews) {
        if (imageViewCallbacks[imageViewIdent] && [imageViewCallbacks[imageViewIdent][@"url"] isEqualToString:taskDic[@"url"]])
        {
            void (^cb)(HyperCacheStatus status, id obj) = imageViewCallbacks[imageViewIdent][@"callback"];
            
            if (_block_ok(imageViewCallbacks[imageViewIdent][@"postprocessBlock"]) && _uiimage_ok(obj))
            {
                UIImage* (^postprocess)(UIImage*) = imageViewCallbacks[imageViewIdent][@"postprocessBlock"];
                obj = postprocess(obj);
            }
            
            cb(status, obj);
            [imageViewCallbacks removeObjectForKey:imageViewIdent];
        }
    }
}

// IT ALSO PREPARES THE DIRECTORY WHICH THE FILE WILL BE SAVED IN
+(NSString*)determinePathForItemWithTag:(NSString*)tag ttl:(NSUInteger)ttl fileSize:(NSUInteger)fileSize url:(NSString*)url
{
    //preserve extension for file mode
    NSString* filename = _strfmt(@"%@.%@", [url MD5], [url pathExtension]);
    
    if (_str_ok2(tag))
    {
        [HyperCache createDirectoryInCachesDIR:tag];
        NSString* destDIRPath = [HyperCache pathInCachesDIR:tag];
        NSString* path = [destDIRPath stringByAppendingPathComponent:filename];
        return path;
    }
    else
    {
        [HyperCache createDirectoryInCachesDIR:_general_cache_dir_name];
        NSString* destDIRPath = [HyperCache pathInCachesDIR:_general_cache_dir_name];
        NSString* path = [destDIRPath stringByAppendingPathComponent:filename];
        return path;
    }
}

+(NSMutableDictionary*)taskForURL:(NSString*)url
{
    id result = [HyperCache ongoingTasks][url];
    return result;
}

+(void)attachCallback:(void (^)(HyperCacheStatus status, id obj))callback toTaskDictionary:(NSMutableDictionary*)taskDic
{
    if (_block_ok(callback))
    {
        NSMutableArray* callbacks =  taskDic[_taskDic_callbacks_key];
        [callbacks addObject:callback];
    }
}

+(void)attachImageView:(UIImageView*)imageView toTaskDictionary:(NSMutableDictionary*)taskDic
{
    NSString* imageView_unique_ident = [HyperCache uniqueIdentForImageView:imageView];
    NSMutableArray* linkedImageViews =  taskDic[_taskDic_linkedImageViews_key];
    if (![linkedImageViews containsObject:imageView_unique_ident])
        [linkedImageViews addObject:imageView_unique_ident];
}

//+(void)attachImageCallback:(void (^)(HyperCacheStatus status, id obj))callback imageView:(UIImageView*)imageView toTaskDictionary:(NSMutableDictionary*)taskDic
//{
//
//    NSString* imageView_unique_ident = [HyperCache uniqueIdentForImageView:imageView];
//    NSMutableArray* linkedImageViews =  taskDic[_taskDic_linkedImageViews_key];
//    [linkedImageViews addObject:imageView_unique_ident];
//}

+(NSMutableDictionary*)newTaskDicWithURL:(NSString*)url
{
    NSMutableDictionary* task = [NSMutableDictionary new];
    task[@"url"] = url;
    task[_taskDic_callbacks_key] = [NSMutableArray new];
    task[_taskDic_linkedImageViews_key] = [NSMutableArray new];
    return task;
}

//+(NSString*)_options_tag:(NSDictionary*)options
//{
//    if (_str_ok1(options[@"tag"]))
//        return options[@"tag"];
//    else
//        return nil;
//}
//
//+(UIImage* (^)(UIImage*))_options_imagePreprocessBlock:(NSDictionary*)options
//{
//    UIImage* (^result)(UIImage*) = options[@"imagePreprocessBlock"];
//    return result;
//}

//+(NSUInteger)_options_ttl:(NSDictionary*)options
//{
//    if (_dic_ok(options, @"ttl") && [options[@"ttl"] isKindOfClass:[NSNumber class]])
//        return [options[@"ttl"] unsignedIntegerValue];
//    else
//        return 0;
//}
//
//+(HyperCacheCallbackMode)_options_callbackMode:(NSDictionary*)options
//{
//    HyperCacheCallbackMode result = HyperCacheCallbackModeDefault;
//    if (_dic_ok(options, @"callbackMode"))
//        result = [options[@"callbackMode"] unsignedIntegerValue];
//
//    return result;
//}
//
//+(NSString*)_options_group:(NSDictionary*)options
//{
//    if (_str_ok1(options[@"group"]))
//        return options[@"group"];
//    else
//        return nil;
//}
//
//+(BOOL)_options_isImageTask:(NSDictionary*)options
//{
//    if (_dic_ok(options, @"isImageTask") && [options[@"isImageTask"] boolValue])
//        return YES;
//    else
//        return NO;
//}
//
//+(float)_options_taskPriority:(NSDictionary*)options
//{
//    if (_dic_ok(options, @"taskPriority"))
//        return [options[@"taskPriority"] floatValue];
//    else
//        return _default_task_priority;
//}
//
//+(HyperCachePolicy)_options_cachePolicy:(NSDictionary*)options
//{
//    if (_dic_ok(options, @"policy") && [options[@"policy"] isKindOfClass:[NSNumber class]])
//        return [options[@"policy"] unsignedIntegerValue];
//    else
//        return HyperCachePolicyCache;
//}
//
//+(UIImageView*)_options_imageView:(NSDictionary*)options
//{
//    if (_dic_ok(options, @"imageView") && [options[@"imageView"] isKindOfClass:[UIImageView class]])
//        return options[@"imageView"];
//    else
//        return nil;
//}

+(void)attachCallbackToImageViewCallbacks:(UIImageView*)imageView url:(NSString*)url postprocessBlock:(id (^) (id))postprocessBlock callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    NSMutableDictionary* imageViewCallbacks = [HyperCache imageViewCallbacks];
    id _postprocessBlock_obj = postprocessBlock;
    if (!_postprocessBlock_obj)
        _postprocessBlock_obj = [NSNull null];
    imageViewCallbacks[[HyperCache uniqueIdentForImageView:imageView]] = @{@"url": url, @"callback": callback, @"postprocessBlock": _postprocessBlock_obj};
}

+(void)detachImageViewFromImageViewCallbacks:(UIImageView*)imageView
{
    NSMutableDictionary* imageViewCallbacks = [HyperCache imageViewCallbacks];
    [imageViewCallbacks removeObjectForKey:[HyperCache uniqueIdentForImageView:imageView]];
}

+(void)purgeAllCache
{
    NSMutableArray* allCacheItems = [HyperCacheModel allCacheItems];
    for (NSDictionary* cacheItem in allCacheItems)
    {
        NSString* relativePath = cacheItem[@"path"];
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:relativePath];
        NSError* error;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (!error)
        {
            [HyperCacheModel sync_deleteCacheItemWithID:[cacheItem[@"id"] unsignedIntegerValue]];
        }
        else
        {
            NSLog(@"HyperCache: purgeAllCache: could not remove item: %@ (error:%@)", path, error.localizedDescription);
        }
    }
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

+(void)purgeSomeCache
{
    NSDate* dt = [NSDate date];
    
    NSMutableArray* allCacheItems = [HyperCacheModel allCacheItems];
    for (NSDictionary* cacheItem in allCacheItems)
    {
        if (([cacheItem[@"tag"] isEqualToString:@"feed_video"] || [cacheItem[@"tag"] isEqualToString:@"feed_image"]) &&
            [HyperCache daysBetweenDate:dt andDate:cacheItem[@"creationTime"]] > 2)
        {
            NSString* relativePath = cacheItem[@"path"];
            NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:relativePath];
            NSError* error;
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            if (!error)
            {
                [HyperCacheModel deleteCacheItemWithID:[cacheItem[@"id"] unsignedIntegerValue]];
            }
            else
            {
                NSLog(@"HyperCache: purgeAllCache: could not remove item: %@ (error:%@)", path, error.localizedDescription);
            }
        }
    }
}



//////////////// file handlings
+(NSString*)pathInCachesDIR:(NSString*)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"HyperCache"];
    return [cacheDirectory stringByAppendingPathComponent:path];
}

+(BOOL)createDirectoryInCachesDIR:(NSString*)path
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:[HyperCache pathInCachesDIR:path] withIntermediateDirectories:YES attributes:nil error:nil] ;
}

+(NSString*)uniqueIdentForImageView:(UIImageView*)imageView
{
    NSString* uniqueIdent = [imageView dataObjectForKey:@"_uniqueIdent"];
    if (!uniqueIdent)
    {
        uniqueIdent = _strfmt(@"%p", imageView);
        [imageView setDataObject:uniqueIdent forKey:@"_uniqueIdent"];
    }
    
    return uniqueIdent;
}

static UIView* (^loadingViewProviderCallback)();
+(void)setLoadingViewProviderCallback:(UIView* (^)(void))block
{
    loadingViewProviderCallback = block;
}

+(UIView* (^)())loadingProviderCallback
{
    return loadingViewProviderCallback;
}

@end


#define HyperCacheShouldShowLoadingViewKey @"HyperCacheShouldShowLoadingView"
#define HyperCacheLoadingViewHyperPoolIdentKey @"HyperCache_HyperPool_LoadingViewPoolIdent"
#define HyperCache_HyperPool_View_PreparationBlock_key @"HyperCache_HyperPool_View_PreparationBlock_key"

#define HyperCache_imageView_HyperPool_subview_key @"_hyperCache_hyperPool_LoadingSubView"
#define HyperCache_imageView_globalloadingView_key @"_hyperCacheLoadingSubView"

@implementation UIImageView (HyperCache)

-(void)setHyperCache_HyperPool_Prepare:(void (^)(id, UIImageView *))HyperCache_HyperPool_Prepare
{
    [self setDataObject:HyperCache_HyperPool_Prepare forKey:HyperCache_HyperPool_View_PreparationBlock_key];
}

-(void (^)(id, UIImageView *))HyperCache_HyperPool_Prepare
{
    return [self dataObjectForKey:HyperCache_HyperPool_View_PreparationBlock_key];
}

-(void)setHyperCacheLoadingViewHyperPoolIdent:(NSString *)HyperCacheLoadingViewHyperPoolIdent
{
    [self setDataObject:HyperCacheLoadingViewHyperPoolIdent forKey:HyperCacheLoadingViewHyperPoolIdentKey];
}

-(NSString *)HyperCacheLoadingViewHyperPoolIdent
{
    return [self dataObjectForKey:HyperCacheLoadingViewHyperPoolIdentKey];
}

-(void)setHyperCacheShouldShowLoadingView:(BOOL)HyperCacheShouldShowLoadingView
{
    [self setDataObject:@(HyperCacheShouldShowLoadingView) forKey:HyperCacheShouldShowLoadingViewKey];
}

-(BOOL)HyperCacheShouldShowLoadingView
{
    return [[self dataObjectForKey:HyperCacheShouldShowLoadingViewKey] boolValue];
}

-(void)HyperCacheSetImageWithURL:(NSString*)url cachedImage:(UIImage*)cachedImage callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [self HyperCacheSetImageWithURL:url cachedImage:cachedImage failoverImage:nil callback:callback];
}

-(void)HyperCacheSetImageWithURL:(NSString*)url placeHolderImage:(UIImage*)placeHolderImage cachedImage:(UIImage*)cachedImage callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [self HyperCacheSetImageWithURL:url placeHolderImage:placeHolderImage cachedImage:cachedImage preprocessBlock:nil failoverImage:nil postProcessBlock:nil animationBlock:nil callback:callback];
}

-(void)HyperCacheSetImageWithURL:(NSString*)url placeHolderImage:(UIImage*)placeHolderImage cachedImage:(UIImage*)cachedImage animationBlock:(void (^)(UIImageView* imageView, UIImage* image))animationBlock callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [self HyperCacheSetImageWithURL:url placeHolderImage:placeHolderImage cachedImage:cachedImage preprocessBlock:nil failoverImage:nil postProcessBlock:nil animationBlock:animationBlock callback:callback];
}

-(void)HyperCacheSetImageWithURL:(NSString*)url callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    //    return [self HyperCacheSetImageWithURL:url withOptions:nil callback:callback];
    [self HyperCacheSetImageWithURL:url cachedImage:nil failoverImage:nil callback:callback];
}


-(void)HyperCacheSetImageWithURL:(NSString*)url
{
    [self HyperCacheSetImageWithURL:url cachedImage:nil failoverImage:nil callback:nil];
}

-(void)HyperCacheSetImageWithURL:(NSString*)url placeHolderImage:(UIImage*)placeHolderImage
{
    [self HyperCacheSetImageWithURL:url placeHolderImage:placeHolderImage cachedImage:nil preprocessBlock:nil failoverImage:nil postProcessBlock:nil animationBlock:nil callback:nil];
}

-(void)HyperCacheSetImageWithURL:(NSString*)url placeHolderImage:(UIImage*)placeHolderImage animationBlock:(void (^)(UIImageView* imageView, UIImage* image))animationBlock
{
    [self HyperCacheSetImageWithURL:url placeHolderImage:placeHolderImage cachedImage:nil preprocessBlock:nil failoverImage:nil postProcessBlock:nil animationBlock:animationBlock callback:nil];
}

-(void)HyperCacheSetImageWithURL:(NSString*)url preprocessBlock:(id (^) (id))preprocessBlock
{
    [self HyperCacheSetImageWithURL:url placeHolderImage:nil cachedImage:nil preprocessBlock:preprocessBlock failoverImage:nil postProcessBlock:nil animationBlock:nil callback:nil];
}

-(void)HyperCacheSetImageWithURL:(NSString*)url cachedImage:(UIImage*)cachedImage failoverImage:(UIImage*)failoverImage preprocessBlock:(id (^) (id))preprocessBlock callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [self HyperCacheSetImageWithURL:url placeHolderImage:nil cachedImage:cachedImage preprocessBlock:preprocessBlock failoverImage:failoverImage postProcessBlock:nil animationBlock:nil callback:callback];
}


-(void)HyperCacheSetImageWithURL:(NSString*)url cachedImage:(UIImage*)cachedImage preprocessBlock:(id (^) (id))preprocessBlock callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [self HyperCacheSetImageWithURL:url placeHolderImage:nil cachedImage:cachedImage preprocessBlock:preprocessBlock failoverImage:nil postProcessBlock:nil animationBlock:nil callback:callback];
}

-(void)HyperCacheSetImageWithURL:(NSString*)url preprocessBlock:(id (^) (id))preprocessBlock callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [self HyperCacheSetImageWithURL:url placeHolderImage:nil cachedImage:nil preprocessBlock:preprocessBlock failoverImage:nil postProcessBlock:nil animationBlock:nil callback:callback];
}

-(void)HyperCacheSetImageWithURL:(NSString*)url cachedImage:(UIImage*)cachedImage postProcessBlock:(id (^) (id))postprocessBlock callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [self HyperCacheSetImageWithURL:url placeHolderImage:nil cachedImage:cachedImage preprocessBlock:nil failoverImage:nil postProcessBlock:postprocessBlock animationBlock:nil callback:callback];
}

-(void)HyperCacheSetImageWithURL:(NSString*)url cachedImage:(UIImage*)cachedImage failoverImage:(UIImage*)failoverImage callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    [self HyperCacheSetImageWithURL:url placeHolderImage:nil cachedImage:cachedImage preprocessBlock:nil failoverImage:failoverImage postProcessBlock:nil animationBlock:nil callback:callback];
}

-(void)_removeAllCorrespondantSubviews
{
    UIView* v = [self dataObjectForKey:HyperCache_imageView_globalloadingView_key];
    if (v && v.superview)
        [v removeFromSuperview];
    
    UIView* v2 = [self dataObjectForKey:HyperCache_imageView_HyperPool_subview_key];
    if (v2 && v2.superview)
    {
        [v2  removeFromSuperview];
        [v2 HyperPoolReleaseObject];
    }
    
    [self setDataObject:nil forKey:HyperCache_imageView_globalloadingView_key];
    [self setDataObject:nil forKey:HyperCache_imageView_HyperPool_subview_key  ];
}

-(void)HyperCacheImageViewWillDealloc
{
    [HyperCache cancelTaskWithImageView:self mode:HyperCacheCancelModeKill];
    [self _removeAllCorrespondantSubviews];
}

-(void)HyperCacheSetImageWithURL:(NSString*)url placeHolderImage:(UIImage*)placeHolderImage cachedImage:(UIImage*)cachedImage preprocessBlock:(id (^) (id))preprocessBlock failoverImage:(UIImage*)failoverImage postProcessBlock:(id (^) (id))postprocessBlock animationBlock:(void (^)(UIImageView* imageView, UIImage* image))animationBlock callback:(void (^)(HyperCacheStatus status, id obj))callback
{
    if (cachedImage)
        self.image = cachedImage;
    else
        self.image = placeHolderImage;
    
    [self _removeAllCorrespondantSubviews];
    
    if (cachedImage)
    {
        if (postprocessBlock)
            cachedImage = postprocessBlock(cachedImage);
        _mainThread(^{
            self.image = cachedImage;
        });
        dispatch_async([HyperCache getDispatchQueue], ^{
            [HyperCache detachImageViewFromImageViewCallbacks:self];
        });
        
        //        return nil;
    }
    
    if (!_str_ok2(url))
    {
        if (failoverImage)
            _mainThread(^{
                self.image = failoverImage;
            });
        else
            _mainThread(^{
                self.image = nil;
            });
        dispatch_async([HyperCache getDispatchQueue], ^{
            [HyperCache detachImageViewFromImageViewCallbacks:self];
        });
    }
    
    if (callback)
        callback(HyperCacheStatusWillStartFetch, nil);
    
    [HyperCache DownloadWithURL:url type:HyperCacheItemTypeImage isImageTask:YES imageView:self preprocessBlock:preprocessBlock postprocessBlock:postprocessBlock callbackMode:HyperCacheCallbackModeDefault group:nil tag:nil ttl:0 cacheOptions:HyperCachePolicyDefault priority:NSURLSessionTaskPriorityDefault callback:^(HyperCacheStatus status, id obj) {
        
        if ((status & HyperCacheStatusIsBeingDownloaded) == HyperCacheStatusIsBeingDownloaded)
        {
            _mainThread(^{
                if (self.HyperCacheShouldShowLoadingView)
                {
                    NSString* possible_loadingview_pool_ident = [self HyperCacheLoadingViewHyperPoolIdent];
                    if (_str_ok2(possible_loadingview_pool_ident))
                    {
                        UIView* view = [HyperPool acquireObjectFromPoolWithIdent:possible_loadingview_pool_ident];
                        [self setDataObject:view forKey:HyperCache_imageView_HyperPool_subview_key];
                        [self addSubview:view];
                        void (^preparationBlock)(id pooled_obj, UIImageView* thisImageView) = [self HyperCache_HyperPool_Prepare];
                        if (preparationBlock)
                        {
                            _defineWeakSelf;
                            preparationBlock(view, weakSelf);
                        }
                    }
                    else if ([HyperCache loadingProviderCallback])
                    {
                        UIView* view = [HyperCache loadingProviderCallback]();
                        [self setDataObject:view forKey:HyperCache_imageView_globalloadingView_key];
                        [self addSubview:view];
                        view.translatesAutoresizingMaskIntoConstraints = NO;
                        [view sdc_alignEdgesWithSuperview:UIRectEdgeAll];
                    }
                }
            });
        }
        
        if ((status & HyperCacheStatusSuccess) == HyperCacheStatusSuccess && [obj isKindOfClass:[UIImage class]])
        {
            _mainThread(^{
                [self _removeAllCorrespondantSubviews];
            });
            
            if (status & HyperCacheStatusReadFromCache) //no animation if it was cached
            {
                _mainThread(^{
                    self.image = obj;
                });
            }
            else if (status & HyperCacheStatusCached) //perform animation only if its just downloaded
            {
                if (animationBlock)
                    _mainThread(^{
                        animationBlock(self, obj);
                    });
                else
                    [self _threadSafeSetImage:obj andOptions:nil isFailoverImage:NO];
                
            }
            _callback_safe(status, obj);
        }
        else if ((status & HyperCacheStatusFailure) == HyperCacheStatusFailure)
        {
            _mainThread(^{
                [self _removeAllCorrespondantSubviews];
            });
            
            if (failoverImage)
            {
                [self _threadSafeSetImage:failoverImage andOptions:nil isFailoverImage:YES];
            }
            
            _callback_safe(HyperCacheStatusFailure | HyperCacheStatusConnectionError | HyperCacheStatusUsedFailoverImage, failoverImage);
        }
    }];
}

-(void)_threadSafeSetImage:(UIImage*)image andOptions:(NSDictionary*)options isFailoverImage:(BOOL)isFailoverImage
{
    BOOL animation_enabled = _setImage_default_animation_enabled;
    float animation_duration = _setImage_default_duration;
    BOOL shouldFade = _setImage_default_should_fade;
    float fade_from = _setImage_default_fade_fromValue;
    BOOL shouldEnlarge = _setImage_default_should_enlarge;
    float enlarge_from = _setImage_default_enlarge_fromValue;
    
    // NO ELARGEMENT ANIMATION FOR FAILED IMAGE DOWNLOADS
    if (isFailoverImage)
    {
        shouldEnlarge = NO;
    }
    
    if (options[@"animation"])
    {
        if (options[@"animation"][@"enabled"])
            animation_enabled = [options[@"animation"][@"enabled"] boolValue];
        
        if (options[@"animation"][@"duration"])
            animation_duration = [options[@"animation"][@"duration"] floatValue];
        
        if (options[@"animation"][@"shouldFade"])
            shouldFade = [options[@"animation"][@"shouldFade"] boolValue];
        
        if (options[@"animation"][@"fadeFrom"])
            fade_from = [options[@"animation"][@"fadeFrom"] floatValue];
        
        if (options[@"animation"][@"shouldEnlarge"])
            shouldEnlarge = [options[@"animation"][@"shouldEnlarge"] boolValue];
        
        if (options[@"animation"][@"enlargeFrom"])
            enlarge_from = [options[@"animation"][@"enlargeFrom"] floatValue];
    }
    
    _mainThread(^{
        if (animation_enabled)
            [self setImageAnimated:image duration:animation_duration shouldFade:shouldFade fadeFrom:fade_from shouldEnlarge:shouldEnlarge enlargeFrom:enlarge_from];
        else
            self.image = image;
    });
}

-(void)setImageAnimated:(UIImage*)image duration:(float)duration shouldFade:(BOOL)shouldFade fadeFrom:(float)fadeFrom shouldEnlarge:(BOOL)shouldEnlarge enlargeFrom:(float)enlargeFrom
{
    self.image = image;
    
    if (shouldFade)
        self.alpha = fadeFrom;
    
    if (shouldEnlarge)
        self.transform = CGAffineTransformMakeScale(enlargeFrom, enlargeFrom);
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

@end


