//
//  HyperSegmentedControl.m
//  HyperSegmentedControl
//
//  Created by hAmidReza on 8/21/16.
//  Copyright © 2016 innovian. All rights reserved.
//

#import "HyperSegmentedControl.h"
#import <objc/runtime.h>
#import "helper.h"
#import "_viewBase.h"
#import "UIView+SDCAutoLayout.h"
#import "_weakContainer.h"

@interface HyperSegmentedControlIndicatorViewLeftCap : _viewBase
{
    CAShapeLayer* shapeLayer;
}

@end

@implementation HyperSegmentedControlIndicatorViewLeftCap

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    shapeLayer.fillColor = backgroundColor.CGColor;
}

-(UIColor *)backgroundColor
{
    return [UIColor colorWithCGColor:shapeLayer.fillColor];
}

-(void)initialize
{
    shapeLayer = [CAShapeLayer new];
    [self.layer addSublayer:shapeLayer];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetHeight(frame), 0) controlPoint1:CGPointZero controlPoint2:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetHeight(frame), CGRectGetHeight(frame))];
    [bezierPath closePath];
    shapeLayer.path = bezierPath.CGPath;
}

@end

@interface HyperSegmentedControlIndicatorViewRightCap : _viewBase
{
    CAShapeLayer* shapeLayer;
}

@end

@implementation HyperSegmentedControlIndicatorViewRightCap

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    shapeLayer.fillColor = backgroundColor.CGColor;
}

-(UIColor *)backgroundColor
{
    return [UIColor colorWithCGColor:shapeLayer.fillColor];
}

-(void)initialize
{
    shapeLayer = [CAShapeLayer new];
    [self.layer addSublayer:shapeLayer];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetHeight(frame), CGRectGetHeight(frame)) controlPoint1:CGPointMake(CGRectGetHeight(frame), 0) controlPoint2:CGPointMake(CGRectGetHeight(frame), 0)];
    [bezierPath addLineToPoint:CGPointMake(0, CGRectGetHeight(frame))];
    [bezierPath closePath];
    shapeLayer.path = bezierPath.CGPath;
}

@end

@interface HyperSegmentedControlIndicatorView : _viewBase
{
    HyperSegmentedControlIndicatorViewLeftCap* leftCap;
    HyperSegmentedControlIndicatorViewRightCap* rightCap;
    UIView* middlePart;
}

@property (assign, nonatomic) HyperSegmentedControlCapMode capMode;

@end

@implementation HyperSegmentedControlIndicatorView

-(void)initialize
{
    leftCap = [HyperSegmentedControlIndicatorViewLeftCap new];
    leftCap.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:leftCap];
    
    rightCap = [HyperSegmentedControlIndicatorViewRightCap new];
    rightCap.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:rightCap];
    
    middlePart = [UIView new];
    middlePart.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:middlePart];
    
    self.capMode = HyperSegmentedControlCapModeRoundDown;
}

