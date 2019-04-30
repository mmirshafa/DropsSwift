//
//  MyAnimations.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 5/23/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "MyAnimations.h"

@implementation MyAnimations

+(CAAnimation*)getShakeAnimationWithRate:(CGFloat)wobbleAngleOriginal onlyDescend:(BOOL)onlyDescend
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    NSMutableArray* anims = [NSMutableArray new];
    
    if (!onlyDescend)
    {
        CGFloat wobbleAngle = 0.001f;
        int sign = +1;
        while (wobbleAngle < wobbleAngleOriginal) {
            NSValue* val = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(sign*wobbleAngle, 0.0f, 0.0f, 1.0f)];
            [anims addObject:val];
            sign = sign * -1;
            if (sign == 1)
                wobbleAngle *= 2;
        }
    }
    
    CGFloat wobbleAngle = wobbleAngleOriginal;
    int sign = +1;
    while (wobbleAngle > 0.001) {
        NSValue* val = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(sign*wobbleAngle, 0.0f, 0.0f, 1.0f)];
        [anims addObject:val];
        sign = sign * -1;
        if (sign == 1)
            wobbleAngle /= 2;
    }
    
    animation.values = anims;
    
    animation.autoreverses = NO;
    animation.duration = onlyDescend ? 1.5 : 2.0;
    animation.repeatCount = 1;
    
//    animation.delegate = self;
	
    return animation;
}


@end
