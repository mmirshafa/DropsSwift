//
//  helper.m
//  macTehran
//
//  Created by Hamidreza Vaklian on 12/25/15.
//  Copyright © 2015 Hamidreza Vaklian. All rights reserved.
//

#import "helper.h"
#import "Codebase.h"
#import "Codebase_definitions.h"
#import "PodAsset.h"
#import <SQLCipher/sqlite3.h>

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation helper

+(UISelectionFeedbackGenerator*)selectionFeedbackGenerator
{
    if ([UISelectionFeedbackGenerator class])
    {
        static UISelectionFeedbackGenerator* selectionFeedbackGenerator;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            selectionFeedbackGenerator = [UISelectionFeedbackGenerator new];
            [selectionFeedbackGenerator prepare];
        });
        
        return selectionFeedbackGenerator;
    }
    else
        
        return nil;
}

+(void)hapticSelection
{
    [[self selectionFeedbackGenerator] selectionChanged];
}

+(UIImpactFeedbackGenerator*)impactFeedbackGeneratorLight
{
    if ([UIImpactFeedbackGenerator class])
    {
        static UIImpactFeedbackGenerator* impactFeedbackGeneratorLight;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            impactFeedbackGeneratorLight = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [impactFeedbackGeneratorLight prepare];
        });
        
        return impactFeedbackGeneratorLight;
    }
    else
        return nil;
}

+(UIImpactFeedbackGenerator*)impactFeedbackGeneratorMedium
{
    if ([UIImpactFeedbackGenerator class])
    {
        static UIImpactFeedbackGenerator* impactFeedbackGeneratorMedium;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            impactFeedbackGeneratorMedium = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
            [impactFeedbackGeneratorMedium prepare];
        });
        
        return impactFeedbackGeneratorMedium;
    }
    else
        return nil;
}

+(UIImpactFeedbackGenerator*)impactFeedbackGeneratorHeavy
{
    if ([UIImpactFeedbackGenerator class])
    {
        static UIImpactFeedbackGenerator* impactFeedbackGeneratorHeavy;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            impactFeedbackGeneratorHeavy = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
            [impactFeedbackGeneratorHeavy prepare];
        });
        
        return impactFeedbackGeneratorHeavy;
    }
    else
        return nil;
}

+(void)hapticImpactLight
{
    [[self impactFeedbackGeneratorLight] impactOccurred];
}
+(void)hapticImpactMedium
{
    [[self impactFeedbackGeneratorMedium] impactOccurred];
}
+(void)hapticImpactHeavy
{
    [[self impactFeedbackGeneratorHeavy] impactOccurred];
}

+(UINotificationFeedbackGenerator*)notificationFeedbackGenerator
{
    if ([UINotificationFeedbackGenerator class])
    {
        static UINotificationFeedbackGenerator* notificationFeedbackGenerator;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            notificationFeedbackGenerator = [UINotificationFeedbackGenerator new];
            [notificationFeedbackGenerator prepare];
        });
        
        return notificationFeedbackGenerator;
    }
    else
        return nil;
}


+(void)hapticNotificationSuccess
{
    [[self notificationFeedbackGenerator] notificationOccurred:UINotificationFeedbackTypeSuccess];
}

+(void)hapticNotificationWarning
{
    [[self notificationFeedbackGenerator] notificationOccurred:UINotificationFeedbackTypeWarning];
}
+(void)hapticNotificationError
{
    [[self notificationFeedbackGenerator] notificationOccurred:UINotificationFeedbackTypeError];
}

+(NSDictionary*)getAppVersions
{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d+)\\.(\\d+)\\.(\\d+)$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    NSString* buildNo_str = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSNumber* buildNo = [[helper decimalStrFormatter] numberFromString:buildNo_str];
    NSString* version =  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSArray *matches = [regex matchesInString:version options:0 range:NSMakeRange(0, [version length])];
    
    if (matches && matches.count)
    {
        NSString* str1 = [version substringWithRange:[matches[0] rangeAtIndex:1]];
        NSNumber* v1 = [[helper decimalStrFormatter] numberFromString:str1];
        NSString* str2 = [version substringWithRange:[matches[0] rangeAtIndex:2]];
        NSNumber* v2 = [[helper decimalStrFormatter] numberFromString:str2];
        NSString* str3 = [version substringWithRange:[matches[0] rangeAtIndex:3]];
        NSNumber* v3 = [[helper decimalStrFormatter] numberFromString:str3];
        
        return @{@"build": buildNo_str,
                 @"_build": buildNo,
                 @"version": version,
                 @"_version": @[v1, v2, v3]};
    }
    return @{@"build": buildNo,
             @"version": version};
}

