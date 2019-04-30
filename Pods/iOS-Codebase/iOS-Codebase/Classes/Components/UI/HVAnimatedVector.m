//
//  HVAnimatedVector.m
//  hyperVector
//
//  Created by Hamidreza Vaklian on 7/10/16.
//  Copyright © 2016 innovian. All rights reserved.
//

#import "HVAnimatedVector.h"
#import "CALayer+MBAnimationPersistence.h"
#import "HVLayerAnimationPersistence.h"

@interface HVAnimatedVector () <CAAnimationDelegate>
{
    NSDictionary* animationDesc;
    CGSize size;
    BOOL isInitialized;
    NSString* timingFunction;
    float durationFactor;
}
@end

@implementation HVAnimatedVector
-(instancetype)initWithAnimationDesc:(NSDictionary*)desc andTimingFunction:(NSString*)theTimingFunction andDurationFactor:(float)_durationFactor
{
    self = [super init];
    if (self)
    {
        animationDesc = desc;
        timingFunction = theTimingFunction;
        durationFactor = _durationFactor;
        [self initialize];
    }
    return self;
}

-(instancetype)initWithAnimationDesc:(NSDictionary*)desc andTimingFunction:(NSString*)theTimingFunction
{
    self = [super init];
    if (self)
    {
        animationDesc = desc;
        timingFunction = theTimingFunction;
        durationFactor = 1.0f;
        [self initialize];
    }
    return self;
}

-(instancetype)initWithAnimationDesc:(NSDictionary*)desc
{
    self = [super init];
    if (self)
    {
        animationDesc = desc;
        durationFactor = 1.0f;
        timingFunction = kCAMediaTimingFunctionEaseInEaseOut;
        [self initialize];
    }
    return self;
}

-(void)setFrame:(CGRect)frame animated:(BOOL)animated
{
    
    if (!animated)
    {
        [CATransaction begin];
        [CATransaction setDisableActions: YES];
        float scale = frame.size.width / size.width;
        self.affineTransform = CGAffineTransformMakeScale(scale, scale);
        [self setFrame:frame];
        [CATransaction commit];
    }
    else
    {
        float scale = frame.size.width / size.width;
        //    [UIView animateWithDuration:duration delay:0 options:uiviewAnimationOption animations:^{
        self.affineTransform = CGAffineTransformMakeScale(scale, scale);
        [self setFrame:frame];
        
    }
    
    return;
    
}

//-(void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//
//    if (isInitialized)
//    {
//        float scale = frame.size.width / size.width;
//
////        self.position = CGPointMake(frame.size.width / 2, frame.size.height / 2);
//        self.affineTransform = CGAffineTransformMakeScale(scale, scale);
//
//    }
//}

-(void)initialize
{
    [self layerFromAnimationDesc:animationDesc];
    isInitialized = YES;
}

#define CGPointFromArray(x) CGPointMake([x[0] floatValue], [x[1] floatValue])
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

