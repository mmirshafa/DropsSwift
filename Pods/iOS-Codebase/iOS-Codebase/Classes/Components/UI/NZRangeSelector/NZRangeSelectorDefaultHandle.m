//
//  NZRangeSelectorComatibleView.m
//  MyAthath
//
//  Created by Developer on 1/21/19.
//  Copyright © 2019 Nizek. All rights reserved.
//
#import "NZRangeSelectorDefaultHandle.h"
#import "NZRangeSelectorHandleBallonView.h"
#import "NZRangeSelector.h"
#import "UIView+SDCAutoLayout.h"
#import "UIView+Extensions.h"
#import "UIColor+Extensions.h"
#import "Codebase_definitions.h"
#import "helper.h"

@interface NZRangeSelectorDefaultHandle ()

@property (retain, nonatomic) NZRangeSelectorHandleBallonView *ballon;
@property (retain, nonatomic) UILabel *label;
@property (assign, nonatomic) float value;
@property (assign, nonatomic) NZRangeSelectorHandle type;
//@property (assign, nonatomic) CGPoint old;

@end


@implementation NZRangeSelectorDefaultHandle

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        
        self.decor1 = [[UIView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
        self.decor1.backgroundColor = [UIColor blackColor];
        self.decor1.layer.cornerRadius = 10.0f;
        self.decor1.layer.masksToBounds = YES;
        [self addSubview:self.decor1];
        
        self.decor2 = [[UIView alloc] initWithFrame:CGRectMake(18, 18, 8, 8)];
        self.decor2.backgroundColor = [UIColor whiteColor];
        self.decor2.layer.cornerRadius = 4.0;
        self.decor2.layer.masksToBounds = YES;
        [self addSubview:self.decor2];
        
        _mainTintColor = [UIColor blackColor];
        _theFont = [UIFont systemFontOfSize:15];
    }
    return self;
}

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

-(void)NZRangeSelector:(NZRangeSelector *)instance configureWithType:(NZRangeSelectorHandle)type
{
    self.type = type;
//    self.old = CGPointMake(0.5, 0.5);

    if (type == NZRangeSelectorHandleRight)
    {
        self.ballon = [[NZRangeSelectorHandleBallonView alloc] initWithType:NZRangeSelectorHandleBallonViewTypeRight];
        self.ballon.translatesAutoresizingMaskIntoConstraints = NO;
        self.ballon.theColor = self.mainTintColor;
        [self addSubview:self.ballon];
        [self.ballon sdc_alignRightEdgeWithSuperviewMargin:22];
        [self.ballon sdc_alignBottomEdgeWithSuperviewMargin:34];
    }
    else if (type == NZRangeSelectorHandleLeft)
    {
        self.ballon = [[NZRangeSelectorHandleBallonView alloc] initWithType:NZRangeSelectorHandleBallonViewTypeLeft];
        self.ballon.translatesAutoresizingMaskIntoConstraints = NO;
        self.ballon.theColor = self.mainTintColor;
        [self addSubview:self.ballon];
        [self.ballon sdc_alignLeftEdgeWithSuperviewMargin:22];
        [self.ballon sdc_alignBottomEdgeWithSuperviewMargin:34];
    }
    
    self.ballon.alpha = 0;

    self.label = [UILabel new2];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = self.theFont;
    self.label.textColor = [UIColor whiteColor];
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.clipsToBounds = YES;
    self.label.minimumScaleFactor = 0.5;
    [self.ballon addSubview:self.label];
    [self.label sdc_alignTopEdgeWithSuperviewMargin:0];
    [self.label sdc_alignSideEdgesWithSuperviewInset:5];
    [self.label sdc_pinHeight:20];
    [self.label sdc_alignBottomEdgeWithSuperviewMargin:6];
}

-(void)setTheFont:(UIColor *)theFont
{
    _theFont = theFont;
    self.label.font = theFont;
}

-(void)setMainTintColor:(UIColor *)mainTintColor
{
    _mainTintColor = mainTintColor;
    self.ballon.theColor = self.mainTintColor;
}

-(void)NZRangeSelector:(NZRangeSelector *)instance event:(NZRangeSelectorEvent)event value:(float)value
{
    self.value = value;
    self.label.text = [NSString stringWithFormat:@"%0.0f", value];
    [self layoutIfNeeded];
    
//    self.ballon.layer.anchorPoint = CGPointMake(0, 0.5);
    
//    if (self.ballon.layer.position.x) {
//        CGFloat positionX = (self.ballon.bounds.origin.x + (self.ballon.bounds.size.width / 2));
//    self.ballon.layer.position = CGPointMake(positionX, -3);
//        NSLog(@"%0.2f,%0.2f, %0.2f", self.ballon.layer.position.x, self.ballon.bounds.size.width, positionX);
//    }
    
    
    if (event == NZRangeSelectorEventBegan)
    {
//        CGPoint target = CGPointMake(0, 1);
        
//        [self ChangePositionForView:self.ballon WithOldAnchorPoint:self.old andNewAnchorPoint:target withCurrentPosition:self.ballon.layer.position];
        
       //self.old = target;
        
        hapticTick;
        [UIView animateWithDuration:.2 animations:^{
            self.ballon.alpha = 1;
        }];
    
    }
    else if (event == NZRangeSelectorEventChanged)
    {
//        CGPoint target = CGPointMake(0, 1);
        
//        [self ChangePositionForView:self.ballon WithOldAnchorPoint:self.old andNewAnchorPoint:target withCurrentPosition:self.ballon.layer.position];
        
//        self.old = target;
    }
    else if (event == NZRangeSelectorEventEnded)
    {
        [UIView animateWithDuration:.2 animations:^{
            self.ballon.alpha = 0;
            
//            NSLog(@"%@", NSStringFromCGPoint(self.ballon.layer.anchorPoint));

        }];
    }
}