+(NSNumberFormatter*)decimalStrFormatter
{
    static NSNumberFormatter* decimalStrFormatter;
    if (!decimalStrFormatter)
    {
        decimalStrFormatter= [NSNumberFormatter new];
        decimalStrFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        decimalStrFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }
    return decimalStrFormatter;
}


+(UIBarButtonItem*)textBarButtonWithConf:(void (^)(UIButton* button))buttonConfCallback andCallback:(void (^)(void))buttonClick
{
    UIButton *theButton = [UIButton buttonWithType:UIButtonTypeCustom];
    theButton.objectData = buttonClick;
    [theButton addTarget:self action:@selector(_textBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if (buttonConfCallback)
        buttonConfCallback(theButton);
    
    //
    //    UIImageView* imageView = [UIImageView new];
    //    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //    [theButton addSubview:imageView];
    //    [imageView sdc_pinSize:CGSizeMake(15, 15)];
    //    [imageView sdc_centerInSuperview];
    //
    //    UIImage* rotated_img = [[UIImage imageNamed:@"arrow"] imageRotatedByDegrees:90];
    //    UIImage* theButtonImage = [helper filledImageFrom:rotated_img withColor:[UIColor whiteColor]];
    //
    //    imageView.image = theButtonImage;
    
    UIBarButtonItem *theButtonItem = [[UIBarButtonItem alloc] initWithCustomView:theButton];
    [theButtonItem setDataObject:theButton forKey:@"_button"];
    return theButtonItem;
}

+(void)_textBarButtonClick:(UIButton*)sender
{
    void (^buttonClick)(void) = sender.objectData;
    if (buttonClick)
        buttonClick();
}


+(NSString*)getAppVersionStringWithVersion:(NSArray*)version andBuild:(NSNumber*)build formatted:(BOOL)formatted
{
    if (formatted)
        return _strfmt(@"%@.%@.%@ (#%@)", version[0], version[1], version[2], build);
    else
        return _strfmt(@"%@.%@.%@-%@", version[0], version[1], version[2], build);
}

+(CGFloat)scaleToAspectFitRect:(CGRect)rfit inRect:(CGRect)rtarget
{
    CGFloat s = CGRectGetWidth(rtarget) / CGRectGetWidth(rfit);
    if (CGRectGetHeight(rfit) * s <= CGRectGetHeight(rtarget)) {
        return s;
    }
    return CGRectGetHeight(rtarget) / CGRectGetHeight(rfit);
}


+(CGRect)aspectFitRect:(CGRect)rfit inRect:(CGRect) rtarget
{
    CGFloat s = [self scaleToAspectFitRect:rfit inRect:rtarget];
    CGFloat w = CGRectGetWidth(rfit) * s;
    CGFloat h = CGRectGetHeight(rfit) * s;
    CGFloat x = CGRectGetMidX(rtarget) - w / 2;
    CGFloat y = CGRectGetMidY(rtarget) - h / 2;
    return CGRectMake(x, y, w, h);
}

+(CGPathRef)bezierCGPath:(CGPathRef)path rotatedByDegrees:(CGFloat)angle
{
    
    CGRect bounds = CGPathGetBoundingBox(path); // might want to use CGPathGetPathBoundingBox
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, center.x, center.y);
    transform = CGAffineTransformRotate(transform, DEG2RAD(angle));
    transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
    return CGPathCreateCopyByTransformingPath(path, &transform);
}

+(UIBezierPath*)bezierPathWithDescArray:(NSArray*)array andRenderSize:(CGSize)s closePath:(bool)closePath
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGFloat w = 100;
    CGFloat h = 100;
    CGFloat x = 0;
    CGFloat y = 0;
    for (id item in array) {
        if ([item isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dic = item;
            if (_dic_ok(dic[@"conf"], @"size"))
            {
                w = [dic[@"conf"][@"size"][0] floatValue];
                h = [dic[@"conf"][@"size"][1] floatValue];
            }
            
            CGRect drawingBounds = [self aspectFitRect:CGRectMake(0, 0, w, h) inRect:CGRectMake(0, 0, s.width, s.height)];
            x = drawingBounds.origin.x;
            y = drawingBounds.origin.y;
            s.width = drawingBounds.size.width;
            s.height = drawingBounds.size.height;
        }
        else if ([item isKindOfClass:[NSArray class]])
        {
            NSArray* arr = item;
            NSString* cmd = arr[0];
            if ([cmd isEqualToString:@"m"]) //move to point
                [path moveToPoint:CGPointMake(x+[arr[1] floatValue]/w*s.width, y+[arr[2] floatValue]/h*s.height)];
            else if ([cmd isEqualToString:@"l"]) //line
                [path addLineToPoint:CGPointMake(x+[arr[1] floatValue]/w*s.width, y+[arr[2] floatValue]/h*s.height)];
            else if ([cmd isEqualToString:@"c"]) //curve
                [path addCurveToPoint:CGPointMake(x+[arr[1] floatValue]/w*s.width, y+[arr[2] floatValue]/h*s.height) controlPoint1:CGPointMake(x+[arr[3] floatValue]/w*s.width, y+[arr[4] floatValue]/h*s.height) controlPoint2:CGPointMake(x+[arr[5] floatValue]/w*s.width, y+[arr[6] floatValue]/h*s.height)];
        }
    }
    
    if (closePath)
        [path closePath];
    
    return path;
}

+(UIBezierPath*)bezierPathWithDescArray:(NSArray*)array andWidth:(CGFloat)w closePath:(bool)closePath
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    for (NSArray* arr in array) {
        NSString* cmd = arr[0];
        if ([cmd isEqualToString:@"m"]) //move to point
            [path moveToPoint:CGPointMake([arr[1] floatValue]/100*w, [arr[2] floatValue]/100*w)];
        else if ([cmd isEqualToString:@"l"]) //line
            [path addLineToPoint:CGPointMake([arr[1] floatValue]/100*w, [arr[2] floatValue]/100*w)];
        else if ([cmd isEqualToString:@"c"]) //curve
            [path addCurveToPoint:CGPointMake([arr[1] floatValue]/100*w, [arr[2] floatValue]/100*w) controlPoint1:CGPointMake([arr[3] floatValue]/100*w, [arr[4] floatValue]/100*w) controlPoint2:CGPointMake([arr[5] floatValue]/100*w, [arr[6] floatValue]/100*w)];
    }
    
    if (closePath)
        [path closePath];
    
    return path;
}
+(UIBezierPath*)bezierPathWithDescArray:(NSArray*)array andWidth:(CGFloat)w
{
    return [self bezierPathWithDescArray:array andWidth:w closePath:YES];
}


