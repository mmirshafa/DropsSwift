//
//  HSLColorizeFilter.cpp
//  macTehran
//
//  Created by Hamidreza Vaklian on 1/20/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

//#include <stdio.h>
#include "HSLColorizeFilterInverse.h"
//#include <math.h>

//float MIN(float x, float y)
//{
//    return x < y ? x : y;
//}
//
//float MAX(float x, float y)
//{
//    return x > y ? x : y;
//}

rgb calcT(float red, float green, float blue, float hue)
{
    hue = hue * 360;
    hue = hue / 6.0f;
    if (red == -1) //red is unkown
    {
        float max = MAX(green, blue);
        float min = MIN(green, blue);
        
        float delta = max - min;
        
        if( green == max )
            red = -hue * delta + 2.0 + blue;	// between cyan & yellow
        else
            red = hue * delta - 4.0 + green;	// between magenta & cyan
        
        rgb output = {red, green, blue};
        return output;
    }
    else
    {
		rgb k = {0, 0, 0};
        return k;
    }
}

hsl calculateTransform_new(rgb src, rgb dest)
{
    float H, S, L;
    float l1 = ( MIN(MIN(src.r, src.g),src.b) + MAX(MAX(src.r, src.g),src.b) ) / 2.0f;
//    float l2 = ( MIN(MIN(dest.r, dest.g),dest.b) + MAX(MAX(dest.r, dest.g),dest.b) ) / 2.0f;
    H = rgb2hsl(dest).h;
    hsl maxSatColor = {H, 1.0f, 1.0f};
    rgb color_s = hsl2rgb(maxSatColor);
    
    if (color_s.r == 0) //red min
    {
        if (color_s.g == 1) //green max
        {
            float delta = dest.g - dest.r;
            S = -l1*delta / (color_s.b*delta - l1*delta - dest.b);
            L = dest.r / ( l1 * (1.0f - S) ) - 1.0f;
        }
        else // blue max
        {
            float delta = dest.r - dest.b;
            S = -l1*delta / (color_s.g*delta - l1*delta - dest.g);
            L = dest.b / ( l1 * (1.0f - S) ) - 1.0f;
        }
    }
    else if (color_s.g == 0) //green min
    {
        if (color_s.r == 1) //red max
        {
            float delta = dest.r - dest.g;
            S = -l1*delta / (color_s.b*delta - l1*delta - dest.b);
            L = dest.g / ( l1 * (1.0f - S) ) - 1.0f;
        }
        else //blue max
        {
            float delta = dest.b - dest.g;
            S = -l1*delta / (color_s.r*delta - l1*delta - dest.r);
            L = dest.g / ( l1 * (1.0f - S) ) - 1.0f;
        }
    }
    else // blue min
    {
        if (color_s.r == 1) //red max
        {
            float delta = dest.r - dest.b;
            S = -l1*delta / (color_s.g*delta - l1*delta - dest.g);
            L = dest.b / ( l1 * (1.0f - S) ) - 1.0f;
        }
        else //green max
        {
            float delta = dest.g - dest.r;
            S = -l1*delta / (color_s.b*delta - l1*delta - dest.b);
            L = dest.r / ( l1 * (1.0f - S) ) - 1.0f;
        }
    }
    
    hsl result = {H, S, L};
    return result;
    
}

hsl calculateTransform(rgb src, rgb dest)
{
    double H, S, L;
    H = rgb2hsl(dest).h;//1
    double l1 = (MIN(MIN(src.r, src.g), src.b) + MAX(MAX(src.r, src.g), src.b))/2.0;
    double l2 = (MIN(MIN(dest.r, dest.g), dest.b) + MAX(MAX(dest.r, dest.g), dest.b))/2.0;
    if (l2 > l1)
        L = (l2-l1)/(1.0-l1);
    else
        L = (l2-l1)/l1;
    
    hsl colorhsl;
    colorhsl.h = H;
    colorhsl.s = .5;
    colorhsl.l = 1.0;
    
    rgb colorRGB = hsl2rgb(colorhsl);
    if (colorRGB.r >= colorRGB.g && colorRGB.r >= colorRGB.b) //red max
    {
        double rMax;
        if (2*l2 > 1.0)
            rMax = 1.0;
        else
            rMax = 2*l2;
        
        S = (dest.r - l2) / (rMax - l2);
    }
    else if (colorRGB.g >= colorRGB.r && colorRGB.g >= colorRGB.b) //green max
    {
        double gMax;
        if (2*l2 > 1.0)
            gMax = 1.0;
        else
            gMax = 2*l2;
        
        S = (dest.g - l2) / (gMax - l2);
    }
    else if (colorRGB.b >= colorRGB.r && colorRGB.b >= colorRGB.g) //blue max
    {
        double bMax;
        if (2*l2 > 1.0)
            bMax = 1.0;
        else
            bMax = 2*l2;
        
        S = (dest.b - l2) / (bMax - l2);
    }
    
    hsl result;
    result.h = H;
    result.s = S;
    result.l = L;
    
    return result;
}

