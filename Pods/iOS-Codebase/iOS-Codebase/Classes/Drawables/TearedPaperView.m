//
//  TearedPaperView.m
//  Kababchi
//
//  Created by hAmidReza on 7/17/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "TearedPaperView.h"
#import "UIView+SDCAutoLayout.h"

#define kDefaultEdge 10

@interface TearedPaperView ()
{
    CAShapeLayer* shapeLayer;
    UIView* contentView;
}

@end

@implementation TearedPaperView

-(void)initialize
{
    [super initialize];
    
    
    shapeLayer = [CAShapeLayer new];
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:shapeLayer];
    
    contentView = [UIView new];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [super addSubview:contentView];
    [contentView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    
    
    
    _edge = kDefaultEdge;
    _adjustEdgeToFitWidth = YES;
    _seed = true;
    _etchType = TearedPaperViewEtchTypeTop | TearedPaperViewEtchTypeBottom;
}

-(void)setShadowColor:(UIColor *)shadowColor
{
    shapeLayer.shadowColor = shadowColor.CGColor;
}

-(UIColor *)shadowColor
{
    return [UIColor colorWithCGColor:shapeLayer.shadowColor];
}

-(void)setShadowRadius:(CGFloat)shadowRadius
{
    shapeLayer.shadowRadius = shadowRadius;
}

-(CGFloat)shadowRadius
{
    return shapeLayer.shadowRadius;
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity
{
    shapeLayer.shadowOpacity = shadowOpacity;
}

-(CGFloat)shadowOpacity
{
    return shapeLayer.shadowOpacity;
}

-(void)setShadowOffset:(CGSize)shadowOffset
{
    shapeLayer.shadowOffset = shadowOffset;
}

-(CGSize)shadowOffset
{
    return shapeLayer.shadowOffset;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    if (frame.size.width < _edge)
        return;
    
    UIBezierPath* path = [self getPathWithFrame:frame];
    
    shapeLayer.path = path.CGPath;
    CAShapeLayer* maskLayer = [CAShapeLayer new];
    maskLayer.path = path.CGPath;
    contentView.layer.mask = maskLayer;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    contentView.backgroundColor = backgroundColor;
}

-(UIColor *)backgroundColor
{
    return contentView.backgroundColor;
}

-(UIBezierPath*)getPathWithFrame:(CGRect)frame
{
    UIBezierPath* path = [UIBezierPath new];
    
    CGFloat refinedEdge;
    if (_adjustEdgeToFitWidth)
    {
        int edges_count = ((int)(frame.size.width / _edge));
        if (edges_count % 2 == 1) //if off
            edges_count--;
        refinedEdge = frame.size.width / edges_count;
    }
    else
        refinedEdge = _edge;
    
    CGFloat xOffset = 0;
    
    if ( (_etchType & TearedPaperViewEtchTypeTop) == TearedPaperViewEtchTypeTop)
    {
        
        [path moveToPoint:CGPointMake(0, _seed ? refinedEdge : 0)];
        
        while (fabs(xOffset-frame.size.width) > .1) {
            [path addLineToPoint:CGPointMake(xOffset+refinedEdge, _seed ? 0 : refinedEdge)];
            [path addLineToPoint:CGPointMake(xOffset + refinedEdge + refinedEdge, _seed ? refinedEdge : 0)];
            xOffset += 2*refinedEdge;
        }
        
        xOffset -= 2*refinedEdge;
    }
    else
    {
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame))];
        xOffset = CGRectGetMaxX(frame);
    }
    
    if ( (_etchType & TearedPaperViewEtchTypeBottom) == TearedPaperViewEtchTypeBottom)
    {
        xOffset = CGRectGetMaxX(frame);
        
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame) - (_seed ?refinedEdge : 0))];
        
        while (fabs(xOffset) > .0001) {
            [path addLineToPoint:CGPointMake(xOffset-refinedEdge, CGRectGetMaxY(frame) - (_seed ? 0 : refinedEdge))];
            [path addLineToPoint:CGPointMake(xOffset - refinedEdge - refinedEdge, CGRectGetMaxY(frame) - (_seed ? refinedEdge : 0))];
            xOffset -= 2*refinedEdge;
        }
        
        xOffset += 2*refinedEdge;
        
        [path addLineToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame) - (_seed ? 0 : refinedEdge))];
    }
    else
    {
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
    }
    
    [path closePath];
    
    return path;
}

-(void)addSubview:(UIView *)view
{
    [contentView addSubview:view];
}


-(void)setTintColor:(UIColor *)tintColor
{
    shapeLayer.fillColor = tintColor.CGColor;
}

-(UIColor *)tintColor
{
    return [UIColor colorWithCGColor:shapeLayer.fillColor];
}
@end
