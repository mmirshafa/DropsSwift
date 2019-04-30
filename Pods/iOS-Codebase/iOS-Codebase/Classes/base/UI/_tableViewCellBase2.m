//
//  _tableViewCellBase2.m
//  oncost
//
//  Created by Hamidreza Vakilian on 3/6/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "_tableViewCellBase2.h"
#import "_UIControlBase.h"
#import "UIView+Extensions.h"
#import "UIView+SDCAutoLayout.h"

@interface _tableViewCellBase2 ()
@property (retain, nonatomic) _UIControlBase* overlayView;
@property (retain, nonatomic, readwrite) UIView* mainContentView;
@end

@implementation _tableViewCellBase2

-(void)initialize
{
    [super initialize];
    
    self.mainContentView = [UIView new2];
    [[super contentView] addSubview:self.mainContentView];
    [self.mainContentView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    
    self.overlayView = [_UIControlBase new2];
    [[super contentView] addSubview:self.overlayView];
    [self.overlayView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
//    self.overlayView.highlightedBackgroundColor = RGBAColor(0, 0, 0, .2);
    self.overlayView.backgroundColor = [UIColor clearColor];
    
    [self.overlayView addTarget:self action:@selector(selfTap:) forControlEvents:UIControlEventTouchUpInside];
    
    self.touchEnabled = YES;
}

-(void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor
{
    _highlightedBackgroundColor = highlightedBackgroundColor;
    self.overlayView.highlightedBackgroundColor = highlightedBackgroundColor;
}

-(UIView *)theContentView
{
    return self.mainContentView;
}

-(void)selfTap:(id)sender
{
    
}

-(void)setTouchEnabled:(BOOL)touchEnabled
{
    _touchEnabled = touchEnabled;
    if (touchEnabled)
        self.overlayView.userInteractionEnabled = YES;
    else
        self.overlayView.userInteractionEnabled = NO;
}

@end