rgb transformColor_new(rgb color, float hue, float saturation, float lightness)
{
    float l = ( MIN(color.r, MIN(color.g, color.b)) + MAX(color.r, MAX(color.g, color.b)) ) / 2.0;
    
    float lprim = l;
    
//    if (lightness <= 0.0)
//        lprim = (1.0+lightness)*l;
//    else
//        lprim = (1.0-lightness)*l + lightness;
    
    hsl hueHSL = {hue, 1.0f, 1.0f};
    rgb hueRGB = hsl2rgb(hueHSL);
    
    rgb maxSatRGB;
    
    float h;
    
    h = hue * 360.0 / 60.0;
    
    if (hueRGB.r >= hueRGB.g && hueRGB.r >= hueRGB.b) //red max
    {
        if (hueRGB.b < hueRGB.g) //blue min
        {
            if (2.0*lprim > 1.0)
            {
                maxSatRGB.r = 1.0;
                maxSatRGB.b = 2.0*lprim - 1.0;
            }
            else
            {
                maxSatRGB.r = 2.0*lprim;
                maxSatRGB.b = 0.0;
            }
            
            //calculate green
            float delta = maxSatRGB.r - maxSatRGB.b;
            maxSatRGB.g = delta * h + maxSatRGB.b;
            
            
            while (maxSatRGB.g > 1.0 || maxSatRGB.g > maxSatRGB.r)
                maxSatRGB.g -= 6.0*delta;
            
            while (maxSatRGB.g < 0.0 || maxSatRGB.g < maxSatRGB.b)
                maxSatRGB.g += 6.0*delta;
            
        }
        else // green min
        {
            if (2.0*lprim > 1.0)
            {
                maxSatRGB.r = 1.0;
                maxSatRGB.g = 2.0*lprim - 1.0;
            }
            else
            {
                maxSatRGB.r = 2.0*lprim;
                maxSatRGB.g = 0.0;
            }
            
            //calculate blue
            float delta = maxSatRGB.r - maxSatRGB.g;
            maxSatRGB.b = maxSatRGB.g - delta * h;
            
            while (maxSatRGB.b > 1.0 || maxSatRGB.b > maxSatRGB.r)
                maxSatRGB.b -= 6.0*delta;
            
            while (maxSatRGB.b < 0.0 || maxSatRGB.b < maxSatRGB.g)
                maxSatRGB.b += 6.0*delta;
            
        }
    }
    else if (hueRGB.g >= hueRGB.r && hueRGB.g >= hueRGB.b) //green max
    {
        if (hueRGB.r < hueRGB.b) //red min
        {
            if (2.0*lprim > 1.0)
            {
                maxSatRGB.g = 1.0;
                maxSatRGB.r = 2.0*lprim - 1.0;
            }
            else
            {
                maxSatRGB.g = 2.0*lprim;
                maxSatRGB.r = 0.0;
            }
            
            //calculate blue
            float delta = maxSatRGB.g - maxSatRGB.r;
            maxSatRGB.b = delta * (h - 2.0) + maxSatRGB.r;
            
            while (maxSatRGB.b > 1.0)
                maxSatRGB.b -= 6.0*delta;
            
            while (maxSatRGB.b < 0.0)
                maxSatRGB.b += 6.0*delta;
        }
        else // blue min
        {
            if (2.0*lprim > 1.0)
            {
                maxSatRGB.g = 1.0;
                maxSatRGB.b = 2.0*lprim - 1.0;
            }
            else
            {
                maxSatRGB.g = 2.0*lprim;
                maxSatRGB.b = 0.0;
            }
            
            //calculate red
            float delta = maxSatRGB.g - maxSatRGB.b;
            maxSatRGB.r = maxSatRGB.b - delta * (h - 2.0);
            
            while (maxSatRGB.r > 1.0)
                maxSatRGB.r -= 6.0*delta;
            
            while (maxSatRGB.r < 0.0)
                maxSatRGB.r += 6.0*delta;
        }
    }
    else if (hueRGB.b >= hueRGB.r && hueRGB.b >= hueRGB.g) //blue max
    {
        if (hueRGB.r < hueRGB.g) //red min
        {
            if (2.0*lprim > 1.0)
            {
                maxSatRGB.b = 1.0;
                maxSatRGB.r = 2.0*lprim - 1.0;
            }
            else
            {
                maxSatRGB.b = 2.0*lprim;
                maxSatRGB.r = 0.0;
            }
            
            //calculate green
            float delta = maxSatRGB.b - maxSatRGB.r;
            maxSatRGB.g = maxSatRGB.r - delta * (h - 4.0) ;
            
            while (maxSatRGB.g > 1.0)
                maxSatRGB.g -= 6.0*delta;
            
            while (maxSatRGB.g < 0.0)
                maxSatRGB.g += 6.0*delta;
            
        }
        else // green min
        {
            if (2.0*lprim > 1.0)
            {
                maxSatRGB.b = 1.0;
                maxSatRGB.g = 2.0*lprim - 1.0;
            }
            else
            {
                maxSatRGB.b = 2.0*lprim;
                maxSatRGB.g = 0.0;
            }
            
            //calculate red
            float delta = maxSatRGB.b - maxSatRGB.g;
            maxSatRGB.r = delta * (h - 4.0) + maxSatRGB.g;
            
            while (maxSatRGB.r > 1.0)
                maxSatRGB.r -= 6.0*delta;
            
            while (maxSatRGB.r < 0.0)
                maxSatRGB.r += 6.0*delta;
        }
    }
    
    
    rgb saturatedColor = {
        (1.0 - saturation)*lprim + saturation*maxSatRGB.r,
        (1.0 - saturation)*lprim + saturation*maxSatRGB.g,
        (1.0 - saturation)*lprim + saturation*maxSatRGB.b};
    
    
    rgb finalColor;
    if (lightness < 0)
    {
        finalColor.r = saturatedColor.r * (1.0f + lightness);
        finalColor.g = saturatedColor.g * (1.0f + lightness);
        finalColor.b = saturatedColor.b * (1.0f + lightness);
    }
    else
    {
        finalColor.r = saturatedColor.r * (1.0f - lightness) + lightness;
        finalColor.g = saturatedColor.g * (1.0f - lightness) + lightness;
        finalColor.b = saturatedColor.b * (1.0f - lightness) + lightness;
    }
    
    
    color.r		= finalColor.r;
    color.g		= finalColor.g;
    color.b		= finalColor.b;
    
    return color;
}


