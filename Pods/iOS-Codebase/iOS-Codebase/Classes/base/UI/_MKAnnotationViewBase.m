//
//  _MKAnnotationViewBase.m
//  Kababchi
//
//  Created by hAmidReza on 6/14/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "_MKAnnotationViewBase.h"

@implementation _MKAnnotationViewBase

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self)
	{
		[self initialize];
	}
	return self;
}

-(void)initialize
{
	
}

+(NSString *)reuseIdentifier
{
	static NSString* reuseIdentifier;
	if (!reuseIdentifier)
	{
		reuseIdentifier = NSStringFromClass([self class]);
	}
	return reuseIdentifier;
}

@end