+(UIBarButtonItem*)shapeBarButtonWithConf:(void (^)(MyShapeButton* button))buttonConfCallback andCallback:(void (^)(void))buttonClick
{
    MyShapeButton* shapeButton = [[MyShapeButton alloc] initWithShapeDesc:nil andShapeTintColor:[UIColor whiteColor] andButtonClick:buttonClick];
    
    if (buttonConfCallback)
        buttonConfCallback(shapeButton);
    
    shapeButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *theButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shapeButton];
    return theButtonItem;
}



+(NSNumber*)totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

+(void)printAvailableFonts
{
    for (NSString *familyName in [UIFont familyNames]){
        NSLog(@"Family name: %@", familyName);
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"--Font name: %@", fontName);
        }
    }
}

+(UIColor*)linearColorBetweenLowerColor:(UIColor*)lowerColor andUpperColor:(UIColor*)upperColor andProgress:(CGFloat)progress
{
    CGFloat lowerR, lowerG, lowerB, lowerA;
    [lowerColor getRed:&lowerR green:&lowerG blue:&lowerB alpha:&lowerA];
    CGFloat upperR, upperG, upperB, upperA;
    [upperColor getRed:&upperR green:&upperG blue:&upperB alpha:&upperA];
    UIColor* finalColor = [UIColor colorWithRed:lowerR + (upperR - lowerR) * progress green:lowerG + (upperG - lowerG) * progress blue:lowerB + (upperB - lowerB) * progress alpha:lowerA + (upperA - lowerA) * progress];
    return finalColor;
}



