//
//  CALayer+Extensions.m
//  mactehrannew
//
//  Created by Hamidreza Vakilian on 7/29/1396 AP.
//  Copyright © 1396 archibits. All rights reserved.
//

#import "CALayer+Extensions.h"

@implementation CALayer (Extensions)

//sets the new anchor point (x,y) for the layer preserving it's frame
-(void)pivot_setRatioBasedAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint absAnchorPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y);
    [self pivot_setAbsoluteAnchorPoint:absAnchorPoint];
}

//sets the new anchor point (x,y) for the layer preserving it's frame
-(void)pivot_setAbsoluteAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint newPoint = anchorPoint;
    anchorPoint = CGPointMake(anchorPoint.x / self.bounds.size.width, anchorPoint.y / self.bounds.size.height);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.anchorPoint.x,
                                   self.bounds.size.height * self.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, CATransform3DGetAffineTransform(self.transform));
    oldPoint = CGPointApplyAffineTransform(oldPoint, CATransform3DGetAffineTransform(self.transform));
    
    CGPoint position = self.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    self.position = position;
    self.anchorPoint = anchorPoint;
}

@end
