//
//  HSLColorizationFilter.m
//  MACTehran Project
//
//  Created by Hamidreza Vakilian on Jan/16/2016.
//  Copyright (c) 2016 Hamidreza Vakilian. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import "HSLColorizeFilter.h"
#import "helper.h"

@implementation HSLColorizeFilter

@synthesize inputImage, hue, saturation, lightness;

static CIKernel *colorizeFilter = nil;

- (CIKernel *)HSLColorizeFilter
{
    NSError     *error = nil;
    NSString    *code = [NSString stringWithContentsOfFile:[[helper theBundle] pathForResource:@"HSLColorizeFilter" ofType:@"cikernel"] encoding:NSUTF8StringEncoding error:&error];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorizeFilter = [CIKernel kernelWithString:code];
    });

    return colorizeFilter;
}

- (CIImage *)outputImage
{
    CIImage *result = self.inputImage;
    
    float h = self.hue;
    
    return [[self HSLColorizeFilter] applyWithExtent:result.extent roiCallback:^CGRect(int index, CGRect rect) {
        return CGRectMake(0, 0, CGRectGetWidth(result.extent), CGRectGetHeight(result.extent));
    } arguments:@[result, @(h), @(saturation), @(lightness)]];
}

@end
