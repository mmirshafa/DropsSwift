//
//  HVAnimatedVector.h
//  hyperVector
//
//  Created by Hamidreza Vaklian on 7/10/16.
//  Copyright © 2016 innovian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVAnimatedVector : CALayer

-(instancetype)initWithAnimationDesc:(NSDictionary*)desc;
-(instancetype)initWithAnimationDesc:(NSDictionary*)desc andTimingFunction:(NSString*)timingFunction;
-(instancetype)initWithAnimationDesc:(NSDictionary*)desc andTimingFunction:(NSString*)timingFunction andDurationFactor:(float)durationFactor;
-(void)setFrame:(CGRect)frame animated:(BOOL)animated;

@end

