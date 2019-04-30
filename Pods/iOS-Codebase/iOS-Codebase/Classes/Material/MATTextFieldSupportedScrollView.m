//
//  MATTextFieldSupportedScrollView.m
//  oncost
//
//  Created by Hamidreza Vakilian on 3/23/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "MATTextFieldSupportedScrollView.h"
#import "UIView+Extensions.h"
#import "MATTextField.h"
#import "NSObject+DataObject.h"

@implementation MATTextFieldSupportedScrollView

-(void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    CGPoint p = CGPointMake(rect.origin.x + rect.size.width/2.0f, rect.origin.y + rect.size.height/2.0f);
    
    UIView* v = [[self scrollViewConentsView] hitTest:p withEvent:nil];
    
    MATTextField* detectedMatTextField = [v getNearestParentViewByClass:NSStringFromClass(MATTextField.class)];
    
    if (detectedMatTextField)
    {
        rect = [self convertRect:detectedMatTextField.bounds fromView:detectedMatTextField];
    }
    
    [super scrollRectToVisible:rect animated:animated];
}

-(void)setScrollViewConentsView:(UIView *)scrollViewConentsView
{
    [self setDataObject:scrollViewConentsView forKey:@"scrollViewConentsView"];
}

-(UIView *)scrollViewConentsView
{
    return [self dataObjectForKey:@"scrollViewConentsView"];
}

@end
