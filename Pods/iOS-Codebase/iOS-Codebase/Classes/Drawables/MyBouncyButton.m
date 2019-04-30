//
//  MyBouncyButton.m
//  mactehrannew
//
//  Created by hAmidReza on 5/29/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "MyBouncyButton.h"
//#import "helper.h"
//#import "Codebase.h"
#import "MyShapeView.h"
#import <POP/pop.h>

@interface MyBouncyButton ()

@end

@implementation MyBouncyButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _setDefaults];
    }
    return self;
}

-(void)_setDefaults
{
    _onOffBehavior = YES;
    _u_offstate_transform_ratio = 1;
    _u_onstate_transform_ratio = 1;
    _u_onstate_bounce = 20.0f;
    _u_offstate_bounce = 10.0f;
    _u_normal_velocity = 10.0f;
    _u_on_velocity = 10.f;
    _u_off_velocity = 10.f;
}

-(instancetype)initWithShapeDesc:(NSArray *)desc andShapeTintColor:(UIColor *)shapeTintColor andButtonClick:(void (^)(BOOL on))buttonClick;
{
    self = [super initWithShapeDesc:desc andShapeTintColor:shapeTintColor andButtonClick:nil];
    if (self)
    {
        _bouncyButtonClick = buttonClick;
        _icon1 = desc;
        _shapeTintColor1 = shapeTintColor;
        [self _setDefaults];
        
        [self uniconf_restore];
    }
    return self;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _backgroundColor1 = backgroundColor ? backgroundColor : [UIColor clearColor];
}

-(void)setOn:(BOOL)on animated:(BOOL)animated
{
    if (!_onOffBehavior)
        return;
    
    _on = on;
    
    [UIView animateWithDuration:animated ? .3 : 0 animations:^{
        [self refreshUI];
    }];
    
    if (animated)
        [self performPopAnimation];
    else
    {
        if (_on)
        {
            self.transform = CGAffineTransformMakeScale(_u_onstate_transform_ratio + .01, _u_onstate_transform_ratio + .01);
        }
        else
            self.transform = CGAffineTransformMakeScale(_u_offstate_transform_ratio + .01, _u_offstate_transform_ratio + .01);
    }
}

-(void)refreshUI
{
    if (_on)
    {
        [super setBackgroundColor:_backgroundColor2 ? _backgroundColor2 : _backgroundColor1];
        self.shapeView.shapeDesc = _icon2 ? _icon2 : _icon1;
        self.shapeView.shapeTintColor = _shapeTintColor2 ? _shapeTintColor2 : _shapeTintColor1;
        if (_borderColor2)
            self.borderColor = _borderColor2;
    }
    else
    {
        [super setBackgroundColor:_backgroundColor1];
        self.shapeView.shapeDesc = _icon1;
        self.shapeView.shapeTintColor = _shapeTintColor1;
        if (_borderColor1)
            self.borderColor = _borderColor1;
    }
}


-(void)setOn:(BOOL)on
{
    [self setOn:on animated:NO];
}

-(void)performPopAnimation
{
    [self pop_removeAllAnimations];
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    if (_onOffBehavior)
    {
        if (_on)
        {
            springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(_u_offstate_transform_ratio, _u_offstate_transform_ratio)];
            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(_u_onstate_transform_ratio + .01, _u_onstate_transform_ratio + .01)];
            springAnimation.springBounciness = _u_onstate_bounce;
            springAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(_u_on_velocity, _u_on_velocity)];
        }
        else
        {
            springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(_u_onstate_transform_ratio, _u_onstate_transform_ratio)];
            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(_u_offstate_transform_ratio + .01, _u_offstate_transform_ratio + .01)];
            springAnimation.springBounciness = _u_offstate_bounce;
            springAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(_u_off_velocity, _u_off_velocity)];
        }
    }
    else
    {
        springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1 + .01, 1 + .01)];
        springAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(_u_normal_velocity, _u_normal_velocity)];
    }
    [self pop_addAnimation:springAnimation forKey:@"springAnimation"];
}

-(void)buttonTouch:(id)sender
{
    if (_canChangeToMode)
        if (!_canChangeToMode(_onOffBehavior ? !_on : false))
            return;
    
    [self performPopAnimation];
    
    if (_onOffBehavior)
    {
        [self setOn:!_on animated:YES];
        
        if (_bouncyButtonClick)
            _bouncyButtonClick(_on);
    }
    else
        _bouncyButtonClick(false);
}


-(void)setIcon2:(NSArray *)icon2
{
    _icon2 = icon2;
    [self refreshUI];
}

-(void)setBackgroundColor2:(UIColor *)backgroundColor2
{
    _backgroundColor2 = backgroundColor2;
    [self refreshUI];
}

-(void)setShapeTintColor2:(UIColor *)shapeTintColor2
{
    _shapeTintColor2 = shapeTintColor2;
    [self refreshUI];
}


-(void)setIcon1:(NSArray *)icon1
{
    _icon1 = icon1;
    [self refreshUI];
}

-(void)setBackgroundColor1:(UIColor *)backgroundColor1
{
    _backgroundColor1 = backgroundColor1;
    [self refreshUI];
}

-(void)setShapeTintColor1:(UIColor *)shapeTintColor1
{
    _shapeTintColor1 = shapeTintColor1;
    [self refreshUI];
}
-(void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    
    self.layer.cornerRadius = _cornerRadius;
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

@end
