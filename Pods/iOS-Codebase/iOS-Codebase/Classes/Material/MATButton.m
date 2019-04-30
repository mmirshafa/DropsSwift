//
//  MATRaisedButton.m
//  mactehrannew
//
//  Created by hAmidReza on 8/8/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "MATButton.h"
#import "MyShadowView.h"
#import "MyShapeView.h"
#import "UIView+SDCAutoLayout.h"
#import "UIView+Extensions.h"
#import "Codebase_definitions.h"
#import "UIColor+Extensions.h"
#import "POP.h"

@interface MATButton ()
{
	MyShapeView* circleView;
	BOOL circleViewInitialTransformDone;
}

@property (retain, nonatomic) UIView* shadowViewHolder;
@property (retain, nonatomic) UIView* innerContent;
@property (retain, nonatomic) UILabel* theTitleLabel;

@end

@implementation MATButton

-(instancetype)initWithType:(MATButtonType)type
{
	self = [self _init];
	if (self)
	{
		_type = type;
		[self initialize];
	}
	return self;
}

-(void)initialize
{
	[super initialize];
	
		[self sdc_setMinimumWidth:64];
	[UIView sdc_priority:900 block:^{
		[self sdc_pinHeight:48];
		[self sdc_pinWidth:64];
	}];
	
	self.highlightingDisabled = YES;
	
	_primaryColor = rgba(48, 125, 252, 1.000);
	if (_type == MATButtonTypeRaised)
		_titleColor = [UIColor whiteColor];
	else
		_titleColor = _primaryColor;
	
	_innerContentSideMargins = 6.0f;
	_animationDuration = kDefaultAnimationDuration;
	_cornerRadius = 2.0f;
	_innerContentTopPadding = 6.0f;
	_innerContentBottomPadding = 6.0f;
	
	_shadowNormalColor = rgba(0, 0, 0, .5);
	_shadowNormalOffset = CGSizeMake(0, 2);
	_shadowNormalRadius = 2.0f;
	
	_shadowPressedColor = rgba(0, 0, 0, .7);
	_shadowPressedOffset = CGSizeMake(0, 5);
	_shadowPressedRadius = 4.0f;
	
	_innerContent = [UIView new];
	if (_type == MATButtonTypeRaised)
		_innerContent.layer.shadowOpacity = 1.0;
	else
		_innerContent.layer.shadowOpacity = 0;
	_innerContent.layer.shadowColor = _shadowNormalColor.CGColor;
	_innerContent.layer.shadowOffset = _shadowNormalOffset;
	_innerContent.layer.shadowRadius = _shadowNormalRadius;
	_innerContent.userInteractionEnabled = NO;
	_innerContent.layer.cornerRadius = _cornerRadius;
	_innerContent.backgroundColor = [UIColor clearColor];
	
	if (_type == MATButtonTypeRaised)
		_innerContent.backgroundColor = _primaryColor;
	
	_innerContent.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:_innerContent];
	[_innerContent sdc_alignEdgesWithSuperview:UIRectEdgeAll insets:UIEdgeInsetsMake(_innerContentTopPadding, _innerContentSideMargins, -_innerContentBottomPadding, -_innerContentSideMargins)];
	
	_shadowViewHolder = [UIView new];
	_shadowViewHolder.userInteractionEnabled = NO;
	_shadowViewHolder.layer.cornerRadius = _cornerRadius;
	_shadowViewHolder.clipsToBounds = YES;
	_shadowViewHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:_shadowViewHolder];
	[_shadowViewHolder sdc_alignEdges:UIRectEdgeAll withView:_innerContent];
	
	UIView* circleViewHolder = [UIView new];
	circleViewHolder.userInteractionEnabled = NO;
	circleViewHolder.translatesAutoresizingMaskIntoConstraints = NO;
	[_shadowViewHolder addSubview:circleViewHolder];
	[circleViewHolder sdc_alignEdgesWithSuperview:UIRectEdgeAll];
	
	circleView = [[MyShapeView alloc] initWithShapeDesc:k_iconCircle() andShapeTintColor:rgba(255, 255, 255, .2)];
	circleView.alpha = 0;
	circleView.maintainAspectRatio = YES;
	circleView.translatesAutoresizingMaskIntoConstraints = NO;
	[circleViewHolder addSubview:circleView];
	[circleView sdc_centerInSuperview];
	[circleView sdc_pinWidthToWidthOfView:_innerContent multiplier:.1 offset:0];
	
	
	_theTitleLabel = [UILabel new];
	_theTitleLabel.textColor = _titleColor;
	_theTitleLabel.textAlignment = NSTextAlignmentCenter;
	_theTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_theTitleLabel setContentCompressionResistancePriority:999 forAxis:UILayoutConstraintAxisHorizontal];
	[_innerContent addSubview:_theTitleLabel];
	[UIView sdc_priority:910 block:^{
		[_theTitleLabel sdc_alignLeftEdgeWithSuperviewMargin:16];
		[_theTitleLabel sdc_alignRightEdgeWithSuperviewMargin:16];
	}];