rgb transformColor(rgb color, float hue, float saturation, float lightness)
{
    float l = ( MIN(color.r, MIN(color.g, color.b)) + MAX(color.r, MAX(color.g, color.b)) ) / 2.0;
    
    float lprim;
    
    if (lightness <= 0.0)
        lprim = (1.0+lightness)*l;
    else
        lprim = (1.0-lightness)*l + lightness;
    
    hsl hueHSL = {hue, .5, 1.0};
    rgb hueRGB = hsl2rgb(hueHSL);
    
    rgb maxSatRGB;
    
    float h;
    
    h = hue * 360.0 / 60.0;
    
    if (hueRGB.r >= hueRGB.g && hueRGB.r >= hueRGB.b) //red max
    {
        if (hueRGB.b < hueRGB.g) //blue min
        {
            if (2.0*lprim > 1.0)
            {
                maxSatRGB.r = 1.0;
                maxSatRGB.b = 2.0*lprim - 1.0;
            }
            else
            {
                maxSatRGB.r = 2.0*lprim;
                maxSatRGB.b = 0.0;
            }
            
            //calculate green
            float delta = maxSatRGB.r - maxSatRGB.b;
            maxSatRGB.g = delta * h + maxSatRGB.b;
            
            
            while (maxSatRGB.g > 1.0)
                maxSatRGB.g -= 6.0*delta;
            
            while (maxSatRGB.g < 0.0)
                maxSatRGB.g += 6.0*delta;
            
        }
        else // green min
        {
            if (2.0*lprim > 1.0)
            {
                maxSatRGB.r = 1.0;
                maxSatRGB.g = 2.0*lprim - 1.0;
            }
            else
            {
                maxSatRGB.r = 2.0*lprim;
                maxSatRGB.g = 0.0;
            }
            
            //calculate blue
            float delta = maxSatRGB.r - maxSatRGB.g;
            maxSatRGB.b = maxSatRGB.g - delta * h;
            
            while (maxSatRGB.b > 1.0)
                maxSatRGB.b -= 6.0*delta;
            
            while (maxSatRGB.b < 0.0)
                maxSatRGB.b += 6.0*delta;
            
        }
    }
    else if (hueRGB.g >= hueRGB.r && hueRGB.g >= hueRGB.b) //green max
    {
        if (hueRGB.r < hueRGB.b) //red min
        {
            if (2.0*lprim > 1.0)
            {
                maxSatRGB.g = 1.0;
                maxSatRGB.r = 2.0*lprim - 1.0;
            }
            else
            {
                maxSatRGB.g = 2.0*lprim;
                maxSatRGB.r = 0.0;
            }
            
            //calculate blue
            float delta = maxSatRGB.g - maxSatRGB.r;
            maxSatRGB.b = delta * (h - 2.0) + maxSatRGB.r;
            
            while (maxSatRGB.b > 1.0)
                maxSatRGB.b -= 6.0*delta;
            
            while (maxSatRGB.b < 0.0)
                maxSatRGB.b += 6.0*delta;
        }
        else // blue min
        {
            if (2.0*lprim > 1.0)
            {
                maxSatRGB.g = 1.0;
                maxSatRGB.b = 2.0*lprim - 1.0;
            }
            else
            {
                maxSatRGB.g = 2.0*lprim;
                maxSatRGB.b = 0.0;
            }
            
            //calculate red
            float delta = maxSatRGB.g - maxSatRGB.b;
            maxSatRGB.r = maxSatRGB.b - delta * (h - 2.0);
            
            while (maxSatRGB.r > 1.0)
                maxSatRGB.r -= 6.0*delta;
            
            while (maxSatRGB.r < 0.0)
                maxSatRGB.r += 6.0*delta;
        }
    }
    else if (hueRGB.b >= hueRGB.r && hueRGB.b >= hueRGB.g) //blue max
    {
        if (hueRGB.r < hueRGB.g) //red min
        {
            if (2.0*lprim > 1.0)
            {
                maxSatRGB.b = 1.0;
                maxSatRGB.r = 2.0*lprim - 1.0;
            }
            else
            {
                maxSatRGB.b = 2.0*lprim;
                maxSatRGB.r = 0.0;
            }
            
            //calculate green
            float delta = maxSatRGB.b - maxSatRGB.r;
            maxSatRGB.g = maxSatRGB.r - delta * (h - 4.0) ;
            
            while (maxSatRGB.g > 1.0)
                maxSatRGB.g -= 6.0*delta;
            
            while (maxSatRGB.g < 0.0)
                maxSatRGB.g += 6.0*delta;
            
        }
        else // green min
        {
            if (2.0*lprim > 1.0)
            {
                maxSatRGB.b = 1.0;
                maxSatRGB.g = 2.0*lprim - 1.0;
            }
            else
            {
                maxSatRGB.b = 2.0*lprim;
                maxSatRGB.g = 0.0;
            }
            
            //calculate red
            float delta = maxSatRGB.b - maxSatRGB.g;
            maxSatRGB.r = delta * (h - 4.0) + maxSatRGB.g;
            
            while (maxSatRGB.r > 1.0)
                maxSatRGB.r -= 6.0*delta;
            
            while (maxSatRGB.r < 0.0)
                maxSatRGB.r += 6.0*delta;
        }
    }
    
    
    rgb finalColor = {
    (1.0 - saturation)*lprim + saturation*maxSatRGB.r,
    (1.0 - saturation)*lprim + saturation*maxSatRGB.g,
    (1.0 - saturation)*lprim + saturation*maxSatRGB.b};

    
    color.r		= finalColor.r;
    color.g		= finalColor.g;
    color.b		= finalColor.b;
    
    return color;
}


