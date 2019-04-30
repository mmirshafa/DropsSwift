//
//  HVAnimatedVectorView.h
//  Aiywa2
//
//  Created by hAmidReza on 5/31/17.
//  Copyright © 2017 nizek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVAnimatedVectorView : UIView

-(instancetype)initWithAnimationDesc:(NSDictionary*)desc;


/**
 defaults to: easeinout
 */
@property (retain, nonatomic) NSString* timingFunction;


/**
 defaults to 1.0f
 */
@property (assign, nonatomic) float durationFactor;

@property (copy, nonatomic) void (^layerDidLoad)(CALayer* layer);
-(CALayer*)animatedVectorLayer;
@end

