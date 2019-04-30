//
//  CALayer+Extensions.h
//  mactehrannew
//
//  Created by Hamidreza Vakilian on 7/29/1396 AP.
//  Copyright © 1396 archibits. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Extensions)

-(void)pivot_setRatioBasedAnchorPoint:(CGPoint)anchorPoint;
-(void)pivot_setAbsoluteAnchorPoint:(CGPoint)anchorPoint;

@end
