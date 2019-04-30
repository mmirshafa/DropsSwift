//
//  UIColor+colorWithHex.m
//  macTehran
//
//  Created by Hamidreza Vaklian on 1/18/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import "UIColor+Extensions.h"

typedef enum : NSUInteger {
    ColorTypeRGBA,
    ColorTypeARGB,
} ColorType;

@implementation UIColor(Extensions)

-(rgb)get_rgb
{
    rgb result;
    [self getRed:&result.r green:&result.g blue:&result.b alpha:NULL];
    return result;
}

- (uint)hex:(ColorType)colorType {
    CGFloat red, green, blue, alpha;
    if (![self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        [self getWhite:&red alpha:&alpha];
        green = red;
        blue = red;
    }
    
    red = roundf(red * 255.f);
    green = roundf(green * 255.f);
    blue = roundf(blue * 255.f);
    alpha = roundf(alpha * 255.f);
    
    if (colorType == ColorTypeARGB)
        return ((uint)alpha << 24) | ((uint)red << 16) | ((uint)green << 8) | ((uint)blue);
    else if (colorType == ColorTypeRGBA)
            return ((uint)red << 24) | ((uint)green << 16) | ((uint)blue << 8) | (uint)alpha;
    else
        return 0;
}

- (NSString*)cssString
{
    return [self ARGB_string];
}

- (NSString*)ARGB_string {
    uint hex = [self hex:ColorTypeARGB];
    if ((hex & 0xFF000000) == 0xFF000000)
        return [NSString stringWithFormat:@"#%06x", hex & 0xFFFFFF];
    
    return [NSString stringWithFormat:@"#%08x", hex];
}

// takes @"#RRGGBB" or @"0xRRGGBBAA"
+ (UIColor *)colorWithHexString:(NSString *)str {
    if (!str || !str.length)
        return [UIColor blackColor];
    if ([str containsString:@"#"])
        str = [str stringByReplacingOccurrencesOfString:@"#" withString:@""];
    str = [str lowercaseString];
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    UInt64 x = strtouq(cStr, NULL, 16);
    if (str.length == 6)
        return [UIColor colorWith6DigitHex:(UInt64)x];
    else if (str.length == 8)
        return [UIColor colorWith8DigitHex:(UInt64)x];
    else return [UIColor blackColor];
    
}

// takes 0xRRGGBB
+ (UIColor *)colorWith6DigitHex:(UInt64)col {
    
    unsigned char r, g, b;
    
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
    
}

//takes 0xRRGGBBAA
+ (UIColor *)colorWith8DigitHex:(UInt64)col {
    
    unsigned char r, g, b, a;
    
    a = col & 0xFF;
    b = (col >> 8) & 0xFF;
    g = (col >> 16) & 0xFF;
    r = (col >> 24) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:(float)a/255.0f];
    
}

-(bool)isBright
{
    CGFloat r,g,b;
    [self getRed:&r green:&g blue:&b alpha:nil];
    CGFloat l = (MAX(MAX(r,g), b) + MIN(MIN(r, g), b))/2;
    if (l >= .5)
        return true;
    else return false;
}

-(UIColor*)mixWithColor:(UIColor*)color mixAlpha:(BOOL)mixAlpha //a1 will be used if mixAlpha = false
{
    CGFloat r1;
    CGFloat r2;
    CGFloat g1;
    CGFloat g2;
    CGFloat b1;
    CGFloat b2;
    CGFloat a1;
    CGFloat a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    return [UIColor colorWithRed:(r1+r2)/2.0f green:(g1+g2)/2.0f blue:(b1+b2)/2.0f alpha:mixAlpha ? (a1+a2)/2.0f : a1];
}

-(UIColor*)sameColorAlpha:(float)alpha
{
    CGFloat r;
    CGFloat g;
    CGFloat b;
    [self getRed:&r green:&g blue:&b alpha:NULL];
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    
}

-(UIColor*)sameColorDiffLightness:(float)diff
{
    CGFloat h;
    CGFloat s;
    CGFloat b;
    CGFloat a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    
    return [UIColor colorWithHue:h saturation:s brightness:MAX(MIN(b + diff, 1.0), 0.0) alpha:a];
}


/***********/

//- (uint)rgbaHEX {
//    CGFloat red, green, blue, alpha;
//    if (![self getRed:&red green:&green blue:&blue alpha:&alpha]) {
//        [self getWhite:&red alpha:&alpha];
//        green = red;
//        blue = red;
//    }
//
//    red = roundf(red * 255.f);
//    green = roundf(green * 255.f);
//    blue = roundf(blue * 255.f);
//    alpha = roundf(alpha * 255.f);
//
//    return ((uint)red << 24) | ((uint)green << 16) | ((uint)blue << 8) | (uint)alpha;
//}

-(NSString*)RGBA_string
{
    uint hex = [self hex:ColorTypeRGBA];
    if ((hex & 0xFF) == 0xFF)
        return [NSString stringWithFormat:@"#%06x", hex >> 8];
    
    return [NSString stringWithFormat:@"#%08x", hex];
}

//+(UIColor*)parseRGBA:(NSString*)rgbaString
//{
//    if ([rgbaString characterAtIndex:0] == '#')
//        rgbaString = [rgbaString substringFromIndex:1];
//
//    const char *cStr = [rgbaString cStringUsingEncoding:NSASCIIStringEncoding];
//    UInt64 col = strtouq(cStr, NULL, 16);
//
//    if (rgbaString.length == 6)
//    {
//        unsigned char r, g, b;
//
//        b = col & 0xFF;
//        g = (col >> 8) & 0xFF;
//        r = (col >> 16) & 0xFF;
//        return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
//    }
//    else if (rgbaString.length == 8)
//    {
//        unsigned char r, g, b, a;
//        a = col & 0xFF;
//        b = (col >> 8) & 0xFF;
//        g = (col >> 16) & 0xFF;
//        r = (col >> 24) & 0xFF;
//        return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:(float)a/255.0f];
//    }
//    else return [UIColor blackColor];
//}

@end

