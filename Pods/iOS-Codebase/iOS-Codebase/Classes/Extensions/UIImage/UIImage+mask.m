//
//  UIImage+mask.m
//  macTehran
//
//  Created by Hamidreza Vaklian on 1/21/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import "UIImage+mask.h"

@implementation UIImage (mask)

-(void)maskWithImage:(UIImage *)maskImage callback:(void (^)(UIImage* maskedImage))completionHandler {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage* maskedImage = [self maskWithImage:maskImage];
        if (completionHandler)
            completionHandler(maskedImage);
        
    });
}

-(UIImage*)maskWithImage:(UIImage*)maskImage
{
    
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef imageRef = self.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask(imageRef, mask);
    
    CGContextRef context = CGBitmapContextCreate(nil,
                                                 CGImageGetWidth(imageRef),
                                                 CGImageGetHeight(imageRef),
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 CGImageGetBytesPerRow(imageRef),
                                                 CGImageGetColorSpace(imageRef),
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGContextDrawImage(context, imageRect, masked);
    CGImageRef maskedImageRef = CGBitmapContextCreateImage(context);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
//    CGImageRelease(maskRef);
//    CGImageRelease(imageRef);
    CGImageRelease(mask);
    CGImageRelease(masked);
    CGImageRelease(maskedImageRef);
    CGContextRelease(context);
    
    return maskedImage;
}

-(UIImage *)blendUnderImage:(UIImage *)overlay
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef overlayRef = overlay.CGImage;
    
    CGContextRef context = CGBitmapContextCreate(nil,
                                                 CGImageGetWidth(imageRef),
                                                 CGImageGetHeight(imageRef),
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 CGImageGetBytesPerRow(imageRef),
                                                 CGImageGetColorSpace(imageRef),
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    
    CGContextDrawImage(context, imageRect, imageRef);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, imageRect, overlayRef);
    
//    [self drawInRect:imageRect];
//    [overlay drawInRect:imageRect blendMode:kCGBlendModeNormal alpha:1.0];
    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGImageRef finalImageRef = CGBitmapContextCreateImage(context);
        UIImage *finalImage = [UIImage imageWithCGImage:finalImageRef];
    
    UIGraphicsEndImageContext();
    
//    CGImageRelease(imageRef);
//    CGImageRelease(overlayRef);
    CGImageRelease(finalImageRef);
    CGContextRelease(context);
    return finalImage;
}

@end
