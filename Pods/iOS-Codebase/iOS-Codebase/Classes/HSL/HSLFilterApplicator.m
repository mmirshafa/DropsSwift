//
//  FilterApplicator.m
//  macTehran
//
//  Created by Hamidreza Vaklian on 1/20/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import "HSLFilterApplicator.h"
#import "UIColor+Extensions.h"

@implementation HSLFilterApplicator


+(HSLColorizeFilter*)filter
{
	static HSLColorizeFilter* theFilter;
	
	if (!theFilter)
	{
		theFilter = [HSLColorizeFilter new];
	}
	

	return theFilter;
}



+(NSLock*)getLock
{
	static NSLock* filterLock;
	if (!filterLock)
		filterLock = [NSLock new];
	
	return filterLock;
}

+(void)lockFilter
{
	[[HSLFilterApplicator getLock] lock];
}

+(void)unlockFilter
{
	[[HSLFilterApplicator getLock] unlock];
}

+(CIContext*)context
{
	static CIContext* coreImageContext;
	if (!coreImageContext)
	{
		CGColorSpaceRef cSpace = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
		NSDictionary *dic = @{kCIContextWorkingColorSpace : CFBridgingRelease(cSpace)};
		coreImageContext = [CIContext contextWithOptions:dic];
	}
	
	return coreImageContext;
}

+(void)HSLFilterImage:(UIImage*)image fromColor:(UIColor*)source_color toColor:(UIColor*)destination_color callback:(void (^)(UIImage* filteredImage))completionHandler
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		UIImage* finalImage = [HSLFilterApplicator HSLFilterImage:image fromColor:source_color toColor:destination_color];
		
		if (finalImage)
			completionHandler(finalImage);
	});
}

+(UIImage*)HSLFilterImage:(UIImage*)image fromColor:(UIColor*)source_color toColor:(UIColor*)destination_color
{
	if (!image)
		NSLog(@"HSLFilterImage image null");
	
	rgb src = [source_color get_rgb];
	rgb dst = [destination_color get_rgb];
	
	[HSLFilterApplicator lockFilter];
	
	HSLColorizeFilter* theFilter = [HSLFilterApplicator filter];
	[theFilter setValue:[[CIImage alloc] initWithImage:image] forKey:kCIInputImageKey];
	
	hsl h = calculateTransform(src, dst);
	
	NSLog(@"src: %.0f, %.0f, %.0f --> hsl:(%.0f, %.0f, %.0f) --> dst: %.0f, %.0f, %.0f", src.r*255, src.g*255, src.b*255, h.h*360, h.s*100, h.l*100, dst.r*255, dst.g*255, dst.b*255);
	
	theFilter.hue = h.h;
	theFilter.saturation = h.s;
	theFilter.lightness = h.l;
	
	CIImage *displayImage = theFilter.outputImage;
	
	CGImageRef img = [[HSLFilterApplicator context] createCGImage:displayImage fromRect:displayImage.extent];
	UIImage* finalImage =  [UIImage imageWithCGImage:img];
	
	CGImageRelease(img);
	
	[HSLFilterApplicator unlockFilter];
	
	return finalImage;
}

@end
