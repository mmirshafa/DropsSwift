//
//  MATRadioBox.m
//  mactehrannew
//
//  Created by hAmidReza on 8/9/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "MATRadioBox.h"
#import "Codebase_definitions.h"
#import "MyShapeView.h"
#import <POP/pop.h>
#import "UIView+SDCAutoLayout.h"
#import "UIView+Extensions.h"
#import "UIColor+Extensions.h"
#import "Codebase.h"

@interface MATRadioBox ()
{
	BOOL needsRefresh;
}

@property (retain, nonatomic) UIView* contents;
@property (retain, nonatomic) MyShapeView* outerCircle;
@property (retain, nonatomic) MyShapeView* innerCircle;
@property (retain, nonatomic) UIView* impressionHolder;
@property (retain, nonatomic) MyShapeView* impressionCircle;

@end

@implementation MATRadioBox


NSArray* k_iconOuterCircle() {
	
	static NSArray* result;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		result =
		@[
		  @{@"conf": @{@"size": @[@108.87,@108.87]}},
		  @[@"m", @54.43, @12.16],
		  @[@"l", @54.43, @108.87],
		  @[@"c", @-0.00, @54.43, @24.42, @108.87, @-0.00, @84.45],
		  @[@"c", @54.43, @-0.00, @-0.00, @24.42, @24.42, @-0.00],
		  @[@"c", @108.87, @54.43, @84.45, @-0.00, @108.87, @24.42],
		  @[@"c", @54.43, @108.87, @108.87, @84.45, @84.45, @108.87],
		  @[@"l", @54.43, @12.16],
		  @[@"c", @12.16, @54.43, @31.12, @12.16, @12.16, @31.12],
		  @[@"c", @54.43, @96.71, @12.16, @77.74, @31.12, @96.71],
		  @[@"c", @96.71, @54.43, @77.75, @96.71, @96.71, @77.74],
		  @[@"c", @54.43, @12.16, @96.71, @31.12, @77.75, @12.16],
		  ]
		;
	});
	return result;
}

NSArray* k_iconInnerCircle() {
	
	static NSArray* result;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		result =
		@[
		  @{@"conf": @{@"size": @[@108.87,@108.87]}},
		  @[@"m", @80.18, @54.43],
		  @[@"c", @54.43, @80.18, @80.18, @68.65, @68.65, @80.18],
		  @[@"c", @28.69, @54.43, @40.22, @80.18, @28.69, @68.65],
		  @[@"c", @54.43, @28.69, @28.69, @40.22, @40.22, @28.69],
		  @[@"c", @80.18, @54.43, @68.65, @28.69, @80.18, @40.22],
		  ];
	});
	return result;
}

-(void)initialize
{
	[super initialize];
	
	self.exclusiveTouch = YES;
	
	_animationDuration = .3;
	_primaryColor = rgba(48, 125, 252, 1.000);
	_inactiveColor = [UIColor grayColor];
	_impressionCircleAlphaBlendingValue = .2;
	_bounceRatio = 1.08f;
	_bounceDuration = .5;
	
	_contents = [UIView new2];
	_contents.userInteractionEnabled = NO;
	[self addSubview:_contents];
	[_contents sdc_pinCubicSize:22];
	[_contents sdc_centerInSuperview];
	
	_outerCircle = [[MyShapeView alloc] initWithShapeDesc:k_iconOuterCircle() andShapeTintColor:[UIColor blackColor]];
	_outerCircle.userInteractionEnabled = NO;
	_outerCircle.translatesAutoresizingMaskIntoConstraints = NO;
	[_contents addSubview:_outerCircle];
	[_outerCircle sdc_alignEdgesWithSuperview:UIRectEdgeAll];
	
	_innerCircle = [[MyShapeView alloc] initWithShapeDesc:k_iconInnerCircle() andShapeTintColor:[UIColor blackColor]];
	_innerCircle.userInteractionEnabled = NO;
	_innerCircle.translatesAutoresizingMaskIntoConstraints = NO;
	[_contents addSubview:_innerCircle];
	[_innerCircle sdc_alignEdgesWithSuperview:UIRectEdgeAll];
	
	_impressionHolder = [UIView new];
	_impressionHolder.userInteractionEnabled = NO;
	_impressionHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[_contents addSubview:_impressionHolder];
	[_impressionHolder sdc_alignEdgesWithSuperview:UIRectEdgeAll];
	
	_impressionCircle = [[MyShapeView alloc] initWithShapeDesc:k_iconInnerCircle() andShapeTintColor:[UIColor blackColor]];
	_impressionCircle.alpha = 0;
	_impressionCircle.translatesAutoresizingMaskIntoConstraints = NO;
	[_impressionHolder addSubview:_impressionCircle];
	[_impressionCircle sdc_alignEdgesWithSuperview:UIRectEdgeAll];
	
	
	[self updateBounceAnimation];
	
	[self setNeedsRefresh];
}

