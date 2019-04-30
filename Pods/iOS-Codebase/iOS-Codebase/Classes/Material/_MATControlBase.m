//
//  _MATControlBase.m
//  mactehrannew
//
//  Created by hAmidReza on 8/9/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_MATControlBase.h"

@implementation _MATControlBase

-(void)initialize
{
	[super initialize];
	
	self.highlightingDisabled = YES;
	
	[self addTarget:self action:@selector(highlight:event:) forControlEvents:UIControlEventTouchDown];
	[self addTarget:self action:@selector(unhighlightSuccessful:event:) forControlEvents:UIControlEventTouchUpInside];
	[self addTarget:self action:@selector(unhighlightCancelled:event:) forControlEvents:UIControlEventTouchUpOutside];
	[self addTarget:self action:@selector(unhighlightCancelled:event:) forControlEvents:UIControlEventTouchCancel];
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


@end
