//
//  MyRadialGradientLayer.m
//  Pods
//
//  Created by hAmidReza on 7/18/17.
//
//

#import "MyRadialGradientLayer.h"

@implementation MyRadialGradientLayer

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.contentsScale = [UIScreen mainScreen].scale;
		[self setNeedsDisplay];
	}
	return self;
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self setNeedsDisplay];
}

-(void)setRadius:(CGFloat)radius
{
	_radius = radius;
	[self setNeedsDisplay];
}

-(void)setCenterPoint:(CGPoint)centerPoint
{
	_centerPoint = centerPoint;
	[self setNeedsDisplay];
}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
	[self setNeedsDisplay];
}

-(void)setLocations:(NSArray *)locations
{
	_locations = locations;
	[self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx
{
	NSAssert(_colors.count == _locations.count, @"MyRadialGradientLayer: colors and locations count must be equal");
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
	CGPoint actualCenter = CGPointMake(_centerPoint.x * self.bounds.size.width, _centerPoint.y * self.bounds.size.height);
	CGContextDrawRadialGradient (ctx, gradient, actualCenter, 0, actualCenter, _radius, kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
}

@end
