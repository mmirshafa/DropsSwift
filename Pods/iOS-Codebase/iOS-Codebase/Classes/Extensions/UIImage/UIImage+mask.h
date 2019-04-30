//
//  UIImage+mask.h
//  macTehran
//
//  Created by Hamidreza Vaklian on 1/21/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (mask)

-(void)maskWithImage:(UIImage *)maskImage callback:(void (^)(UIImage* maskedImage))completionHandler;
-(UIImage*)maskWithImage:(UIImage *)maskImage;
-(UIImage*)blendUnderImage:(UIImage*)overlay;

@end
