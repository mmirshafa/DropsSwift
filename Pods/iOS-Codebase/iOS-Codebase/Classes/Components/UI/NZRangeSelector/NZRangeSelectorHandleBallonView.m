//
//  NZRangeSelectorHandleView.m
//  MyAthath
//
//  Created by Developer on 1/21/19.
//  Copyright © 2019 Nizek. All rights reserved.
//

#import "NZRangeSelectorHandleBallonView.h"
#import "UIView+SDCAutoLayout.h"
#import "UIView+Extensions.h"
#import "UIColor+Extensions.h"

@interface NZRangeSelectorHandleBallonView ()
{
    UIView *rectangle;
    CAShapeLayer *leftShape;
    CAShapeLayer *rightShape;
}

@end

@implementation NZRangeSelectorHandleBallonView


-(instancetype)initWithType:(NZRangeSelectorHandleBallonViewType)type
{
    self = [super init];
    if (self) {
        
        self.type = type;

        rectangle = [UIView new2];
        rectangle.backgroundColor = [UIColor yellowColor];
        rectangle.layer.cornerRadius = 2;
        rectangle.layer.masksToBounds = YES;
        [self addSubview:rectangle];
        [rectangle sdc_alignEdgesWithSuperview:UIRectEdgeAll insets:UIEdgeInsetsMake(0, 0, -6, 0)];
        
        if (self.type == NZRangeSelectorHandleBallonViewTypeLeft) {
            leftShape = [CAShapeLayer new];
            leftShape.contentsScale = [[UIScreen mainScreen] scale];
            [self.layer addSublayer:leftShape];
        }
        if (self.type == NZRangeSelectorHandleBallonViewTypeRight) {
            rightShape = [CAShapeLayer new];
            rightShape.contentsScale = [[UIScreen mainScreen] scale];
            [self.layer addSublayer:rightShape];
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIBezierPath *leftPath = [UIBezierPath new];
    [leftPath moveToPoint:CGPointMake(0, CGRectGetHeight(rectangle.frame) - 2)];
    [leftPath addLineToPoint:CGPointMake(0, CGRectGetHeight(rectangle.frame) + 6)];
    [leftPath addLineToPoint:CGPointMake(10, CGRectGetHeight(rectangle.frame) - 2)];
    [leftPath closePath];
    
    leftShape.path = leftPath.CGPath;
    
    UIBezierPath *rightPath = [UIBezierPath new];
    [rightPath moveToPoint:CGPointMake(CGRectGetWidth(rectangle.frame), CGRectGetHeight(rectangle.frame) - 2)];
    [rightPath addLineToPoint:CGPointMake(CGRectGetWidth(rectangle.frame), CGRectGetHeight(rectangle.frame) + 6)];
    [rightPath addLineToPoint:CGPointMake(CGRectGetWidth(rectangle.frame) - 10, CGRectGetHeight(rectangle.frame) - 2)];
    [rightPath closePath];
    
    rightShape.path = rightPath.CGPath;
    
}

-(void)setTheColor:(UIColor *)theColor
{
    _theColor = theColor;
    rectangle.backgroundColor = theColor;
    leftShape.fillColor = theColor.CGColor;
    rightShape.fillColor = theColor.CGColor;
}


@end