//	[_theTitleLabel sdc_horizontallyCenterInSuperview];
	[_theTitleLabel sdc_verticallyCenterInSuperview];
	
	
	POPBasicAnimation* circleBounce = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	circleBounce.fromValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
	circleBounce.toValue = [NSValue valueWithCGSize:CGSizeMake(1.05, 1.05)];
	circleBounce.repeatForever = YES;
	circleBounce.autoreverses = YES;
	circleBounce.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	circleBounce.duration = 1;
	[circleViewHolder pop_addAnimation:circleBounce forKey:@"bounce"];
	
//	[self setNeedsLayout];
//	[self layoutIfNeeded];
}

-(void)highlight:(id)sender event:(UIEvent *)event
{
//	
//	UITouch *touch = [[event touchesForView:sender] anyObject];
//	CGPoint location = [touch locationInView:_innerContent];
//	location.x = _MAXMIN_Bound(0, location.x, _innerContent.frame.size.width);
//	location.y = _MAXMIN_Bound(0, location.y, _innerContent.frame.size.height);
////
//	CGFloat diffX = (_innerContent.frame.size.width / 2.0) - location.x;
//	CGFloat diffY = (_innerContent.frame.size.height / 2.0) - location.y;
//
////	id con = [circleView sdc_get_horizontalCenter];
////	[circleView sdc_get_verticalCenter].constant = 2;
//	[circleView sdc_get_horizontalCenter].constant = 35;
//	
//	
//	[self layoutIfNeeded];
//	
//	NSLog(@"Location in button: %f, %f", location.x, location.y);
	
//	[CATransaction begin];
//	[CATransaction setDisableActions:YES];
//	CGAffineTransform transform = CGAffineTransformMakeScale(.1, .1);
//	transform = CGAffineTransformTranslate(transform, diffX, diffY);
	circleView.transform = CGAffineTransformMakeScale(.1, .1);
//	circleView.transform = transform;
	
//	[CATransaction commit];
	
	
	if (_type == MATButtonTypeFlat)
	{
		circleView.shapeTintColor = [_primaryColor sameColorAlpha:.12];
	}
	
	POPBasicAnimation* shadowColorAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowRadius];
	shadowColorAnim.duration = _animationDuration;
	shadowColorAnim.toValue = (id)_shadowPressedColor.CGColor;
	[_innerContent.layer pop_addAnimation:shadowColorAnim forKey:@"shadowColor"];
	
	POPBasicAnimation* shadowOffsetAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowOffset];
	shadowOffsetAnim.duration = _animationDuration;
	shadowOffsetAnim.toValue = [NSValue valueWithCGSize:_shadowPressedOffset];
	[_innerContent.layer pop_addAnimation:shadowOffsetAnim forKey:@"shadowOffset"];
	
	POPBasicAnimation* shadowRadiusAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowRadius];
	shadowRadiusAnim.duration = _animationDuration;
	shadowRadiusAnim.toValue = @(_shadowPressedRadius);
	[_innerContent.layer pop_addAnimation:shadowRadiusAnim forKey:@"shadowRadius"];
	
	POPBasicAnimation* alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
	alphaAnim.duration = _animationDuration/2.0f;
	alphaAnim.toValue = @(1);
	[circleView pop_addAnimation:alphaAnim forKey:@"alphaAnim"];
	
	POPBasicAnimation* scaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	scaleAnim.duration = _animationDuration;
	scaleAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(8, 8)];
	scaleAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :.6 :.4 :1];
	[circleView pop_addAnimation:scaleAnim forKey:@"scaleAnim"];
}

