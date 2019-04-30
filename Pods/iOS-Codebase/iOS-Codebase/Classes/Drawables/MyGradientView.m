//
//  MyGradientView.m
//  mactehrannew
//
//  Created by hAmidReza on 5/3/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "MyGradientView.h"
#import "UIView+SDCAutoLayout.h"

@interface MyGradientView ()
{
	bool initialized;
}

@end

@implementation MyGradientView

-(instancetype)init
{
	self = [super init];
	if (self)
	{
		[self initialize];
	}
	
	return self;
}

-(void)initialize
{
	//	// Create a gradient layer
	//	_theLayer = [CAGradientLayer layer];
	//	// gradient from transparent to black
	//	_theLayer.colors = @[(id)RGBAColor(0, 0, 0, .05).CGColor ,(id)RGBAColor(0, 0, 0, .05).CGColor, (id)RGBAColor(0, 0, 0, .6).CGColor];
	//	_theLayer.locations = @[@0, @.8, @1];
	//	// set frame to whatever values you like (not hard coded like here of course)
	////	layer.frame = CGRectMake(0.0f, 0.0f, 320.0f, 200.0);
	//	// add the gradient layer as a sublayer of you image view
	//	[self.layer addSublayer:_theLayer];
	
	
	//	UIImage *stretchableImage = [[UIImage imageNamed:@"1.png"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	
	//	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1.png"]];
	
	if (!initialized)
	{
		_theGradientImageView = [UIImageView new];
		UIImage* img = [UIImage imageNamed:@"1.png"];
		UIImage* img2 = [img stretchableImageWithLeftCapWidth:0 topCapHeight:0];
		_theGradientImageView.image = img2;
		_theGradientImageView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_theGradientImageView];
		//
		[_theGradientImageView sdc_alignEdgesWithSuperview:UIRectEdgeAll insets:UIEdgeInsetsMake(0, 0, 0, 0)];
		initialized = YES;
	}
	
}

//+(CGFloat*)locationNSArrayToCGArray:(NSArray*)arr
//{
//	CGFloat* result = malloc(arr.count * sizeof(CGFloat));
//	int i = 0;
//	for (NSNumber* location in arr)
//	{
//		result[i] = [location floatValue];
//		i++;
//	}
//	return result;
//}

-(void)layoutSubviews
{
	[super layoutSubviews];
	
	//	_theLayer.frame = self.bounds;
}

@end
