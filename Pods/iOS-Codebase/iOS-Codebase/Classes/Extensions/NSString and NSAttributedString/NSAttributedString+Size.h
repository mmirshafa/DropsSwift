//
//  NSAttributedString+Height.h
//  Prediscore
//
//  Created by Hamidreza Vaklian on 4/29/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Size)

-(CGFloat)widthWithNoBoundingHeight;
-(CGFloat)heightWithBoundingWidth:(CGFloat)width;
-(CGFloat)widthWithBoundingHeight:(CGFloat)height;
-(CGFloat)heightWithBoundingWidth:(CGFloat)width andHeight:(CGFloat)height;

@end
