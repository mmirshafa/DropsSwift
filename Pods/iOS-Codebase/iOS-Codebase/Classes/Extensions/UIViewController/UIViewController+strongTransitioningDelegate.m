//
//  UIViewController+stringTransitioningDelegate.m
//  mactehrannew
//
//  Created by hAmidReza on 6/3/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "UIViewController+strongTransitioningDelegate.h"
#import "NSObject+DataObject.h"

@implementation UIViewController (strongTransitioningDelegate)

-(void)setStrongTransitioningDelegate:(id<UIViewControllerTransitioningDelegate>)strongTransitioningDelegate
{
	[self setDataObject:strongTransitioningDelegate forKey:@"stringTransitioningDelegate"];
	self.transitioningDelegate = strongTransitioningDelegate;
}

-(id<UIViewControllerTransitioningDelegate>)strongTransitioningDelegate
{
	return [self dataObjectForKey:@"stringTransitioningDelegate"];
}

@end
