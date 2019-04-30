//
//  _UIControlBase.m
//  mactehrannew
//
//  Created by hAmidReza on 5/29/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_UIControlBase.h"
#import "helper.h"
#import "Codebase_definitions.h"

#define _lightGray	rgba(229, 229, 229, 1.000)
#define _lighMediumGray rgba(180, 180, 180, 1.000)
#define _mediumGray rgba(141, 141, 141, 1.000)

@interface _UIControlBase ()
{
	UIColor* oldBackColor;
	UIColor* oldTextColor;
}
@end

@implementation _UIControlBase

-(void)setEnabled:(BOOL)enabled
{
	[super setEnabled:enabled];
	
	if (!enabled)
	{
		self.alpha = _disabledAlpha;
	}
	else
	{
		self.alpha = 1.0f;
	}
}

-(void)_setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
}

-(void)setHighlighted:(BOOL)highlighted
{
	[self _setHighlighted:highlighted];
	
	if (_highlightingDisabled)
		return;
	
	if (!oldBackColor)
		oldBackColor = self.backgroundColor ? self.backgroundColor : [UIColor clearColor];
	
	[UIView animateWithDuration:.3 animations:^{
		super.backgroundColor = highlighted ? (_highlightedBackgroundColor ? _highlightedBackgroundColor : _lightGray) : oldBackColor;
	}];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
	[super setBackgroundColor:backgroundColor];
	oldBackColor = backgroundColor;
}

-(instancetype)init
{
	self = [super init];
	if (self)
		[self _initialize];
	return self;
}

-(instancetype)_init
{
	return [super init];
}

-(void)_initialize
{
	_disabledAlpha = .3;
	[self initialize];
}

-(void)initialize
{
	
}
@end
