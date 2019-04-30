//
//  _presentationTransitionBase.h
//  mactehrannew
//
//  Created by hAmidReza on 6/3/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _presentationTransitionBase : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) BOOL isPresenting;

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
