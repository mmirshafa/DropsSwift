//
//  MyShadowView.m
//  mactehrannew
//
//  Created by hAmidReza on 7/26/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "MyShadowView.h"

@interface MyShadowView ()
{
	CALayer* shadowLayer;
}

@end

@implementation MyShadowView

-(void)initialize
{
	[super initialize];
	
	shadowLayer = [CALayer new];
	shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
	shadowLayer.contentsScale = [[UIScreen mainScreen] scale];
	[self.layer addSublayer:shadowLayer];
	
	self.shadowColor = [UIColor blackColor];
	self.shadowOffset = CGSizeZero;
	self.shadowRadius = 4.0f;
	self.shadowOpacity = .5;
	shadowLayer.cornerRadius = 4.0f;
}

-(void)setShadowColor:(UIColor *)shadowColor
{
	shadowLayer.shadowColor = shadowColor.CGColor;
}

-(UIColor *)shadowColor
{
	return [UIColor colorWithCGColor:shadowLayer.shadowColor];
}

-(void)setShadowOffset:(CGSize)shadowOffset
{
	shadowLayer.shadowOffset = shadowOffset;
}

-(CGSize)shadowOffset
{
	return shadowLayer.shadowOffset;
}

-(void)setShadowRadius:(CGFloat)shadowRadius
{
	_shadowRadius = shadowRadius;
	shadowLayer.shadowRadius = shadowRadius;
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
	_cornerRadius = cornerRadius;
	shadowLayer.cornerRadius = cornerRadius;
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity
{
	shadowLayer.shadowOpacity = shadowOpacity;
}

-(CGFloat)shadowOpacity
{
	return shadowLayer.shadowOpacity;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect frame = self.bounds;
	
	CAAnimation* sizeAnim = [self.layer animationForKey:@"bounds.size"];
	CAAnimation* originAnim = [self.layer animationForKey:@"bounds.origin"];
	
	if (sizeAnim || originAnim)
	{
		//		CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
		//		pathAnimation.timingFunction = sizeAnim ? sizeAnim.timingFunction : originAnim.timingFunction;
		//		pathAnimation.duration = sizeAnim ? sizeAnim.duration : originAnim.duration;
		//		pathAnimation.toValue = (__bridge id)[UIBezierPath bezierPathWithRect:frame].CGPath;
		//		pathAnimation.beginTime = sizeAnim ? sizeAnim.beginTime : originAnim.beginTime;
		//		pathAnimation.speed = sizeAnim ? sizeAnim.speed : originAnim.speed;
		//		pathAnimation.removedOnCompletion = NO;//sizeAnim ? sizeAnim.removedOnCompletion : originAnim.removedOnCompletion;
		//		pathAnimation.fillMode = sizeAnim ? sizeAnim.fillMode : originAnim.fillMode;
		//		[shadowLayer addAnimation:pathAnimation forKey:@"pathAnimation"];
		//
		//				shadowLayer.frame = frame;
		
		
		//		[shadowLayer addAnimation:originAnim forKey:@"zz"];
		//		[shadowLayer addAnimation:sizeAnim forKey:@"zz"];
		
		//
		//		CABasicAnimation* sizeAnim = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
		//		sizeAnim.timingFunction = sizeAnim.timingFunction;
		//		sizeAnim.duration = sizeAnim.duration;
		//		sizeAnim.beginTime = sizeAnim.beginTime;
		//		sizeAnim.speed = sizeAnim.speed;
		//		sizeAnim.removedOnCompletion = NO;
		//		sizeAnim.fillMode = kCAFillModeForwards;
		//		sizeAnim.toValue = (id)[NSValue valueWithCGSize:self.bounds.size];
		//		[shadowLayer addAnimation:sizeAnim forKey:@"sizeAnimation"];
		//
		//
		//		CABasicAnimation* originAnim = [CABasicAnimation animationWithKeyPath:@"bounds.origin"];
		//		originAnim.timingFunction = originAnim.timingFunction;
		//		originAnim.duration = originAnim.duration;
		//		originAnim.beginTime = originAnim.beginTime;
		//		originAnim.speed = sizeAnim.speed;
		//		originAnim.removedOnCompletion = NO;
		//		originAnim.fillMode = kCAFillModeForwards;
		//		originAnim.toValue = (id)[NSValue valueWithCGPoint:self.frame.origin];
		//		[shadowLayer addAnimation:sizeAnim forKey:@"originAnimation"];
		//
		
		[CATransaction begin];
		[CATransaction setAnimationDuration:sizeAnim.duration];
		[CATransaction setAnimationTimingFunction:sizeAnim.timingFunction];
		shadowLayer.frame = frame;
		[CATransaction commit];
		
	}
	else
	{
		[CATransaction begin];
		[CATransaction setDisableActions: YES];
		shadowLayer.frame = frame;
		[CATransaction commit];
		
	}
}

@end