rgb transfromColor2(rgb color, float hue, float saturation, float lightness)
{
    
    float l = ( MIN(color.r, MIN(color.g, color.b)) + MAX(color.r, MAX(color.g, color.b)) ) / 2.0;
    
    hsl maxSatHSL;
    maxSatHSL.h = hue;
    maxSatHSL.s = 1.0;
    maxSatHSL.l = 1.0;
    
    rgb maxSatRGB = hsl2rgb(maxSatHSL);
    
    rgb color2;
    color2.r = maxSatRGB.r * (saturation) + l * (1.0f - saturation);
    color2.g = maxSatRGB.g * (saturation) + l * (1.0f - saturation);
    color2.b = maxSatRGB.b * (saturation) + l * (1.0f - saturation);
    
    rgb finalColor;
    
    if (lightness < 0)
    {
        finalColor.r = color2.r * (1.0 + lightness);
        finalColor.g = color2.g * (1.0 + lightness);
        finalColor.b = color2.b * (1.0 + lightness);
    }
    else
    {
        finalColor.r = color2.r * (1.0f - lightness) + lightness * 1.0;
        finalColor.g = color2.g * (1.0f - lightness) + lightness * 1.0;
        finalColor.b = color2.b * (1.0f - lightness) + lightness * 1.0;
    }
    
    return finalColor;
}

