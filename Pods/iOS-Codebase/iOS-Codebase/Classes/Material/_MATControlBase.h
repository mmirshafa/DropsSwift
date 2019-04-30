//
//  _MATControlBase.h
//  mactehrannew
//
//  Created by hAmidReza on 8/9/17.
//  Copyright © 2017 archibits. All rights reserved.
//
#define kDefaultAnimationDuration .8

#import "_UIControlBase.h"

@interface _MATControlBase : _UIControlBase


-(void)highlight:(id)sender event:(UIEvent*)event;
-(void)unhighlightSuccessful:(id)sender event:(UIEvent*)event;
-(void)unhighlightCancelled:(id)sender event:(UIEvent*)event;

@end
