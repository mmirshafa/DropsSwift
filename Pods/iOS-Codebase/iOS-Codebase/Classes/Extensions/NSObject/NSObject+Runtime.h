//
//  NSObject+Runtime.h
//  Prediscore
//
//  Created by Hamidreza Vaklian on 6/24/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)

+ (void)swizzleMethod:(SEL)selector withMethod:(SEL)otherSelector;
+ (void)swizzleClassMethod:(SEL)selector withMethod:(SEL)otherSelector;

@end
