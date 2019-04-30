//
//  MyAnimations.h
//  Prediscore
//
//  Created by Hamidreza Vaklian on 5/23/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAnimations : NSObject

+(CAAnimation*)getShakeAnimationWithRate:(CGFloat)wobbleAngleOriginal onlyDescend:(BOOL)onlyDescend;

@end
