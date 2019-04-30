//
//  MyShapeButton.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 7/5/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "MyShapeButton.h"
#import "MyShapeView.h"
#import "MyShapeButtonLayer.h"

@interface MyShapeButton () <MyShapeButtonLayerDelegate>
{
    BOOL initialized;
    UIColor* backColor;
}
@end

@implementation MyShapeButton

-(void)MyShapeButtonLayerSetCornerRadius:(CGFloat)cornerRadius
{
    _shapeView.layer.cornerRadius = cornerRadius;
}

-(void)setHighlighted:(BOOL)highlighted
{
    if (!_highlightColor)
    {
        [super setHighlighted:highlighted];
        return;
    }
    
    if (!backColor)
    backColor = self.backgroundColor;
    
    
    if (highlighted)
    self.backgroundColor = [UIColor whiteColor];
    else
    self.backgroundColor = backColor;
}

-(void)setShapeMargins:(UIEdgeInsets)shapeMargins
{
    _shapeMargins = shapeMargins;
    [self setNeedsLayout];
}

-(BOOL)MyShapeButtonLayerShouldOverrideSetCornerRadius
{
    return _setsCornerRadiusForShapeView;
}

-(instancetype)initWithShapeDesc:(NSArray*)desc andShapeTintColor:(UIColor*)shapeTintColor andButtonClick:(void (^)(void))buttonClick
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        //        _setCornerRadiusWithRespectToShapeMargins = YES;
        
        //        self.backgroundColor = [UIColor redColor];
        
        _setsBackgroundColorForShapeView = true;
        
        _shapeView = [[MyShapeView alloc] initWithShapeDesc:desc andShapeTintColor:shapeTintColor];
        [self addSubview:_shapeView];
        _shapeView.userInteractionEnabled = NO;
        _setsCornerRadiusForShapeView = YES;
        
        _shapeMargins = UIEdgeInsetsZero;
        //        _shapeView.userInteractionEnabled = YES;
        _shapeView.layer.shouldRasterize = YES;
        _shapeView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _buttonClick = buttonClick;
        
        //        UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouch:)];
        //        [self addGestureRecognizer:tapGest];
        [self addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        //        [self initialize];
    }
    return self;
}

-(void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (_setsBackgroundColorForShapeView)
    _shapeView.backgroundColor = backgroundColor;
    else
    [super setBackgroundColor:backgroundColor];
}

+(Class)layerClass
{
    return [MyShapeButtonLayer class];
}

-(CALayer *)layer
{
    MyShapeButtonLayer* layer = (MyShapeButtonLayer*)[super layer];
    layer.buttonDelegate = self;
    return layer;
}

//-(instancetype)init
//{
//    self = [super init];
//    if (self)
//    {
//        [self initialize];
//    }
//    return self;
//}
//
//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        [self initialize];
//    }
//    return self;
//}

-(void)setShapeView:(MyShapeView *)shapeView
{
    [_shapeView removeFromSuperview];
    _shapeView = shapeView;
    [self addSubview:_shapeView];
}


//-(void)initialize
//{
//    if (!initialized)
//    {
//        [self addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
//        initialized = YES;
//    }
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _shapeView.frame = UIEdgeInsetsInsetRect(self.bounds, _shapeMargins);
}

//-(void)setHighlighted:(BOOL)highlighted
//{
//    [super setHighlighted:highlighted];
//
//    [UIView animateWithDuration:.15 animations:^{
//        self.alpha = highlighted ? .6 : 1.0;
//    }];
//}

-(void)buttonTouch:(id)sender
{
    if (_buttonClick)
    _buttonClick();
}

-(void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    _shapeView.shadowColor = shadowColor;
}

-(void)setShadowOpacity:(float)shadowOpacity
{
    _shadowOpacity = shadowOpacity;
    _shapeView.shadowOpacity= shadowOpacity;
}

-(void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowOffset = shadowOffset;
    _shapeView.shadowOffset = shadowOffset;
}

-(void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowRadius = shadowRadius;
    _shapeView.shadowRadius = shadowRadius;
}
-(void)setShapeBorderColor:(UIColor *)shapeBorderColor
{
    _shapeBorderColor = shapeBorderColor;
    self.shapeView.borderColor = shapeBorderColor;
}

-(void)setShapeBorderWidth:(CGFloat)shapeBorderWidth
{
    _shapeBorderWidth = shapeBorderWidth;
    self.shapeView.borderWidth = shapeBorderWidth;
}

@end
