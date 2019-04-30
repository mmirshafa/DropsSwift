//
//  UIScrollView+Extensions.m
//  DZNEmptyDataSet
//
//  Created by Hamidreza Vakilian on 3/17/1397 AP.
//

#import "UIScrollView+Extensions.h"

@implementation UIScrollView (Extensions)

-(void)noAutoInset
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
    if ([self isKindOfClass:[UIScrollView class]])
    {
        if ([self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)])
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#pragma clang diagnostic pop
}

@end
