//
//  _presentationTransitionBase.m
//  mactehrannew
//
//  Created by hAmidReza on 6/3/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_presentationTransitionBase.h"

@interface _presentationTransitionBase ()

@end

@implementation _presentationTransitionBase

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
	_isPresenting = YES;
	return self;
}


-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
	_isPresenting = NO;
	return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
	return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
	UIView *containerView = [transitionContext containerView];
	
	if (_isPresenting)
	{
		//-------------------- GET TO & FROM VCS --------------------//
		UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
		UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
		[containerView addSubview:toVC.view];
		
		toVC.view.alpha = 0;
		
		//-------------------- ANIMATION --------------------//
		[UIView animateWithDuration:animationDuration delay:0.0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:0 animations:^{
//			//			fromViewController.view.transform = CGAffineTransformMakeScale(.9, .9);
//			newRateVC.backOverlay.alpha = .9;
//			newRateVC.boxView.alpha = 1;
//			newRateVC.iconHolderOuterCircle.transform = CGAffineTransformMakeScale(1, 1);
//			//			chooseBranchDialog.visualEffectView.alpha = 1.0f;
//			//			chooseBranchDialog.contentView.transform = CGAffineTransformMakeScale(1, 1);
					toVC.view.alpha = 1;
			fromVC.view.alpha = 0;
			
			
		} completion:^(BOOL finished) {
			
			[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
		}];
	}
	else //dismissal
	{
		UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
		UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
		
		[UIView animateWithDuration:.3 animations:^{
			fromVC.view.alpha = 0;
			toVC.view.alpha = 1;
//			newRateVC.iconHolderOuterCircle.transform = CGAffineTransformMakeScale(0, 0);
//			newRateVC.backOverlay.alpha = 0;
//			newRateVC.boxView.alpha = 0;
			//			chooseBranchDialog.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
			//			chooseBranchDialog.contentView.alpha = 0;
			//			chooseBranchDialog.visualEffectView.alpha = 0;
			//			toViewController.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
			
		} completion:^(BOOL finished) {
			[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
		}];
	}
}


@end
