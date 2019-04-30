//
//  NSObject+Runtime.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 6/24/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Runtime.h"

@implementation NSObject (Runtime)

+ (void)swizzleMethod:(SEL)selector withMethod:(SEL)otherSelector
{
    // my own class is being targetted
    Class c = [self class];
    
    // get the methods from the selectors
    Method originalMethod = class_getInstanceMethod(c, selector);
    Method otherMethod = class_getInstanceMethod(c, otherSelector);
    
    if (class_addMethod(c, selector, method_getImplementation(otherMethod), method_getTypeEncoding(otherMethod)))
    {
        class_replaceMethod(c, otherSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, otherMethod);
    }
}

+ (void)swizzleClassMethod:(SEL)selector withMethod:(SEL)otherSelector
{
    // my own class is being targetted
    Class c = [self class];
    
    // get the methods from the selectors
    Method originalMethod = class_getClassMethod(c, selector);
    Method otherMethod = class_getClassMethod(c, otherSelector);
    
    //    if (class_addMethod(c, selector, method_getImplementation(otherMethod), method_getTypeEncoding(otherMethod)))
    //	{
    //		class_replaceMethod(c, otherSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    //	}
    //	else
    //	{
    method_exchangeImplementations(originalMethod, otherMethod);
    //	}
    
}

@end
