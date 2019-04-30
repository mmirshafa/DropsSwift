//
//  VectorLayer.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 7/29/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "HVLayerAnimationPersistence.h"

@implementation CALayer (HVLayerAnimationPersistence)

-(void)HV_restoreSublayerAnimations
{
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self respondsToSelector:@selector(HV_restoreAnimations)])
        [self performSelector:@selector(HV_restoreAnimations)];
	#pragma clang diagnostic pop
    
    for (CALayer* sublayer in [self sublayers])
        [sublayer HV_restoreSublayerAnimations];
}

@end

@interface HVPersistetAnimationLayer ()
{
    NSMutableDictionary* persistedAnimations;
}

@end

@implementation HVPersistetAnimationLayer

-(void)setAnchorPoint:(CGPoint)anchorPoint
{
	CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x,
								   self.bounds.size.height * anchorPoint.y);
	CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.anchorPoint.x,
								   self.bounds.size.height * self.anchorPoint.y);
	
//	newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
//	oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
	
	CGPoint position = self.position;
	
	position.x -= oldPoint.x;
	position.x += newPoint.x;
	
	position.y -= oldPoint.y;
	position.y += newPoint.y;
	
	self.position = position;
//	self.anchorPoint = anchorPoint;
	
	[super setAnchorPoint:anchorPoint];
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

-(void)initialize
{
    persistedAnimations = [NSMutableDictionary new];
}

-(void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key
{
    persistedAnimations[key] = anim;
    
    [super addAnimation:anim forKey:key];
}

-(void)HV_restoreAnimations
{
    [persistedAnimations enumerateKeysAndObjectsUsingBlock:^(NSString* key, CAAnimation* anim, BOOL * _Nonnull stop) {
        if (![self animationForKey:key])
        {
            [super addAnimation:anim forKey:key];
        }
    }];
}

@end
