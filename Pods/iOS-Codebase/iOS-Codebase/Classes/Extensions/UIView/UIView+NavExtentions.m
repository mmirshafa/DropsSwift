//
//  UIView+NavExtentions.m
//  mactehrannew
//
//  Created by hAmidReza on 6/12/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "UIView+NavExtentions.h"

@implementation UIView (NavExtentions)

-(UIViewController *)getParentVC
{
	UIViewController* possibleVC = (id)[self nextResponder];
	UIView* superview = self;
	while (![possibleVC isKindOfClass:[UIViewController class]])
	{
		superview = [superview superview];
		if (!superview)
			return nil;
		possibleVC = (id)[superview nextResponder];
	}
	return possibleVC;
}

-(UINavigationController *)getParentNavC
{
	return [self getParentVC].navigationController;
}

@end
