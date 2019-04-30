//
//  _cbBasedUIControl.m
//  oncost
//
//  Created by Hamidreza Vakilian on 3/11/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "_cbBasedUIControl.h"

@implementation _cbBasedUIControl

-(instancetype)init
{
    self = [super init];
    if (self)
        [self initialize];
    return self;
}

-(void)initialize
{
    [self addTarget:self action:@selector(highlight:event:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(unhighlightSuccessful:event:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(unhighlightCancelled:event:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(unhighlightCancelled:event:) forControlEvents:UIControlEventTouchCancel];
}

-(void)highlight:(id)sender event:(UIEvent*)event
{
    if (self.highlight)
        self.highlight(sender, event);
}

-(void)unhighlightSuccessful:(id)sender event:(UIEvent*)event
{
    if (self.unhighlightSuccessful)
        self.unhighlightSuccessful(sender, event);
}

-(void)unhighlightCancelled:(id)sender event:(UIEvent*)event
{
    if (self.unhighlightCancelled)
        self.unhighlightCancelled(sender, event);
}

@end
