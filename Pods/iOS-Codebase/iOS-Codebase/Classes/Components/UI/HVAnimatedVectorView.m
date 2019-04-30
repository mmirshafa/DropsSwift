//
//  HVAnimatedVectorView.m
//  Aiywa2
//
//  Created by hAmidReza on 5/31/17.
//  Copyright © 2017 nizek. All rights reserved.
//

#import "HVAnimatedVectorView.h"
#import "HVAnimatedVector.h"
#import "Codebase_definitions.h"

@interface HVAnimatedVectorView ()
{
    NSDictionary* animationDesc;
    HVAnimatedVector* layer;
    BOOL initialLayoutDone;
}

@end

@implementation HVAnimatedVectorView

-(CALayer*)animatedVectorLayer
{
    return layer;
}

-(instancetype)initWithAnimationDesc:(NSDictionary*)desc
{
    self = [super init];
    if (self)
    {
        animationDesc = desc;
        _durationFactor = 1.0f;
        _timingFunction = kCAMediaTimingFunctionEaseInEaseOut;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if ( self.frame.size.width > 0 && self.frame.size.height > 0 && !initialLayoutDone)
    {
        layer = [[HVAnimatedVector alloc] initWithAnimationDesc:animationDesc andTimingFunction:_timingFunction andDurationFactor:_durationFactor];
        [self.layer addSublayer:layer];
        [layer setFrame:self.bounds animated:NO];
        initialLayoutDone = YES;
        if (_layerDidLoad)
            _layerDidLoad(layer);
    }
    else
        
    {
        [layer setFrame:self.bounds animated:NO];
    }
}


@end

