//
//  UIColor+colorWithHex.h
//  macTehran
//
//  Created by Hamidreza Vaklian on 1/18/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    double r;       // [0..1]
    double g;       // [0..1]
    double b;       // [0..1]
} rgb;

typedef struct {
    double h;       // [0..360]
    double s;       // [0..1]
    double l;       // [-1..0..+1]
} hsl;

#define HEXColor(color) [UIColor colorWithHexString:color]

@interface UIColor(Extensions)


/**
 Parses #RGBA / #RGB strings

 @param str [#]RGB[A]
 @return UIColor instance
 */
+(UIColor *)colorWithHexString:(NSString *)str;
-(bool)isBright;
-(rgb)get_rgb;
-(UIColor*)mixWithColor:(UIColor*)color mixAlpha:(BOOL)mixAlpha; //a1 will be used if mixAlpha = false;
-(UIColor*)sameColorAlpha:(float)alpha;
-(UIColor*)sameColorDiffLightness:(float)diff;
-(NSString*)cssString ;
-(NSString*)RGBA_string;
-(NSString*)ARGB_string;
@end