-(void)setTintColor:(UIColor *)tintColor
{
    self.decor1.backgroundColor = tintColor;
}

-(UIColor *)tintColor
{
    return self.decor1.backgroundColor;
}
-(void)ChangePositionForView:(UIView *)view WithOldAnchorPoint:(CGPoint)oldAnchorPoint andNewAnchorPoint:(CGPoint)newAnchorPoint withCurrentPosition:(CGPoint)currentPosition
{
    
    view.layer.anchorPoint = newAnchorPoint;
    
    if (newAnchorPoint.y == oldAnchorPoint.y)
    {
        if (newAnchorPoint.x < oldAnchorPoint.x)
        {
            CGFloat dividedBy = (1 / (oldAnchorPoint.x - newAnchorPoint.x));
            view.layer.position = CGPointMake(currentPosition.x - (view.bounds.size.width / dividedBy), currentPosition.y);
        }
        else if (newAnchorPoint.x > oldAnchorPoint.x)
        {
            CGFloat dividedBy = (1 / (newAnchorPoint.x - oldAnchorPoint.x));
            view.layer.position = CGPointMake(currentPosition.x + (view.bounds.size.width / dividedBy), currentPosition.y);
        }
        else if (newAnchorPoint.x == oldAnchorPoint.x)
        {
            view.layer.position = CGPointMake(currentPosition.x , currentPosition.y);
        }
    }
    else if (newAnchorPoint.x == oldAnchorPoint.x)
    {
        if (newAnchorPoint.y < oldAnchorPoint.y)
        {
            CGFloat dividedBy = (1 / (oldAnchorPoint.y - newAnchorPoint.y));
            view.layer.position = CGPointMake(currentPosition.x , currentPosition.y - (view.bounds.size.height / dividedBy));
        }
        else if (newAnchorPoint.y > oldAnchorPoint.y)
        {
            CGFloat dividedBy = (1 / (newAnchorPoint.y - oldAnchorPoint.y));
            view.layer.position = CGPointMake(currentPosition.x , currentPosition.y + (view.bounds.size.height / dividedBy));
        }
        else if (newAnchorPoint.y == oldAnchorPoint.y)
        {
            view.layer.position = CGPointMake(currentPosition.x , currentPosition.y);
        }
    }
    else
    {
        if (newAnchorPoint.x < oldAnchorPoint.x && newAnchorPoint.y < oldAnchorPoint.y)
        {
            CGFloat dividedByX = (1 / (oldAnchorPoint.x - newAnchorPoint.x));
            CGFloat dividedByY = (1 / (oldAnchorPoint.y - newAnchorPoint.y));
            view.layer.position = CGPointMake(currentPosition.x - (view.bounds.size.width / dividedByX), currentPosition.y - (view.bounds.size.height / dividedByY));
        }
        else if (newAnchorPoint.x > oldAnchorPoint.x && newAnchorPoint.y > oldAnchorPoint.y)
        {
            CGFloat dividedByX = (1 / (newAnchorPoint.x - oldAnchorPoint.x));
            CGFloat dividedByY = (1 / (newAnchorPoint.y - oldAnchorPoint.y));
            view.layer.position = CGPointMake(currentPosition.x + (view.bounds.size.width / dividedByX), currentPosition.y + (view.bounds.size.height / dividedByY));
        }
        else if (newAnchorPoint.x < oldAnchorPoint.x && newAnchorPoint.y > oldAnchorPoint.y)
        {
            CGFloat dividedByX = (1 / (oldAnchorPoint.x - newAnchorPoint.x));
            CGFloat dividedByY = (1 / (newAnchorPoint.y - oldAnchorPoint.y));
            view.layer.position = CGPointMake(currentPosition.x - (view.bounds.size.width / dividedByX) , currentPosition.y + (view.bounds.size.height / dividedByY));
        }
        else if (newAnchorPoint.x > oldAnchorPoint.x && newAnchorPoint.y < oldAnchorPoint.y)
        {
            CGFloat dividedByX = (1 / (newAnchorPoint.x - oldAnchorPoint.x));
            CGFloat dividedByY = (1 / (oldAnchorPoint.y - newAnchorPoint.y));
            view.layer.position = CGPointMake(currentPosition.x + (view.bounds.size.width / dividedByX) , currentPosition.y - (view.bounds.size.height / dividedByY));
        }
    }
}

@end
