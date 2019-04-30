//
//  MyVectorButton.m
//  mactehrannew
//
//  Created by hAmidReza on 8/30/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "MyVectorButton.h"
#import "MyShapeButtonLayer.h"
#import "MyVector.h"

@interface MyVectorButton () <MyShapeButtonLayerDelegate>
{
	BOOL initialized;
	UIColor* backColor;
}

@end

@implementation MyVectorButton

-(void)MyShapeButtonLayerSetCornerRadius:(CGFloat)cornerRadius
{
	_vectorView.layer.cornerRadius = cornerRadius;
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
	return _setsCornerRadiusForVectorView;
}

-(instancetype)initWithVector:(NSDictionary *)vector andButtonClick:(void (^)(void))buttonClick
{
	self = [super init];
	if (self)
	{
		//		_setCornerRadiusWithRespectToShapeMargins = YES;
		
		//		self.backgroundColor = [UIColor redColor];
		
		_vectorView = [[MyVector alloc] initWithVector:vector];
		[self addSubview:_vectorView];
		_vectorView.userInteractionEnabled = NO;
		_setsCornerRadiusForVectorView = YES;
		
		_shapeMargins = UIEdgeInsetsZero;
		//		_shapeView.userInteractionEnabled = YES;
		_vectorView.layer.shouldRasterize = YES;
		_vectorView.layer.rasterizationScale = [UIScreen mainScreen].scale;
		_buttonClick = buttonClick;
		
		//		UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouch:)];
		//		[self addGestureRecognizer:tapGest];
//		[self addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
		
		//        [self initialize];
	}
	return self;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
	_vectorView.backgroundColor = backgroundColor;
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

-(void)setVectorView:(MyVector *)vectorView
{
	[_vectorView removeFromSuperview];
	_vectorView = vectorView;
	[self addSubview:_vectorView];
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
	_vectorView.frame = UIEdgeInsetsInsetRect(self.bounds, _shapeMargins);
}

//-(void)setHighlighted:(BOOL)highlighted
//{
//	[super setHighlighted:highlighted];
//
//    [UIView animateWithDuration:.15 animations:^{
//        self.alpha = highlighted ? .6 : 1.0;
//    }];
//}



-(void)unhighlightSuccessful:(id)sender event:(UIEvent *)event
{
//	[super unhighlightSuccessful:sender event:event];
	
	if (_buttonClick)
		_buttonClick();
}


-(void)setShadowColor:(UIColor *)shadowColor
{
	_shadowColor = shadowColor;
	_vectorView.layer.shadowColor = shadowColor.CGColor;
}

-(void)setShadowOpacity:(float)shadowOpacity
{
	_shadowOpacity = shadowOpacity;
	_vectorView.layer.shadowOpacity= shadowOpacity;
}

-(void)setShadowOffset:(CGSize)shadowOffset
{
	_shadowOffset = shadowOffset;
	_vectorView.layer.shadowOffset = shadowOffset;
}

-(void)setShadowRadius:(CGFloat)shadowRadius
{
	_shadowRadius = shadowRadius;
	_vectorView.layer.shadowRadius = shadowRadius;
}


@end
