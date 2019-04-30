//
//  MyLinearGradientLayer.m
//  Pods
//
//  Created by hAmidReza on 7/18/17.
//
//

#import "MyLinearGradientLayer.h"

@implementation MyLinearGradientLayer

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.contentsScale = [UIScreen mainScreen].scale;
		[self setNeedsDisplay];
		//		self.opaque = NO;
	}
	return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
	NSAssert(_colors.count == _locations.count, @"MyLinearGradientLayer: colors and locations count must be equal");
	
	
	CGFloat gradColors[_colors.count * 4];
	int i = 0;
	for (id _color in _colors) {
		
		CGColorRef color = (__bridge CGColorRef)(_color);
		const CGFloat* comps = CGColorGetComponents(color);
		gradColors[i*4+0] = comps[0];
		gradColors[i*4+1] = comps[1];
		gradColors[i*4+2] = comps[2];
		gradColors[i*4+3] = comps[3];
		i++;
	}
	
	CGFloat gradLocations[_colors.count];
	i = 0;
	for (NSNumber* loc in _locations)
		gradLocations[i++] = [loc floatValue];
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, _colors.count);
	CGColorSpaceRelease(colorSpace);
	CGPoint actualStartPoint = CGPointMake(_startPoint.x * self.bounds.size.width, _startPoint.y * self.bounds.size.height);
	CGPoint actualEndPoint = CGPointMake(_endPoint.x * self.bounds.size.width, _endPoint.y * self.bounds.size.height);
	CGContextDrawLinearGradient(ctx, gradient, actualStartPoint, actualEndPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	//	CGContextSetBlendMode(ctx,kCGBlendModeMultiply);
	
	CGGradientRelease(gradient);
}

@end
