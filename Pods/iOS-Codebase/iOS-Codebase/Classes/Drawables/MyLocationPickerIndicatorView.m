//
//  MyLocationPickerIndicatorView.m
//  Kababchi
//
//  Created by hAmidReza on 7/20/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "MyLocationPickerIndicatorView.h"
#import "MyShapeView.h"
#import "UIView+SDCAutoLayout.h"
#import "Codebase_definitions.h"

#define kLiftOffsetMin 2
#define kLiftOffsetMax 50
#define kLiftMaxTransform 1.2

@interface MyLocationPickerIndicatorView ()
{
    CAShapeLayer* shadowLayer;
    NSLayoutConstraint* locationPinBottom;
}

@property (retain, nonatomic) MyShapeView* locationPin;
@property (retain, nonatomic) UIImageView* pinShadow;

@end

@implementation MyLocationPickerIndicatorView

-(void)initialize
{
    [super initialize];
    
    [self sdc_pinCubicSize:160];
    
    _locationPin = [[MyShapeView alloc] initWithShapeDesc:__codebase_k_iconMyLocationPickerPin() andShapeTintColor:_locationPinTintColor];
    _locationPin.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_locationPin];
    [_locationPin sdc_pinCubicSize:70];
    //    locationPinTop = [_locationPin sdc_alignTopEdgeWithSuperviewMargin:0];
    
    [_locationPin sdc_horizontallyCenterInSuperview];
    
    _pinShadow = [UIImageView new];
    _pinShadow.image = [UIImage imageNamed:@"pinShadow.png"];
    _pinShadow.contentMode = UIViewContentModeScaleAspectFit;
    _pinShadow.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_pinShadow];
    [_pinShadow sdc_pinSize:CGSizeMake(20, 4)];
    [_pinShadow sdc_centerInSuperviewWithOffset:UIOffsetMake(0, 35)];
    
    locationPinBottom = [_locationPin sdc_alignEdge:UIRectEdgeBottom withEdge:UIRectEdgeTop ofView:_pinShadow inset:kLiftOffsetMin];
}

-(void)lift
{
    [UIView animateWithDuration:.3 animations:^{
        locationPinBottom.constant = -kLiftOffsetMax;
        _locationPin.transform = CGAffineTransformMakeScale(kLiftMaxTransform, kLiftMaxTransform);
        [self layoutIfNeeded];
    }];
}

-(void)drop
{
    [UIView animateWithDuration:.3 animations:^{
        locationPinBottom.constant = kLiftOffsetMin;
        _locationPin.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [self layoutIfNeeded];
    }];
}

-(void)setLocationPinTintColor:(UIColor *)locationPinTintColor
{
    _locationPinTintColor = locationPinTintColor;
    _locationPin.shapeTintColor = _locationPinTintColor;
}

@end

