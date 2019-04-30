//
//  _UIControlBase2.m
//  mactehrannew
//
//  Created by hAmidReza on 8/30/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_UIControlBase2.h"

@interface _UIControlBase2 ()
{
	UIColor* oldBackColor;
	UIColor* oldTextColor;
}

@end

@implementation _UIControlBase2

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
	[self addTarget:self action:@selector(highlight:event:) forControlEvents:UIControlEventTouchDown];
	[self addTarget:self action:@selector(unhighlightSuccessful:event:) forControlEvents:UIControlEventTouchUpInside];
	[self addTarget:self action:@selector(unhighlightCancelled:event:) forControlEvents:UIControlEventTouchUpOutside];
	[self addTarget:self action:@selector(unhighlightCancelled:event:) forControlEvents:UIControlEventTouchCancel];
	[self initialize];
}

-(void)highlight:(id)sender event:(UIEvent*)event
{

}

-(void)unhighlightSuccessful:(id)sender event:(UIEvent*)event
{

}

-(void)unhighlightCancelled:(id)sender event:(UIEvent*)event
{

}

-(void)initialize
{
	
}

@end
