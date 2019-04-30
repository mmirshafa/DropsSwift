//
//  HSLColorizationFilter.h
//  MACTehran Project
//
//  Created by Hamidreza Vakilian on Jan/16/2016.
//  Copyright (c) 2016 Hamidreza Vakilian. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface HSLColorizeFilter : CIFilter

@property (retain, nonatomic) CIImage *inputImage;
@property (nonatomic, assign) float hue;
@property (nonatomic, assign) float saturation;
@property (nonatomic, assign) float lightness;

@end