+(UIAlertController*)simpleAlertWithTitle:(NSString*)title message:(NSString*)msg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    return alertController;
}

+(NSString*)device_uuid
{
    NSUUID* ident = [[UIDevice currentDevice] identifierForVendor];
    return [ident UUIDString];
}

+(NSDictionary*)deviceInfoDictionary
{
    NSString* platformString = [UIDeviceHardware platformString];
    
    
    NSString* osVersion = [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]];
    NSString* capacity = [NSString stringWithFormat:@"%lluGB", [[helper totalDiskSpace] unsignedLongLongValue] / 1000000000];
    
    NSDictionary* carrierInfo = [self getCarrierInfo];
    
    NSDictionary* device_info = @{@"device": @{@"uid": [self device_uuid], @"platform": platformString, @"name": [[UIDevice currentDevice] name], @"capacity": capacity}, @"os": @{@"version": osVersion, @"type": @"iOS"}, @"carrier": carrierInfo};
    
    return device_info;
}

+(UIView*)hairlineTopOfView:(UIView*)view margin:(CGFloat)margin backColor:(UIColor*)color
{
    _defineDeviceScale;
    UIView* hairline = [UIView new];
    hairline.backgroundColor = color ? color : [UIColor blackColor];
    hairline.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:hairline];
    [hairline sdc_alignSideEdgesWithSuperviewInset:0];
    [hairline sdc_pinHeight:1/s];
    [hairline sdc_alignTopEdgeWithSuperviewMargin:margin];
    return hairline;
}

+(UIView*)hairlineBottomOfView:(UIView*)view margin:(CGFloat)margin backColor:(UIColor*)color
{
    _defineDeviceScale;
    UIView* hairline = [UIView new];
    hairline.backgroundColor = color ? color : [UIColor blackColor];
    hairline.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:hairline];
    [hairline sdc_alignSideEdgesWithSuperviewInset:0];
    [hairline sdc_pinHeight:1/s];
    [hairline sdc_alignBottomEdgeWithSuperviewMargin:margin];
    return hairline;
}


+(UIView*)hairlineTopEdgeToBottomOfView:(UIView*)view margin:(CGFloat)margin backColor:(UIColor*)color
{
    _defineDeviceScale;
    UIView* hairline = [UIView new];
    hairline.backgroundColor = color ? color : [UIColor blackColor];
    hairline.translatesAutoresizingMaskIntoConstraints = NO;
    [view.superview addSubview:hairline];
    [hairline sdc_alignSideEdgesWithSuperviewInset:0];
    [hairline sdc_pinHeight:1/s];
    [hairline sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:view inset:margin];
    return hairline;
}

+(UIView*)hairlineBottomEdgeToTopOfView:(UIView*)view margin:(CGFloat)margin backColor:(UIColor*)color
{
    _defineDeviceScale;
    UIView* hairline = [UIView new];
    hairline.backgroundColor = color ? color : [UIColor blackColor];
    hairline.translatesAutoresizingMaskIntoConstraints = NO;
    [view.superview addSubview:hairline];
    [hairline sdc_alignSideEdgesWithSuperviewInset:0];
    [hairline sdc_pinHeight:1/s];
    [hairline sdc_alignEdge:UIRectEdgeBottom withEdge:UIRectEdgeTop ofView:view inset:-margin];
    return hairline;
}


//static NSDictionary *localizable;
//+(void)prepareLocalizableStrings
//{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable"
//                                                     ofType:@"strings"];
//
//    localizable = [NSDictionary dictionaryWithContentsOfFile:path];
//}
//
//+(NSString*)localizableValueWithKey:(NSString*)key
//{
//    return localizable[key];
//}


static NSDictionary *localizable;
static NSString* langKey;
+(void)setLang:(NSString*)key
{
    if (!key)
        key = @"Base";
    
    langKey = key;
    
    [DBModel updateValue:key forKey:@"_lang"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:key];
    
    [self setLocalizationDictionary: [NSDictionary dictionaryWithContentsOfFile:path]];
    
    NSAssert(localizable, @"no .strings file found for key: %@", key);
}