-(void)unhighlightSuccessful:(id)sender event:(UIEvent *)event
{
	POPBasicAnimation* shadowColorAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowRadius];
	shadowColorAnim.duration = _animationDuration;
	shadowColorAnim.toValue = (id)_shadowNormalColor.CGColor;
	[_innerContent.layer pop_addAnimation:shadowColorAnim forKey:@"shadowColor"];
	
	POPBasicAnimation* shadowOffsetAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowOffset];
	shadowOffsetAnim.duration = _animationDuration;
	shadowOffsetAnim.toValue = [NSValue valueWithCGSize:_shadowNormalOffset];
	[_innerContent.layer pop_addAnimation:shadowOffsetAnim forKey:@"shadowOffset"];
	
	POPBasicAnimation* shadowRadiusAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowRadius];
	shadowRadiusAnim.duration = _animationDuration;
	shadowRadiusAnim.toValue = @(_shadowNormalRadius);
	[_innerContent.layer pop_addAnimation:shadowRadiusAnim forKey:@"shadowRadius"];
	
	POPBasicAnimation* alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
	alphaAnim.duration = _animationDuration/2.0;
	alphaAnim.toValue = @(0);
	[circleView pop_addAnimation:alphaAnim forKey:@"alphaAnim"];
	
	POPBasicAnimation* scaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	scaleAnim.duration = _animationDuration;
	scaleAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(10, 10)];
	scaleAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :1 :0 :1];
	[circleView pop_addAnimation:scaleAnim forKey:@"scaleAnim"];
	
	if (_click)
		_click(self);
}

-(void)unhighlightCancelled:(id)sender event:(UIEvent *)event
{
	POPBasicAnimation* shadowColorAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowRadius];
	shadowColorAnim.duration = _animationDuration;
	shadowColorAnim.toValue = (id)_shadowNormalColor.CGColor;
	[_innerContent.layer pop_addAnimation:shadowColorAnim forKey:@"shadowColor"];
	
	POPBasicAnimation* shadowOffsetAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowOffset];
	shadowOffsetAnim.duration = _animationDuration;
	shadowOffsetAnim.toValue = [NSValue valueWithCGSize:_shadowNormalOffset];
	[_innerContent.layer pop_addAnimation:shadowOffsetAnim forKey:@"shadowOffset"];
	
	POPBasicAnimation* shadowRadiusAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowRadius];
	shadowRadiusAnim.duration = _animationDuration;
	shadowRadiusAnim.toValue = @(_shadowNormalRadius);
	[_innerContent.layer pop_addAnimation:shadowRadiusAnim forKey:@"shadowRadius"];
	
	POPBasicAnimation* alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
	alphaAnim.duration = _animationDuration/2.0;
	alphaAnim.toValue = @(0);
	[circleView pop_addAnimation:alphaAnim forKey:@"alphaAnim"];
	
	POPBasicAnimation* scaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	scaleAnim.duration = _animationDuration;
	scaleAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(.1, .1)];
	[circleView pop_addAnimation:scaleAnim forKey:@"scaleAnim"];
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	
//	if (!circleViewInitialTransformDone)
//		if (circleView.frame.size.width > 0 && circleView.frame.size.height > 0)
//		{
//			circleView.transform = CGAffineTransformMakeScale(.1, .1);
//			circleViewInitialTransformDone = YES;
//		}
	
}

-(void)setTitleFont:(UIFont *)titleFont
{
	_titleFont = titleFont;
	_theTitleLabel.font = _titleFont;
}

-(void)setInnerContentSideMargins:(CGFloat)innerContentSideMargins
{
	_innerContentSideMargins = innerContentSideMargins;
	[_innerContent sdc_get_leadingOrLeft].constant = innerContentSideMargins;
	[_innerContent sdc_get_trailingOrRight].constant = -innerContentSideMargins;
}

-(void)setTitleColor:(UIColor *)titleColor
{
	_titleColor = titleColor;
	_theTitleLabel.textColor = _titleColor;
}

-(void)setPrimaryColor:(UIColor *)primaryColor
{
	_primaryColor = primaryColor;
	if (_type == MATButtonTypeRaised)
		_innerContent.backgroundColor = _primaryColor;
	else if (_type == MATButtonTypeFlat)
		self.titleColor = primaryColor;
}

-(void)setTitle:(NSString *)title
{
	_title = title;
	_theTitleLabel.text = title;
	
}

-(void)setInnerContentTopPadding:(CGFloat)innerContentTopPadding
{
	_innerContentTopPadding = innerContentTopPadding;
	[_innerContent sdc_get_top].constant = _innerContentTopPadding;
}

-(void)setInnerContentBottomPadding:(CGFloat)innerContentBottomPadding
{
	_innerContentBottomPadding = innerContentBottomPadding;
	[_innerContent sdc_get_bottom].constant = -_innerContentBottomPadding;
}

@end
