//
//  _UIControlBase2.h
//  mactehrannew
//
//  Created by hAmidReza on 8/30/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _UIControlBase2 : UIControl

// at first it was a subclass of UIControl; the touches had latency and also touchupinside event was not being called sometimes. changing this to UIButton solved the problem. :( no solutions found on the web.

@property (assign, nonatomic) BOOL highlightingDisabled;


/**
 sets the disabled alpha state of the control. default: .3
 */
@property (assign, nonatomic) CGFloat disabledAlpha;
@property (retain, nonatomic) UIColor* highlightedBackgroundColor;

-(void)initialize;

-(instancetype)_init;

-(void)highlight:(id)sender event:(UIEvent*)event;
-(void)unhighlightSuccessful:(id)sender event:(UIEvent*)event;
-(void)unhighlightCancelled:(id)sender event:(UIEvent*)event;

@end
