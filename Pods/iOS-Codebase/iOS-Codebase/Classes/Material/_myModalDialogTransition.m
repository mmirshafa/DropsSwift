//
//  _myModalDialogTransition.m
//  Kababchi
//
//  Created by hAmidReza on 6/10/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "_myModalDialogTransition.h"
#import "_myModalDialog.h"
#import "_loadingEnabledView.h"

@implementation _myModalDialogTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
	return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
	UIView *containerView = [transitionContext containerView];
	
	if (self.isPresenting)
	{
		//-------------------- GET TO & FROM VCS --------------------//
		UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
		_myModalDialog *myDialog = (_myModalDialog*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
		
		myDialog.visualEffectView.alpha = 0;
		myDialog.dimView.alpha = 0;
		myDialog.scrollViewYCentered.transform = CGAffineTransformMakeScale(0, 0);
		[containerView addSubview:myDialog.view];
		
		//-------------------- ANIMATION --------------------//
		[UIView animateWithDuration:animationDuration delay:0.0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:0 animations:^{
			if (!myDialog.transition_NoBackZoom)
				fromViewController.view.transform = CGAffineTransformMakeScale(.9, .9);
			myDialog.visualEffectView.alpha = 1.0f;
			myDialog.dimView.alpha = 1.0f;
			myDialog.scrollViewYCentered.transform = CGAffineTransformMakeScale(1, 1);
		} completion:^(BOOL finished) {
			
			[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
		}];
	}
	else //dismissal
	{
		_myModalDialog *myDialog = (_myModalDialog*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
		UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
		
		//		[containerView addSubview:chooseBranchDialog.view];
		
		
		[UIView animateWithDuration:.3 animations:^{
			myDialog.scrollViewYCentered.transform = CGAffineTransformMakeScale(0.01, 0.01);
			myDialog.scrollViewYCentered.alpha = 0;
			myDialog.visualEffectView.alpha = 0;
			myDialog.dimView.alpha = 0;
			
			if (!myDialog.transition_NoBackZoom)
				toViewController.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
			
		} completion:^(BOOL finished) {
			[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
		}];
	}
}


@end
