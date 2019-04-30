//
//  helper.h salam chetori
//  macTehran
//
//  Created by Hamidreza Vaklian on 12/25/15.
//  Copyright © 2015 Hamidreza Vaklian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MyShapeButton;

typedef enum : NSUInteger {
    PrediUserRoleNormal = 1,
    PrediUserRoleAdmin1 = 5,
} PrediUserRole;

#ifndef _threadingHelperMethods
static inline void _mainThread(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

static inline void _mainThreadAsync(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

static inline void _mainThreadAfter(dispatch_block_t block, float seconds)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

static inline void _backThreadDefAfter(dispatch_block_t block, float seconds)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

static inline void _backThreadLowAfter(dispatch_block_t block, float seconds)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block);
}

static inline void _backThreadBackgroundAfter(dispatch_block_t block, float seconds)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

static inline void _backThreadHighAfter(dispatch_block_t block, float seconds)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block);
}

static inline void _backThreadAfter(dispatch_queue_t queue, dispatch_block_t block, float seconds)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), queue, block);
}

static inline void _backThread(dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_async(queue, block);
}

static inline void _backThreadDef(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

static inline void _backThreadHigh(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block);
}

static inline void _backThreadLow(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block);
}

static inline void _backThreadBackground(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}
#define _threadingHelperMethods
#endif

@interface helper : NSObject

+(NSDictionary*)getAppVersions;

+(UIBarButtonItem*)shapeBarButtonWithConf:(void (^)(MyShapeButton* button))buttonConfCallback andCallback:(void (^)(void))buttonClick;

+(CGPathRef)bezierCGPath:(CGPathRef)path rotatedByDegrees:(CGFloat)angle;
+(UIBezierPath*)bezierPathWithDescArray:(NSArray*)array andRenderSize:(CGSize)s closePath:(bool)closePath;
+(UIBezierPath*)bezierPathWithDescArray:(NSArray*)array andWidth:(CGFloat)w;
+(UIBezierPath*)bezierPathWithDescArray:(NSArray*)array andWidth:(CGFloat)w closePath:(bool)closePath;

//+(void)prepareLocalizableStrings;
+(void)setLang:(NSString*)key;
+(NSString*)getLang;
+(NSString*)localizableValueWithKey:(NSString*)key;

//+(id)loadPrefWithKey:(NSString*)key;
//+(void)savePrefWithValue:(NSObject*)obj andKey:(NSString*)key;
//+(void)deletePrefWithKey:(NSString*)key;
+(UIColor*)linearColorBetweenLowerColor:(UIColor*)lowerColor andUpperColor:(UIColor*)upperColor andProgress:(CGFloat)progress;
//+(void)prepareMakeoverPriority1:(NSMutableArray*)array completionHandler:(void (^)(void))completionHandler;

//
//+(NSURL*)serverAPIPath:(NSString*)path;
//+(NSString*)serverAPIPathString:(NSString*)path;
//+(NSURL*)serverPath:(NSString*)path;
//+(NSURLSessionDataTask*)serverPostWithPath:(NSString*)api_path bodyDic:(NSDictionary*)dic loadToken:(BOOL)load_token completionHandler:(void (^)(id jsonObj))completionHandler;
//+(NSURLSessionDataTask*)serverGetWithPath:(NSString*)api_path loadToken:(BOOL)load_token completionHandler:(void (^)(id jsonObj))completionHandler;
//+(NSURLSessionDataTask*)serverGetWithPath:(NSString*)api_path loadToken:(BOOL)load_token session:(NSURLSession*)asession completionHandler:(void (^)(NSDictionary* jsonDic))completionHandler;
//+(NSURLSessionDataTask*)downloadMediaWithURL:(NSString*)url_string andCachedImage:(UIImage*)cached_image andHandler:(void(^)(UIImage* image))completion;
//+(NSURLSessionDataTask*)downloadMediaWithURL:(NSString*)url_string andCachedImage:(UIImage*)cached_image ansSession:(NSURLSession*)aSession andHandler:(void(^)(UIImage* image))completion;
///

+(NSBundle*)theBundle;

+(UIAlertController*)simpleAlertWithTitle:(NSString*)title message:(NSString*)msg;
+(NSNumber*)totalDiskSpace;
+(NSDictionary*)deviceInfoDictionary;
//
////

+ (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color;

+(NSString*)thousandSeparatedStringFromNumber:(NSNumber*)number;
+(NSURLSession*)assetProviderSession;
+(void)printAvailableFonts;

+(UIView*)hairlineTopEdgeToBottomOfView:(UIView*)view margin:(CGFloat)margin backColor:(UIColor*)color;
+(UIView*)hairlineBottomEdgeToTopOfView:(UIView*)view margin:(CGFloat)margin backColor:(UIColor*)color;
+(UIView*)hairlineTopOfView:(UIView*)view margin:(CGFloat)margin backColor:(UIColor*)color;
+(UIView*)hairlineBottomOfView:(UIView*)view margin:(CGFloat)margin backColor:(UIColor*)color;

+(void)hapticSelection;
+(void)hapticImpactLight;
+(void)hapticImpactMedium;
+(void)hapticImpactHeavy;
+(void)hapticNotificationSuccess;
+(void)hapticNotificationWarning;
+(void)hapticNotificationError;

/**
 We shouldn't use this method anymore. It won't make sqlite threadsafe on a single connection! it only allows to access multiple connections from multiple threads! useless here.
 */
+(void)makeSqliteThreadSafeIfNeeded UNAVAILABLE_ATTRIBUTE;


+(UIView*)horizontalHairlineWithColor:(UIColor*)color;
+(UIView*)verticalHairlineWithColor:(UIColor*)color;
+(NSDictionary*)getCarrierInfo;


/**
 returns the parsed dictionary from a url scheme.
 supported format is:
 [XXX]://[cmd]/[param1]/[param2]/[param3]
 
 XXX is the main_url_scheme for codebase dictionary in info.plist.
 
 paramteres are not required.
 
 @param url the url to process
 @return parsed dictioanry of the url scheme if
 */
+(NSDictionary*)processURLScheme:(NSURL*)url;
+(NSString*)device_uuid;
+(void)setLocalizationDictionary:(NSDictionary*)dic;
+(NSNumberFormatter*)decimalStrFormatter;

+(CGFloat)scaleToAspectFitRect:(CGRect)rfit inRect:(CGRect)rtarget;
+(CGRect)aspectFitRect:(CGRect)rfit inRect:(CGRect) rtarget;
+(UIBarButtonItem*)textBarButtonWithConf:(void (^)(UIButton* button))buttonConfCallback andCallback:(void (^)(void))buttonClick;
+(id)fetchITunesAppItemID;
+(CGPoint)CGRect:(CGRect)rect mapPointInside:(CGPoint)point;
+(void)setCustomLocalizableLookupMethod:(NSString* (^)(NSString* key, NSDictionary* localizable))block;
+(NSString*)NSStringFromQueryParameters:(NSDictionary*)queryParameters;
@end
