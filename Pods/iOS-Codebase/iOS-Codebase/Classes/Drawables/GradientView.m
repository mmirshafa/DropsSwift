//
//  DarkGradientView.m
//  macTehran
//
//  Created by Hamidreza Vaklian on 2/8/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import "GradientView.h"

@interface GradientView ()
{
    CGFloat* cg_colors;
    CGFloat* cg_locations;
}

@end

@implementation GradientView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, cg_colors, cg_locations, _colors.count);
    CGColorSpaceRelease(baseSpace);
    baseSpace = NULL;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    CGContextSetBlendMode(context, kCGBlendModeDarken);
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    
    CGPoint startPoint = _startPoint ? CGPointMake([_startPoint CGPointValue].x * CGRectGetWidth(rect), [_startPoint CGPointValue].y * CGRectGetHeight(rect)) : CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = _endPoint ? CGPointMake([_endPoint CGPointValue].x * CGRectGetWidth(rect), [_endPoint CGPointValue].y * CGRectGetHeight(rect)) : CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    gradient = NULL;
    
    CGContextRestoreGState(context);
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    [self setNeedsDisplay];
//}

-(void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(self.frame, frame))
    {
        [super setFrame:frame];
        [self setNeedsDisplay];
    }
}

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
    cg_colors = [GradientView colorNSArrayToCGArray:colors];
    [self setNeedsDisplay];
}

-(void)setLocations:(NSArray *)locations
{
    _locations = locations;
    cg_locations = [GradientView locationNSArrayToCGArray:locations];
    [self setNeedsDisplay];
}

+(CGFloat*)colorNSArrayToCGArray:(NSArray*)arr
{
    CGFloat* result = malloc(arr.count * sizeof(CGFloat) * 4);
    
    int i = 0;
    for (UIColor* aColor in arr)
    {
        CGFloat r;
        CGFloat g;
        CGFloat b;
        CGFloat a;
        [aColor getRed:&r green:&g blue:&b alpha:&a];
        result[i*4 + 0] = r;
        result[i*4 + 1] = g;
        result[i*4 + 2] = b;
        result[i*4 + 3] = a;
        i++;
    }
    return result;
}

+(CGFloat*)locationNSArrayToCGArray:(NSArray*)arr
{
    CGFloat* result = malloc(arr.count * sizeof(CGFloat));
    int i = 0;
    for (NSNumber* location in arr)
    {
        result[i] = [location floatValue];
        i++;
    }
    return result;
}

@end

