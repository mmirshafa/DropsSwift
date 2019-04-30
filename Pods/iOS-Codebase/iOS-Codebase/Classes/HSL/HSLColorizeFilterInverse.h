//
//  HSLColorizeFilterInverse.h
//  MACTehran Project
//
//  Created by Hamidreza Vaklian on 1/14/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import "UIColor+Extensions.h"

#ifndef HSLColorizeFilterInverse_h
#define HSLColorizeFilterInverse_h

#ifdef __cplusplus
extern "C" {
#endif

hsl   rgb2hsl(rgb in);
rgb   hsl2rgb(hsl in);
hsl calculateTransform(rgb src, rgb dest);
//rgb transformColor(rgb color, float hue, float saturation, float lightness);
//rgb transformColor_new(rgb color, float hue, float saturation, float lightness);
//rgb calcT(float red, float green, float blue, float hue);
    
#ifdef __cplusplus
}
#endif


#endif /* HSLColorizeFilterInverse_h */
