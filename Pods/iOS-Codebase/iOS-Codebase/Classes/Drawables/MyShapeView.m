//
//  MyShapeView.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 7/5/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "MyShapeView.h"
#import "helper.h"
#import "Codebase_definitions.h"
#import "UIView+SDCAutoLayout.h"

//@interface MyShapeView_layer : CAShapeLayer
//
//@end
//
//@implementation MyShapeView_layer
//
////-(id<CAAction>)actionForKey:(NSString *)event
////{
////    if ([event isEqualToString:@"fillColor"])
////    {
////        CABasicAnimation *fillColorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
////        fillColorAnimation.duration = 2;
////        NSLog(@"---> %f", [CATransaction animationDuration]);
////        fillColorAnimation.timingFunction = [CATransaction animationTimingFunction];
////        fillColorAnimation.toValue = (id)[UIColor redColor];
////        return fillColorAnimation;
////    }
////    else
////        return [super actionForKey:event];
////}
//
//@end

@interface MyShapeView ()
{
    CAShapeLayer* shapeLayer;
    CGRect lastLayoutFrame;
}
@end

@implementation MyShapeView

+(UIImage*)imageFromShapeDesc:(NSArray*)desc andShapeTintColor:(UIColor*)shapeTintColor andSize:(CGSize)size
{
    MyShapeView* shapeView = [[MyShapeView alloc] initWithShapeDesc:desc andShapeTintColor:shapeTintColor];
    shapeView.frame = CGRectMake(0, 0, size.width, size.height);
    [shapeView layoutIfNeeded];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [shapeView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


-(instancetype)initWithShapeDesc:(NSArray*)desc andShapeTintColor:(UIColor*)shapeTintColor
{
    self = [super init];
    if (self)
    {
        _shapeDesc = desc;
        _shapeTintColor = shapeTintColor;
        [self initialize];
        //        [self setNeedsLayout];
    }
    return self;
}

-(CAShapeLayer *)shapeLayer
{
    return shapeLayer;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

-(void)initialize
{
    shapeLayer = [CAShapeLayer new];
    shapeLayer.fillColor = _shapeTintColor ? _shapeTintColor.CGColor : [UIColor whiteColor].CGColor;
    self.userInteractionEnabled = NO;
    [self.layer addSublayer:shapeLayer];
}

-(void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    shapeLayer.shadowColor = shadowColor.CGColor;
}

-(void)setShadowOpacity:(float)shadowOpacity
{
    _shadowOpacity = shadowOpacity;
    shapeLayer.shadowOpacity= shadowOpacity;
}

-(void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowOffset = shadowOffset;
    shapeLayer.shadowOffset = shadowOffset;
}

-(void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowRadius = shadowRadius;
    shapeLayer.shadowRadius = shadowRadius;
}

-(void)setShapeTintColor:(UIColor *)shapeTintColor
{
    _shapeTintColor = shapeTintColor;
    shapeLayer.fillColor = _shapeTintColor ? _shapeTintColor.CGColor : [UIColor whiteColor].CGColor;
    //    [self setNeedsLayout];
}

-(void)setShapeDesc:(NSArray *)shapeDesc
{
    _shapeDesc = shapeDesc;
    [self setNeedsLayout];
}

-(void)setPath:(UIBezierPath *)path
{
    _path = path;
    _shapeDesc = nil;
    shapeLayer.path = path.CGPath;
}

-(CGFloat)borderWidth
{
    return shapeLayer.lineWidth;
}

-(UIColor *)borderColor
{
    return [UIColor colorWithCGColor:shapeLayer.strokeColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    shapeLayer.lineWidth = borderWidth;
    //        [self setNeedsLayout];
}

-(void)setBorderColor:(UIColor *)borderColor
{
    shapeLayer.strokeColor = borderColor.CGColor;
    //        [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //    if (!CGRectEqualToRect(<#CGRect rect1#>, <#CGRect rect2#>)
    
    if (_shapeDesc)
    {
        if (_maintainAspectRatio)
        {
            if ([_shapeDesc[0] isKindOfClass:[NSDictionary class]] && _dic_safe_field(_shapeDesc[0][@"conf"], @"size"))
            {
                NSLayoutConstraint* possibleCon = [self sdc_get_aspectRatio];
                CGFloat r = [_shapeDesc[0][@"conf"][@"size"][1] floatValue] / [_shapeDesc[0][@"conf"][@"size"][0] floatValue];
                
                if (possibleCon.multiplier != r)
                {
                    if (possibleCon)
                    possibleCon.active = NO;
                    
                    [self sdc_pinHeightWidthRatio:r constant:0];
                    
                    [self setNeedsLayout];
                    //                    [self getneare
                    return;
                }
            }
            else
            {
                NSLayoutConstraint* possibleCon = [self sdc_get_aspectRatio];
                if (possibleCon.multiplier != 1)
                {
                    if (possibleCon)
                    possibleCon.active = NO;
                    [self sdc_pinHeightWidthRatio:1 constant:0];
                    [self setNeedsLayout];
                    //                    [self.superview layoutIfNeeded];
                    return;
                }
            }
            
        }
        
        if (_num_ok1(_rotation))
        shapeLayer.path = [helper bezierCGPath:[helper bezierPathWithDescArray:_shapeDesc andRenderSize:self.frame.size closePath:YES].CGPath rotatedByDegrees:[_rotation floatValue]];
        else
        shapeLayer.path = [helper bezierPathWithDescArray:_shapeDesc andRenderSize:self.frame.size closePath:YES].CGPath;
    }
}

@end

