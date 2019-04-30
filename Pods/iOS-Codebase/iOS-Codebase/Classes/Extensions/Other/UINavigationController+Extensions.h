//
//  UINavigationController+Extensions.h
//  oncost
//
//  Created by Hamidreza Vakilian on 3/28/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extensions)


/**
 keeps the first and last viewControllers and removes the intermediate vcs from navigation stack.
 */
-(void)removeIntermediateVCs;

@end
