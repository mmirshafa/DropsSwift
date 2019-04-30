//
//  myLoadingView.m
//  macTehranLoadingTest
//
//  Created by Hamidreza Vaklian on 4/14/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import "myLoadingView.h"
//#import "Codebase.h"
#import "Codebase_definitions.h"
#import "CALayer+MBAnimationPersistence.h"
#import "VCAppearanceRelatedProtocol.h"

@interface myLoadingView() <VCAppearanceRelatedProtocol>
{
    CALayer* baseLayer;
    CALayer* baseLayer2;
    CAShapeLayer *circle;
    CAShapeLayer *circle2;
    UIImageView* logoView;
    BOOL isInitialized;
}

@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation myLoadingView

-(instancetype)init
{
    self = [super init];
    if (self)
        [self initialize:CGRectMake(0, 0, 20, 20)];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self initialize:frame];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
        [self initialize:self.frame];
    return self;
}

-(void)initialize:(CGRect)frame
{
    
    if (!isInitialized)
    {
        
        if (_durationFactor == 0)
            _durationFactor = 1.0f;
        
        if (!self.color)
            self.color = [UIColor darkGrayColor];
        
        baseLayer  = [CALayer layer];
        baseLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.layer addSublayer:baseLayer];
        
        baseLayer2  = [CALayer layer];
        baseLayer2.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.layer addSublayer:baseLayer2];
        
        
        // Set up the shape of the circle
        float radius = frame.size.width / 2.0f;
        circle = [CAShapeLayer layer];
        circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                                 cornerRadius:radius].CGPath;
        circle.position = CGPointMake(CGRectGetMidX(baseLayer.frame)-radius,
                                      CGRectGetMidY(baseLayer.frame)-radius);
        circle.fillColor = [UIColor clearColor].CGColor;
        circle.strokeColor = self.color.CGColor;
        _defineDeviceScale;
        circle.lineWidth = 2/s;
        
        radius = radius * .8f;
        
        circle2 = [CAShapeLayer layer];
        circle2.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                                  cornerRadius:radius].CGPath;
        circle2.position = CGPointMake(CGRectGetMidX(baseLayer.frame)-radius,
                                       CGRectGetMidY(baseLayer.frame)-radius);
        circle2.fillColor = [UIColor clearColor].CGColor;
        circle2.strokeColor = [UIColor blackColor].CGColor;
        circle2.lineWidth = 2/s;
        
        // Add to parent layer
        [baseLayer addSublayer:circle];
        [baseLayer2 addSublayer:circle2];
        
        isInitialized = YES;
        
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    
    baseLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    baseLayer2.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    float radius = frame.size.width / 2.0f;
    
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    circle.position = CGPointMake(CGRectGetMidX(baseLayer.frame)-radius,
                                  CGRectGetMidY(baseLayer.frame)-radius);
    
    radius = radius * .8f;
    
    circle2.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                              cornerRadius:radius].CGPath;
    circle2.position = CGPointMake(CGRectGetMidX(baseLayer.frame)-radius,
                                   CGRectGetMidY(baseLayer.frame)-radius);
    
    
}
-(void)setColor:(UIColor *)color
{
    _color = color;
    circle.strokeColor = self.color.CGColor;
    circle2.strokeColor = self.color.CGColor;
}

-(void)startAnimating
{
    [self strokeCircle1];
    [self rotateCircle1];
    
    if (!_onlyOneCircle)
    {
        [self strokeCircle2];
        [self rotateCircle2];
    }
}

-(void)setOnlyOneCircle:(BOOL)onlyOneCircle
{
    _onlyOneCircle = onlyOneCircle;
    baseLayer2.hidden = onlyOneCircle;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self stopAnimating];
    [self startAnimating];
}

-(void)stopAnimating
{
    [baseLayer removeAllAnimations];
    [baseLayer2 removeAllAnimations];
    [circle removeAllAnimations];
    [circle2 removeAllAnimations];
}

-(void)rotateCircle1
{
    CABasicAnimation *rota = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rota.duration = 2.0f * _durationFactor;
    rota.repeatCount = INFINITY;
    rota.byValue = [NSNumber numberWithFloat:2*M_PI];
    [baseLayer addAnimation: rota forKey: @"rotation"];
    [baseLayer MB_setCurrentAnimationsPersistent];
}

-(void)rotateCircle2
{
    CABasicAnimation *rota2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rota2.duration = 4.0f * _durationFactor;
    rota2.repeatCount = INFINITY;
    rota2.byValue = [NSNumber numberWithFloat:2*M_PI];
    [baseLayer2 addAnimation: rota2 forKey: @"rotation"];
    [baseLayer2 MB_setCurrentAnimationsPersistent];
}

-(void)strokeCircle1
{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 2.0f * _durationFactor;
    animationGroup.repeatCount = INFINITY;
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 1.0f * _durationFactor; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.removedOnCompletion = YES;
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation *drawAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    drawAnimation2.beginTime = 1.0f * _durationFactor;
    drawAnimation2.duration            = 1.0f * _durationFactor; // "animate over 10 seconds or so.."
    drawAnimation2.repeatCount         = 1.0;  // Animate only once..
    
    drawAnimation2.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation2.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation2.removedOnCompletion = YES;
    drawAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    animationGroup.animations = @[drawAnimation, drawAnimation2];
    
    [circle addAnimation:animationGroup forKey:@"drawCircleAnimation"];
    
    [circle MB_setCurrentAnimationsPersistent];
    
    animationGroup.delegate = self;
}

-(void)strokeCircle2
{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 3.0f * _durationFactor;
    animationGroup.repeatCount = INFINITY;
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    drawAnimation.duration            = 1.5f * _durationFactor; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.removedOnCompletion = YES;
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation *drawAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation2.beginTime = 1.5f * _durationFactor;
    drawAnimation2.duration            = 1.0f * _durationFactor; // "animate over 10 seconds or so.."
    drawAnimation2.repeatCount         = 1.0;  // Animate only once..
    
    drawAnimation2.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation2.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation2.removedOnCompletion = YES;
    drawAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    animationGroup.animations = @[drawAnimation, drawAnimation2];
    
    [circle2 addAnimation:animationGroup forKey:@"drawCircleAnimation"];
    
    [circle2 MB_setCurrentAnimationsPersistent];
}


@end

