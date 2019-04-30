//
//  MyRadialGradientLayer.h
//  Pods
//
//  Created by hAmidReza on 7/18/17.
//
//

#import <QuartzCore/QuartzCore.h>

@interface MyRadialGradientLayer : CALayer


/**
 min: (0, 0) max: (1,1)
 */
@property (assign, nonatomic) CGPoint centerPoint;
@property (assign, nonatomic) CGFloat radius;

/**
 array of cgcolors
 */
@property (retain, nonatomic) NSArray* colors;
@property (retain, nonatomic) NSArray* locations;

@end