-(void)setBounceRatio:(CGFloat)bounceRatio
{
	_bounceRatio = bounceRatio;
	[self updateBounceAnimation];
}

-(void)setBounceDuration:(float)bounceDuration
{
	_bounceDuration = bounceDuration;
	[self updateBounceAnimation];
}

-(void)updateBounceAnimation
{
	[_impressionHolder pop_removeAnimationForKey:@"bounce"];
	POPBasicAnimation* circleBounce = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	circleBounce.fromValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
	circleBounce.toValue = [NSValue valueWithCGSize:CGSizeMake(_bounceRatio, _bounceRatio)];
	circleBounce.repeatForever = YES;
	circleBounce.autoreverses = YES;
	circleBounce.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	circleBounce.duration = _bounceDuration;
	[_impressionHolder pop_addAnimation:circleBounce forKey:@"bounce"];
}

-(void)refreshUI
{
	if (_on)
	{
		[CATransaction begin];
		[CATransaction setAnimationDuration:_animationDuration];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		
		_outerCircle.shapeTintColor = _primaryColor;
		_innerCircle.shapeTintColor = _primaryColor;
		_impressionCircle.shapeTintColor = [_primaryColor sameColorAlpha:_impressionCircleAlphaBlendingValue];
		[CATransaction commit];
//		_innerCircle.transform = CGAffineTransformMakeScale(1, 1);
		_innerCircle.alpha = 1;
		
	}
	else
	{
		[CATransaction begin];
		[CATransaction setAnimationDuration:_animationDuration];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		
		_outerCircle.shapeTintColor = _inactiveColor;
		_innerCircle.shapeTintColor = _inactiveColor;
		_impressionCircle.shapeTintColor = [_inactiveColor sameColorAlpha:_impressionCircleAlphaBlendingValue];
		[CATransaction commit];
//		_innerCircle.transform = CGAffineTransformMakeScale(0.01, 0.01);
		_innerCircle.alpha = 0;
	}
}

-(void)setNeedsRefresh
{
	if (!needsRefresh)
	{
		_mainThreadAsync(^{
			[UIView animateWithDuration:_animationDuration animations:^{
				
				
				[self refreshUI];
			}];
			
			needsRefresh = NO;
		});
		needsRefresh = YES;
	}
}

-(void)highlight:(id)sender event:(UIEvent *)event
{
	POPBasicAnimation* alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
	alphaAnim.duration = _animationDuration/2.0f;
	alphaAnim.toValue = @(1);
	[_impressionCircle pop_addAnimation:alphaAnim forKey:@"alphaAnim"];
	
	POPBasicAnimation* scaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	scaleAnim.duration = _animationDuration;
	scaleAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(7, 7)];
	scaleAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :.6 :.4 :1];
	[_impressionCircle pop_addAnimation:scaleAnim forKey:@"scaleAnim"];
}

-(void)unhighlightSuccessful:(id)sender event:(UIEvent *)event
{
	POPBasicAnimation* alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
	alphaAnim.duration = _animationDuration/2.0;
	alphaAnim.toValue = @(0);
	[_impressionCircle pop_addAnimation:alphaAnim forKey:@"alphaAnim"];
	
	POPBasicAnimation* scaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	scaleAnim.duration = _animationDuration;
	scaleAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
	[_impressionCircle pop_addAnimation:scaleAnim forKey:@"scaleAnim"];
	
	[self _setOn:YES animated:YES affectOthers:YES shouldRefresh:YES];
}

-(void)setOn:(BOOL)on
{
	[self setOn:on animated:NO];
}

-(void)setOn:(BOOL)on animated:(BOOL)animated
{
	[self _setOn:on animated:animated affectOthers:YES shouldRefresh:YES];
}

-(void)_setOn:(BOOL)on animated:(BOOL)animated affectOthers:(BOOL)affectOthers shouldRefresh:(BOOL)shouldRefresh
{
	_on = on;
	if (shouldRefresh)
	{
		if (animated)
			[self setNeedsRefresh];
		else
			[self refreshUI];
	}
	
	if (_on && affectOthers)
		[self turnOffOtherBoxesInGroup:animated];
}

-(void)turnOffOtherBoxesInGroup:(BOOL)animated
{
	for (MATRadioBox* aRadioBox in _radioBoxesGroup)
	{
		if (aRadioBox != self)
		{
			[aRadioBox _setOn:false animated:animated affectOthers:NO shouldRefresh:YES];
		}
	}
}

-(void)unhighlightCancelled:(id)sender event:(UIEvent *)event
{
	POPBasicAnimation* alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
	alphaAnim.duration = _animationDuration/2.0;
	alphaAnim.toValue = @(0);
	[_impressionCircle pop_addAnimation:alphaAnim forKey:@"alphaAnim"];
	
	POPBasicAnimation* scaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	scaleAnim.duration = _animationDuration;
	scaleAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
	[_impressionCircle pop_addAnimation:scaleAnim forKey:@"scaleAnim"];
}
@end
