//
//  HyperCache.h
//  Aiywa2
//
//  Created by hAmidReza on 2/17/17.
//  Copyright © 2017 nizek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HyperCacheItemTypeImage = 1,
    HyperCacheItemTypeData = 2,
} HyperCacheItemType;

typedef enum : NSUInteger {
    HyperCacheStatusNone = 0,
    HyperCacheStatusCacheFoundButFileError = 1 << 0,
    HyperCacheStatusReadFromCache = 1 << 1,
    HyperCacheStatusSuccess = 1 << 2,
    HyperCacheStatusFailure = 1 << 3,
    HyperCacheStatusDownloaded = 1 << 4,
    HyperCacheStatusCached = 1 << 4,
    HyperCacheStatusConnectionError = 1 << 5,
    HyperCacheStatusWillStartFetch = 1 << 6,
    HyperCacheStatusUsedFailoverImage = 1 << 7,
    HyperCacheStatusIsBeingDownloaded = 1 << 8,
    HyperCacheStatusInvalidURL = 1 << 9,
} HyperCacheStatus;

typedef enum : NSUInteger {
    HyperCacheBatchStatusNone = 0,
    HyperCacheBatchStatusAllSucceed = 1 << 0,
    HyperCacheBatchStatusSuccessWithFailures = 1 << 1,
    HyperCacheBatchStatusAllFailed = 1 << 1,
} HyperCacheBatchStatus;

typedef enum : NSUInteger {
    HyperCachePolicyCache = 0,
    HyperCachePolicyDefault = HyperCachePolicyCache,
    HyperCachePolicyNoCache = 1,
} HyperCachePolicy;

typedef enum : NSUInteger {
    HyperCacheCancelModeKill,
    HyperCacheCancelModeCancelCallback,
} HyperCacheCancelMode;

@interface HyperCache : NSObject

+(void)purgeAllCache;
+(void)purgeSomeCache;

+(NSString*)stringFromHyperCacheStatus:(HyperCacheStatus)status;

+(void)cancelTaskWithURL:(NSString*)url mode:(HyperCacheCancelMode)cancelMode;
//+(void)cancelTask:(NSDictionary*)taskDic mode:(HyperCacheCancelMode)cancelMode;
+(void)cancelTasksInGroup:(NSString*)group;

+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type callback:(void (^)(HyperCacheStatus status, id obj))callback;
+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag callback:(void (^)(HyperCacheStatus status, id obj))callback;
+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type ttl:(NSUInteger)ttl callback:(void (^)(HyperCacheStatus status, id obj))callback;
+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag ttl:(NSUInteger)ttl callback:(void (^)(HyperCacheStatus status, id obj))callback;
+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag priority:(float)priority group:(NSString*)group callback:(void (^)(HyperCacheStatus status, id obj))callback;
+(void)DownloadFileWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag callback:(void (^)(HyperCacheStatus status, id obj))callback;
+(void)DownloadFileWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag group:(NSString*)group callback:(void (^)(HyperCacheStatus status, id obj))callback;
+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag imagePreprocessorBlock:(UIImage* (^)(UIImage*))imagePreprocessorBlock callback:(void (^)(HyperCacheStatus status, id obj))callback;
+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag imagePreprocessorBlock:(UIImage* (^)(UIImage*))imagePreprocessorBlock priority:(float)priority callback:(void (^)(HyperCacheStatus status, id obj))callback;
+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag priority:(float)priority callback:(void (^)(HyperCacheStatus status, id obj))callback;
+(void)DownloadFileWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag priority:(float)priority callback:(void (^)(HyperCacheStatus status, id obj))callback;
+(void)DownloadWithURL:(NSString*)url type:(HyperCacheItemType)type tag:(NSString*)tag imagePreprocessorBlock:(UIImage* (^)(UIImage*))imagePreprocessorBlock priority:(float)priority group:(NSString*)group callback:(void (^)(HyperCacheStatus status, id obj))callback;

+(void)setLoadingViewProviderCallback:(UIView* (^)(void))block;
+(void)BatchDownloadWithURLArray:(NSArray*)urls type:(HyperCacheItemType)type callback:(void (^)(HyperCacheBatchStatus status, id obj))callback;

