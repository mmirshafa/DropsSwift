//
//  VectorLayer.h
//  Prediscore
//
//  Created by Hamidreza Vaklian on 7/29/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@interface CALayer (HVLayerAnimationPersistence)
-(void)HV_restoreSublayerAnimations;
@end

@interface HVPersistetAnimationLayer : CAShapeLayer



@end