-(void)setCapMode:(HyperSegmentedControlCapMode)capMode
{
    _capMode = capMode;
    [self sdc_removeAllConstraints];
    
    if (_capMode == HyperSegmentedControlCapModeRoundDown)
    {
        [leftCap sdc_pinHeightWidthRatio:1.0 constant:0];
        [leftCap sdc_alignLeftEdgeWithSuperviewMargin:0];
        [leftCap sdc_alignTopEdgeWithSuperviewMargin:0];
        [leftCap sdc_alignBottomEdgeWithSuperviewMargin:0];
        
        [middlePart sdc_alignEdge:UIRectEdgeLeft withEdge:UIRectEdgeRight ofView:leftCap inset:-2];
        [middlePart sdc_alignTopEdgeWithSuperviewMargin:0];
        [middlePart sdc_alignBottomEdgeWithSuperviewMargin:0];
        
        [rightCap sdc_pinHeightWidthRatio:1.0f constant:0];
        [rightCap sdc_alignRightEdgeWithSuperviewMargin:0];
        [rightCap sdc_alignTopEdgeWithSuperviewMargin:0];
        [rightCap sdc_alignBottomEdgeWithSuperviewMargin:0];
        
        [middlePart sdc_alignEdge:UIRectEdgeRight withEdge:UIRectEdgeLeft ofView:rightCap inset:2];
    }
    else if (_capMode == HyperSegmentedControlCapModeRect)
    {
        [middlePart sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    }
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    middlePart.backgroundColor = backgroundColor;
    leftCap.backgroundColor = backgroundColor;
    rightCap.backgroundColor = backgroundColor;
}

-(UIColor *)backgroundColor
{
    return middlePart.backgroundColor;
}

@end

#define calculate_x_origin(viewFrame, indicatorWidth) viewFrame.origin.x + (viewFrame.size.width - indicatorWidth)/2.0f

@interface HyperSegmentedControl ()
{
    //    UIView* centeredView;
    UIView* contentView;
    HyperSegmentedControlIndicatorView* indicatorView;
    BOOL initialized;
    NSMutableArray* items;
    
    CABasicAnimation* precise_colorAnim; //indicator precise color animation percent driven
    CABasicAnimation* precise_frameAnim; //indicator precise frame animation percent driven
}

@end

@implementation HyperSegmentedControl

-(void)setIndicatorCapMode:(HyperSegmentedControlCapMode)indicatorCapMode
{
    indicatorView.capMode = indicatorCapMode;
}

-(HyperSegmentedControlCapMode)indicatorCapMode
{
    return indicatorView.capMode;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    if (!initialized)
    {
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        //        self.backgroundColor = [UIColor grayColor];
        items = [NSMutableArray new];
        _indicatorHeight = 3;
        _indicatorColor = [UIColor blueColor];
        
        contentView = [UIView new];
        //        contentView.backgroundColor = [UIColor greenColor];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:contentView];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView(==self)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView, self)]];
        
        
        indicatorView = [HyperSegmentedControlIndicatorView new];
        [contentView addSubview:indicatorView];
        
        self.indicatorCapMode = HyperSegmentedControlCapModeRoundDown;
        
        initialized = YES;
    }
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    if (selectedIndex >= items.count) //invalid index, ignore it...
        return;
    
    _selectedIndex = selectedIndex;
    
    NSDictionary* itemDic = items[selectedIndex];
    CGRect viewFrame = [(UIView*)[itemDic[@"view"] weakObject] frame];
    
    UIColor* color2Switch2 = itemDic[@"color"];
    
    CGFloat indicatorWidth = viewFrame.size.width;
    if ([_hyperSegmentedControlDataSource respondsToSelector:@selector(HyperSegmentedControl:widthOfIndicatorAtIndex:)])
        indicatorWidth = [_hyperSegmentedControlDataSource HyperSegmentedControl:self widthOfIndicatorAtIndex:selectedIndex];
    
    CGRect finalFrame = CGRectMake(calculate_x_origin(viewFrame, indicatorWidth), contentView.frame.size.height - _indicatorHeight, indicatorWidth, _indicatorHeight);
    
    self.userInteractionEnabled = NO; //prevents from a ux glitch until the animation ends
    [UIView animateWithDuration:animated ? .3 : 0 animations:^{
        indicatorView.backgroundColor = color2Switch2;
        indicatorView.frame = finalFrame;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
    
    [self scrollRectToVisible:viewFrame animated:animated];
}

static char const * const ObjectDataKey = "HyperSegmentedControlAssociatedObject";

-(void)reloadView
{
    for (UIView* aView in contentView.subviews) {
        [aView removeFromSuperview];
    }
    
    [items removeAllObjects];
    
    UIView* lastView;
    NSUInteger numberOfItems = [_hyperSegmentedControlDataSource numberOfViewsForHyperSegmentedControl:self];
    
    if (numberOfItems == 0)
        return;
    
    for (NSUInteger i = 0; i != numberOfItems; i++)
    {
        UIView* aView = [_hyperSegmentedControlDataSource HyperSegmentedControl:self viewForItemAtIndex:i];
        CGSize aViewSize = [_hyperSegmentedControlDataSource HyperSegmentedControl:self sizeOfItemAtIndex:i];
        UIColor* aViewColor;
        if ([_hyperSegmentedControlDataSource respondsToSelector:@selector(HyperSegmentedControl:colorOfIndicatorAtIndex:)])
            aViewColor = [_hyperSegmentedControlDataSource HyperSegmentedControl:self colorOfIndicatorAtIndex:i];
        else
            aViewColor = _indicatorColor;
        
        aView.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView addSubview:aView];
        
        NSLayoutConstraint* leftCon;
        if (lastView)
            leftCon = [NSLayoutConstraint constraintWithItem:aView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        else
            leftCon = [NSLayoutConstraint constraintWithItem:aView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        
        NSLayoutConstraint* yCon = [NSLayoutConstraint constraintWithItem:aView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        
        NSLayoutConstraint* widthCon = [NSLayoutConstraint constraintWithItem:aView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:aViewSize.width];
        
        NSLayoutConstraint* heightCon = [NSLayoutConstraint constraintWithItem:aView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:aViewSize.height];
        
        //        NSLayoutConstraint* bottomCon = [NSLayoutConstraint constraintWithItem:aView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:centeredView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        
        [contentView addConstraints:@[leftCon, yCon, widthCon, heightCon]];
        
        lastView = aView;
        
        UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTap:)];
        [aView addGestureRecognizer:tapGest];
        aView.userInteractionEnabled = YES;
        
        //        objc_setAssociatedObject(self, ObjectDataKey, newObjectData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSDictionary* dic = @{@"index": @(i), @"view": [[_weakContainer alloc] initWithWeakObject:aView], @"size": [NSValue valueWithCGSize:aViewSize], @"gest": tapGest, @"color": aViewColor};
        
        objc_setAssociatedObject(tapGest, ObjectDataKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [items addObject:dic];
    }
    
    NSLayoutConstraint* lastViewRight = [NSLayoutConstraint constraintWithItem:lastView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    [contentView addConstraint:lastViewRight];
    
    [contentView layoutIfNeeded];
    [contentView addSubview:indicatorView];
    [self setSelectedIndex:_selectedIndex animated:NO];
}


-(void)itemTap:(UITapGestureRecognizer*)gest
{
    NSDictionary* dic = objc_getAssociatedObject(gest, ObjectDataKey);
    NSUInteger itemIndex2Select = [dic[@"index"] unsignedIntegerValue];
    if ([_hyperSegmentedControlDelegate respondsToSelector:@selector(HyperSegmentedControl:didSelectedItemAtIndex:)])
        [_hyperSegmentedControlDelegate HyperSegmentedControl:self didSelectedItemAtIndex:itemIndex2Select];
    [self setSelectedIndex:itemIndex2Select animated:YES];
}

-(void)setPreciseIndex:(float)preciseIndex
{
    if (preciseIndex < 0 || preciseIndex > items.count-1) //invalid index, ignore it...
        return;
    
    _preciseIndex = preciseIndex;
    
    int lowerIndex = floorf(_preciseIndex);
    int upperIndex = ceilf(_preciseIndex);
    CGFloat progress = _preciseIndex - lowerIndex;
    
    NSDictionary* lowerItemDic = items[lowerIndex];
    CGRect lowerItemFrame = [(UIView*)[lowerItemDic[@"view"] weakObject] frame];
    CGRect lowerFinalFrame = CGRectMake(lowerItemFrame.origin.x, contentView.frame.size.height - _indicatorHeight, lowerItemFrame.size.width, _indicatorHeight);
    UIColor* lowerColor = lowerItemDic[@"color"];
    
    NSDictionary* upperItemDic = items[upperIndex];
    CGRect upperItemFrame = [(UIView*)[upperItemDic[@"view"] weakObject] frame];
    CGRect upperFinalFrame = CGRectMake(upperItemFrame.origin.x, contentView.frame.size.height - _indicatorHeight, upperItemFrame.size.width, _indicatorHeight);
    UIColor* upperColor = upperItemDic[@"color"];
    
    CGFloat lowerWidth = lowerFinalFrame.size.width;
    CGFloat upperWidth = upperFinalFrame.size.width;
    
    if ([_hyperSegmentedControlDataSource respondsToSelector:@selector(HyperSegmentedControl:widthOfIndicatorAtIndex:)])
    {
        lowerWidth = [_hyperSegmentedControlDataSource HyperSegmentedControl:self widthOfIndicatorAtIndex:lowerIndex];
        upperWidth = [_hyperSegmentedControlDataSource HyperSegmentedControl:self widthOfIndicatorAtIndex:upperIndex];
    }
    
    CGFloat lowerItemOriginX = calculate_x_origin(lowerFinalFrame, lowerWidth);
    CGFloat upperItemOriginX = calculate_x_origin(upperFinalFrame, upperWidth);
    
    CGRect finalFrame = CGRectMake(lowerItemOriginX + (upperItemOriginX - lowerItemOriginX) * progress, upperFinalFrame.origin.y, lowerWidth + (upperWidth - lowerWidth) * progress, _indicatorHeight);
    
    UIColor* finalColor = [helper linearColorBetweenLowerColor:lowerColor andUpperColor:upperColor andProgress:progress];
    
    indicatorView.frame = finalFrame;
    indicatorView.backgroundColor = finalColor;
    
    [self scrollRectToVisible:finalFrame animated:NO];
}


-(void)snapToNearestAnimated:(BOOL)animated
{
    if (ceilf(_preciseIndex) - _preciseIndex > _preciseIndex - floorf(_preciseIndex)) //go to lower
        [self setSelectedIndex:floorf(_preciseIndex) animated:animated];
    else
        [self setSelectedIndex:ceilf(_preciseIndex) animated:animated];
    
}


@end