//@property (nonatomic, copy, nullable) UIView* (^loadingView)();

@end

@interface UIImageView (HyperCache)

-(void)HyperCacheSetImageWithURL:(NSString*)url cachedImage:(UIImage*)cachedImage callback:(void (^)(HyperCacheStatus status, id obj))callback;
-(void)HyperCacheSetImageWithURL:(NSString*)url cachedImage:(UIImage*)cachedImage failoverImage:(UIImage*)failoverImage callback:(void (^)(HyperCacheStatus status, id obj))callback;
-(void)HyperCacheSetImageWithURL:(NSString*)url callback:(void (^)(HyperCacheStatus status, id obj))callback;
-(void)HyperCacheSetImageWithURL:(NSString*)url;
-(void)HyperCacheSetImageWithURL:(NSString*)url placeHolderImage:(UIImage*)placeHolderImage;
-(void)HyperCacheSetImageWithURL:(NSString*)url placeHolderImage:(UIImage*)placeHolderImage animationBlock:(void (^)(UIImageView* imageView, UIImage* image))animationBlock;
//-(void)HyperCacheSetImageWithURL:(NSString*)url tag:(NSString*)tag callback:(void (^)(HyperCacheStatus status, id obj))callback;
-(void)HyperCacheSetImageWithURL:(NSString*)url preprocessBlock:(id (^) (id))preprocessBlock;
-(void)HyperCacheSetImageWithURL:(NSString*)url placeHolderImage:(UIImage*)placeHolderImage cachedImage:(UIImage*)cachedImage callback:(void (^)(HyperCacheStatus status, id obj))callback;
-(void)HyperCacheSetImageWithURL:(NSString*)url placeHolderImage:(UIImage*)placeHolderImage cachedImage:(UIImage*)cachedImage animationBlock:(void (^)(UIImageView* imageView, UIImage* image))animationBlock callback:(void (^)(HyperCacheStatus status, id obj))callback;
-(void)HyperCacheSetImageWithURL:(NSString*)url cachedImage:(UIImage*)cachedImage postProcessBlock:(id (^) (id))postprocessBlock callback:(void (^)(HyperCacheStatus status, id obj))callback;
-(void)HyperCacheSetImageWithURL:(NSString*)url preprocessBlock:(id (^) (id))preprocessBlock callback:(void (^)(HyperCacheStatus status, id obj))callback;
-(void)HyperCacheSetImageWithURL:(NSString*)url cachedImage:(UIImage*)cachedImage preprocessBlock:(id (^) (id))preprocessBlock callback:(void (^)(HyperCacheStatus status, id obj))callback;
-(void)HyperCacheSetImageWithURL:(NSString*)url cachedImage:(UIImage*)cachedImage failoverImage:(UIImage*)failoverImage preprocessBlock:(id (^) (id))preprocessBlock callback:(void (^)(HyperCacheStatus status, id obj))callback;
/**
 determines whether the hypercache must call the loadingViewProviderCallback() to retreive a loading view to show over this imageview upon downloading any resource. Should not be used in collectionview or tableviews since loadingViewProviderCallback() is supposed to create and return a new UIView, so it will have low performance. However for many situations like a profile picture it can be useful.
 default: false;
 
 */
@property (assign, nonatomic) BOOL HyperCacheShouldShowLoadingView;



/**
 determines whether the hypercache should deque a loading view from hyperpool with this identifier.
 */
@property (assign, nonatomic) NSString* HyperCacheLoadingViewHyperPoolIdent;


/**
 HyperCache will call this method in order to layout the pooled_obj. because Autolayout has performace penalties you may want to set the frame of the pooled_obj with respect to this imageview's frame.
 */
@property (copy, nonatomic) void (^HyperCache_HyperPool_Prepare)(id pooled_obj, UIImageView* thisImageView);



/**
 You may call this method e.g. in a pushed tableviewcontroller when the user presses the back button. inside cell class override the dealloc method and call this method for the cell's imageview which you used HyperCache on it. it will cancel the imageview task, (if and only if the ongoing task for the url is linked to this imageview only. if there are other imageviews it won't be cancelled)
 */
-(void)HyperCacheImageViewWillDealloc;

@end



