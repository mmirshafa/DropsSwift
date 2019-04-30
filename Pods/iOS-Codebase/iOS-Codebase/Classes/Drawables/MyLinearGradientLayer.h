//
//  MyLinearGradientLayer.h
//  Pods
//
//  Created by hAmidReza on 7/18/17.
//
//

#import <QuartzCore/QuartzCore.h>

@interface MyLinearGradientLayer : CALayer

@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGPoint endPoint;
@property (retain, nonatomic) NSArray* colors;
@property (retain, nonatomic) NSArray* locations;

@end
