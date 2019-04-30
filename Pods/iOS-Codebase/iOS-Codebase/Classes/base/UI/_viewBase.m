//
//  _viewBase.m
//  mactehrannew
//
//  Created by hAmidReza on 5/1/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_viewBase.h"

@implementation _viewBase


-(instancetype)_init
{
	return [super init];
}

-(instancetype)init
{
	self = [super init];
	if (self)
		[self initialize];
	return self;
}

-(void)initialize
{
	
}

-(void)configureWithDictionary:(NSMutableDictionary *)dic
{
	NSAssert(false, @"_viewBase: overrride: configureWithDictionary");
}

@end