+(void)setLocalizationDictionary:(NSDictionary*)dic
{
    NSMutableDictionary* result = [NSMutableDictionary new];
    
    for (NSString* aKey in [dic allKeys]) {
        result[[self __sanitizeLocalizationKey:aKey]] = dic[aKey];
    }
    
    localizable = result;
}

+(NSString*)getLang
{
    return langKey;
}

+(void)load
{
    [super load];
    
    NSString* lang_val = [DBModel getValueForKey:@"_lang"];
    if (_str_ok2(lang_val))
    {
        [self setLang:lang_val];
    }
}

+(NSDictionary*)getCarrierInfo
{
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    
    NSMutableDictionary* dic = [NSMutableDictionary new];
    if (_str_ok2(carrier.carrierName))
        dic[@"carrierName"] = carrier.carrierName;
    if (_str_ok2(carrier.mobileCountryCode))
        dic[@"mobileCountryCode"] = carrier.mobileCountryCode;
    if (_str_ok2(carrier.mobileNetworkCode))
        dic[@"mobileNetworkCode"] = carrier.mobileNetworkCode;
    
    dic[@"allowsVOIP"] = @(carrier.allowsVOIP);
    
    return dic;
}

/**
 Xcode has a bug. _str(arg) is different from [helper lozalizable....withstring:arg] because when you are using _str it will prepend a <zero space width> to arg. also when creating the localizable dictionary some invisble characters may be inserted into the lozalizable key. so will use this function to trim those bad characters.
 
 @param key string to sanitize
 @return sanitized key.
 */
+(NSString*)__sanitizeLocalizationKey:(NSString*)key
{
    static NSMutableCharacterSet* set;
    if (!set)
    {
        set = [NSMutableCharacterSet alphanumericCharacterSet];
        [set formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
        [set invert];
    }
    
    return [[key componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
}

+(void)setCustomLocalizableLookupMethod:(NSString* (^)(NSString* key, NSDictionary* localizable))block
{
    [self setDataObject:block forKey:@"_customLocalizableLookupMethod"];
}

+(NSString*)localizableValueWithKey:(NSString*)key
{
    key = [self __sanitizeLocalizationKey:key];
    
    if (!_str_ok2(key))
        NSLog(@"here");
    
    if ([self dataObjectForKey:@"_customLocalizableLookupMethod"])
    {
        NSString* (^block)(NSString* key, NSDictionary* localizable) = [self dataObjectForKey:@"_customLocalizableLookupMethod"];
        return block(key, localizable);
    }
    
    return localizable[key] ? localizable[key] : key;
}
//////

+ (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color
{
    
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

+(NSBundle*)theBundle
{
    return [PodAsset bundleForPod:@"iOS-Codebase"];
}

+(NSString *)thousandSeparatedStringFromNumber:(NSNumber *)number
{
    static NSNumberFormatter* numberFormatter;
    
    if (!numberFormatter)
    {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
        numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }
    
    return [numberFormatter stringFromNumber:number];
    
    
}

+(int)ui_lang
{
    return 1;//0:english, 1:farsi
}

+(NSURLSession*)assetProviderSession
{
    static NSURLSession* assetProviderSession;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        assetProviderSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    });
    return assetProviderSession;
}

+(void)makeSqliteThreadSafeIfNeeded
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqlite3_shutdown();
        if (sqlite3_threadsafe() > 0) {
            int retCode = sqlite3_config(SQLITE_CONFIG_SERIALIZED);
            if (retCode == SQLITE_OK) {
                NSLog(@"Can now use sqlite on multiple threads, using the same connection");
            } else {
                NSLog(@"setting sqlite thread safe mode to serialized failed!!! return code: %d", retCode);
            }
        } else {
            NSLog(@"Your SQLite database is not compiled to be threadsafe.");
        }
        sqlite3_initialize();
    });
}

+(UIView*)horizontalHairlineWithColor:(UIColor*)color
{
    UIView* hairline = [UIView new];
    hairline.backgroundColor = color;
    hairline.translatesAutoresizingMaskIntoConstraints = NO;
    [hairline sdc_pinHeight:_1pixel];
    return hairline;
}

