//
//  UINavigationController+Extensions.m
//  oncost
//
//  Created by Hamidreza Vakilian on 3/28/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "UINavigationController+Extensions.h"

@implementation UINavigationController (Extensions)

-(void)removeIntermediateVCs
{
    NSArray* vcs = self.viewControllers;
    NSMutableArray* arr = [NSMutableArray new];
    [arr addObject:vcs.firstObject];
    [arr addObject:vcs.lastObject];
    self.viewControllers = arr;
}

@end