hsl rgb2hsl(rgb in)
{
    hsl         out;
    double      min, max, delta;
    
    min = in.r < in.g ? in.r : in.g;
    min = min  < in.b ? min  : in.b;
    
    max = in.r > in.g ? in.r : in.g;
    max = max  > in.b ? max  : in.b;
    
    out.l = max;                                // v
    delta = max - min;
    if (delta < 0.00001)
    {
        out.s = 0;
        out.h = 0; // undefined, maybe nan?
        return out;
    }
    if( max > 0.0 ) { // NOTE: if Max is == 0, this divide would cause a crash
        out.s = (delta / max);                  // s
    } else {
        // if max is 0, then r = g = b = 0
        // s = 0, v is undefined
        out.s = 0.0;
        out.h = 0.0 / 0.0;                            // its now undefined
        return out;
    }
    if( in.r >= max )                           // > is bogus, just keeps compilor happy
        out.h = ( in.g - in.b ) / delta;        // between yellow & magenta
    else
        if( in.g >= max )
            out.h = 2.0 + ( in.b - in.r ) / delta;  // between cyan & yellow
        else
            out.h = 4.0 + ( in.r - in.g ) / delta;  // between magenta & cyan
    
    out.h *= 60.0;                              // degrees
    
    if( out.h < 0.0 )
        out.h += 360.0;
    
    out.h /= 360.0f;
    
    return out;
}


rgb hsl2rgb(hsl in)
{
    double      hh, p, q, t, ff;
    long        i;
    rgb         out;
    
    if(in.s <= 0.0) {       // < is bogus, just shuts up warnings
        out.r = in.l;
        out.g = in.l;
        out.b = in.l;
        return out;
    }
    hh = in.h * 360;
    if(hh >= 360.0) hh = 0.0;
    hh /= 60.0;
    i = (long)hh;
    ff = hh - i;
    p = in.l * (1.0 - in.s);
    q = in.l * (1.0 - (in.s * ff));
    t = in.l * (1.0 - (in.s * (1.0 - ff)));
    
    switch(i) {
        case 0:
            out.r = in.l;
            out.g = t;
            out.b = p;
            break;
        case 1:
            out.r = q;
            out.g = in.l;
            out.b = p;
            break;
        case 2:
            out.r = p;
            out.g = in.l;
            out.b = t;
            break;
            
        case 3:
            out.r = p;
            out.g = q;
            out.b = in.l;
            break;
        case 4:
            out.r = t;
            out.g = p;
            out.b = in.l;
            break;
        case 5:
        default:
            out.r = in.l;
            out.g = p;
            out.b = q;
            break;
    }
    return out;
}