+(UIView*)verticalHairlineWithColor:(UIColor*)color
{
    UIView* hairline = [UIView new];
    hairline.backgroundColor = color;
    hairline.translatesAutoresizingMaskIntoConstraints = NO;
    [hairline sdc_pinWidth:_1pixel];
    return hairline;
}

+(NSDictionary *)processURLScheme:(NSURL *)url
{
    NSString* url_str;
    
    if (_str_ok2((NSString*)url))
        url_str = (NSString*)url;
    
    if ([url isKindOfClass:[NSURL class]])
        url_str = [url absoluteString];
    
    if (!_str_ok2(url_str))
        return nil;
    
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSAssert(_str_ok2(_codebaseDic[@"main_url_scheme"]), @"main_url_scheme for codebase is null in info.plist");
        regex = [NSRegularExpression regularExpressionWithPattern:_strfmt(@"^%@:\\/\\/([^\\s\\/]+)\\/?(?:\\/([^\\s\\/]+))?\\/?(?:\\/([^\\s\\/]+))?\\/?(?:\\/([^\\s\\/]+))?$", _codebaseDic[@"main_url_scheme"]) options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    NSTextCheckingResult* res = [regex firstMatchInString:url_str options:0 range:NSMakeRange(0, url_str.length)];
    
    if (res)
    {
        NSMutableDictionary* result = [NSMutableDictionary new];
        NSRange cmd_range = [res rangeAtIndex:1];
        result[@"cmd"] = [url_str substringWithRange:cmd_range];
        
        NSRange param1 = [res rangeAtIndex:2];
        if (param1.location != NSNotFound)
            result[@"param1"] = [url_str substringWithRange:param1];
        
        NSRange param2 = [res rangeAtIndex:3];
        if (param2.location != NSNotFound)
            result[@"param2"] = [url_str substringWithRange:param2];
        
        NSRange param3 = [res rangeAtIndex:4];
        if (param3.location != NSNotFound)
            result[@"param3"] = [url_str substringWithRange:param3];
        
        return result;
    }
    
    return nil;
    
}

+(id)fetchITunesAppItemID
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    //            appID = @"com.aiywa.ios";
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = data.jsonDic;
    if (_dic_ok2(lookup) && _arr_ok2(lookup[@"results"]) && lookup[@"results"][0][@"trackId"])
        return lookup[@"results"][0][@"trackId"];
    else
        return nil;
}

+(CGPoint)CGRect:(CGRect)rect mapPointInside:(CGPoint)point
{
    if (CGRectContainsPoint(rect, point))
        return point;
    
    CGPoint c = CGRectCenterPoint(rect);
    
    float m1 = CGRectGetHeight(rect) / CGRectGetWidth(rect);
    float m2 = -1.0f/m1;
    
    float m = (c.y - point.y) / (point.x - c.x);
    
    float h2 = CGRectGetHeight(rect)/2.0f;
    float w2 = CGRectGetWidth(rect)/2.0f;
    
    if (m > 0)
    {
        if (m > m1)
        {
            if (point.y < c.y)
                return CGPointMake(c.x + h2/m, CGRectGetMinY(rect));
            else
                return CGPointMake(c.x - h2/m, CGRectGetMaxY(rect));
        }
        else // (m <= m1)
        {
            if (point.x > c.x)
                return CGPointMake(CGRectGetMaxX(rect), c.y - w2*m);
            else
                return CGPointMake(CGRectGetMinX(rect), c.y + w2*m);
        }
    }
    else // m <= 0
    {
        if (-m > -m2)
        {
            if (point.y < c.y)
                return CGPointMake(c.x + h2/m, CGRectGetMinY(rect));
            else
                return CGPointMake(c.x - h2/m, CGRectGetMaxY(rect));
        }
        else //-m <= -m2
        {
            if (point.x < c.x)
                return CGPointMake(CGRectGetMinX(rect), c.y + w2*m);
            else
                return CGPointMake(CGRectGetMaxX(rect), c.y - w2*m);
        }
    }
}

+(NSString*)NSStringFromQueryParameters:(NSDictionary*)queryParameters
{
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],
                          [(_str_ok1(value) ? value : (_num_ok1(value) ? _strfmt(@"%@", value) : nil)) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]
                          ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}
@end