-(void)layerFromAnimationDesc:(NSDictionary*)desc
{
    //    rootLayer = [CALayer new];
    
    
    //    NSMutableArray* elementLayers = [NSMutableArray new];
    
    u_long element_count = [desc[@"frames"][0][@"group"] count];
    size = CGSizeMake([desc[@"frames"][0][@"group"][0][@"size"][0] floatValue] , [desc[@"frames"][0][@"group"][0][@"size"][1] floatValue]);
    u_long frame_count = [desc[@"frames"] count];
    float duration = [desc[@"duration"] floatValue];
    
    //    for (int i = 0; i != element_count; i++)
    //         [elementLayers addObject:@{@"layer": [CALayer]}];
    
    //    for (int i = 0; i != frame_count; i++)
    //    {
    
    for (int i = 0; i != element_count; i++)
    {
        NSMutableDictionary* element_animation_desc = [NSMutableDictionary new];
        // look into the first frame
        NSDictionary* firstFrame = desc[@"frames"][0];
        NSDictionary* vectorInFirstFrame = firstFrame[@"group"][i];
        if ([vectorInFirstFrame[@"fill"][@"type"] isEqualToString:@"rgb"])
        {
            element_animation_desc[@"type"] = @"rgb-anim";
            element_animation_desc[@"times"] = [NSMutableArray new];
            element_animation_desc[@"paths"] = [NSMutableArray new];
            element_animation_desc[@"fills"] = [NSMutableArray new];
            
            //
            for (int j = 0; j != frame_count; j++)
            {
                NSDictionary* frame = desc[@"frames"][j];
                NSDictionary* vector = frame[@"group"][i];
                
                [element_animation_desc[@"times"] addObject:frame[@"time"]];
                [element_animation_desc[@"paths"] addObject:(id)[HVAnimatedVector bezierPathWithDescArray:vector[@"path"] withSize:size].CGPath];
                [element_animation_desc[@"fills"] addObject:(id)[self UIColorFromArray:vector[@"fill"][@"colors"]].CGColor];
            }
            
            HVPersistetAnimationLayer* vectorLayer = [HVPersistetAnimationLayer new];
            
            //            vectorLayer.bounds = CGRectMake(0, 0, 100, 100);
            //                vectorLayer.path = (__bridge CGPathRef _Nullable)(element_animation_desc[@"paths"][0]);
            //                vectorLayer.fillColor = [UIColor greenColor].CGColor;
            //                vectorLayer.backgroundColor = [[UIColor yellowColor] CGColor];
            
            
            CAKeyframeAnimation* pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            pathAnimation.removedOnCompletion = NO;
            pathAnimation.duration = duration * durationFactor;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
            pathAnimation.values = element_animation_desc[@"paths"];
            pathAnimation.keyTimes = element_animation_desc[@"times"];
            pathAnimation.autoreverses = NO;
            pathAnimation.repeatCount = INFINITY;
            //    animation.removedOnCompletion = NO;
            //    animation.fillMode = kCAFillModeForwards;
            [vectorLayer addAnimation:pathAnimation forKey:@"thePathAnimation"];
            
            CAKeyframeAnimation* fillAnimation = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
            fillAnimation.removedOnCompletion = NO;
            fillAnimation.duration = duration * durationFactor;
            fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
            fillAnimation.values = element_animation_desc[@"fills"];
            fillAnimation.keyTimes = element_animation_desc[@"times"];
            fillAnimation.autoreverses = NO;
            fillAnimation.repeatCount = INFINITY;
            //    animation.removedOnCompletion = NO;
            //    animation.fillMode = kCAFillModeForwards;
            [vectorLayer addAnimation:fillAnimation forKey:@"theFillColorAnimation"];
            
            vectorLayer.zPosition = [vectorInFirstFrame[@"zOrder"] floatValue] / 1000;
            
            [vectorLayer MB_setCurrentAnimationsPersistent];
            
            [self addSublayer:vectorLayer];
        }
    }
}

-(CGSize)CGSizeFromArray:(NSArray*)arr
{
    return CGSizeMake([arr[0] floatValue], [arr[1] floatValue]);
}

-(UIColor*)UIColorFromArray:(NSArray*)arr
{
    return RGBAColor([arr[0] floatValue], [arr[1] floatValue], [arr[2] floatValue], [arr[3] floatValue]/100);
}

+(NSArray*)colorArrayFromArray:(NSArray*)arr
{
    NSMutableArray* result = [NSMutableArray new];
    for (NSArray* colorDesc in arr) {
        [result addObject:(id)RGBAColor([colorDesc[0] floatValue], [colorDesc[1] floatValue], [colorDesc[2] floatValue], [colorDesc[3] floatValue] / 100).CGColor];
    }
    
    return result;
}

+(UIBezierPath*)bezierPathWithDescArray:(NSArray*)array withSize:(CGSize)size
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGFloat w = size.width;
    CGFloat h = size.height;
    for (NSArray* arr in array) {
        NSString* cmd = arr[0];
        if ([cmd isEqualToString:@"m"]) //move to point
            [path moveToPoint:CGPointMake([arr[1] floatValue]/100*w, [arr[2] floatValue]/100*h)];
        else if ([cmd isEqualToString:@"l"]) //line
            [path addLineToPoint:CGPointMake([arr[1] floatValue]/100*w, [arr[2] floatValue]/100*h)];
        else if ([cmd isEqualToString:@"c"]) //curve
            [path addCurveToPoint:CGPointMake([arr[1] floatValue]/100*w, [arr[2] floatValue]/100*h) controlPoint1:CGPointMake([arr[3] floatValue]/100*w, [arr[4] floatValue]/100*h) controlPoint2:CGPointMake([arr[5] floatValue]/100*w, [arr[6] floatValue]/100*h)];
    }
    
    [path closePath];
    
    return path;
}


@end

