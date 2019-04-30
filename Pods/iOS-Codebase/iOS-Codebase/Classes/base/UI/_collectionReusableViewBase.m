//
//  _collectionReusableViewBase.m
//  mactehrannew
//
//  Created by hAmidReza on 6/7/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_collectionReusableViewBase.h"
#import "NSObject+DataObject.h"

@interface _collectionReusableViewBase ()
{
	BOOL initialized;
	BOOL initialLayoutDone;
}

@end

@implementation _collectionReusableViewBase

-(instancetype)init
{
	self = [super init];
	if (self)
		[self _initialize];
	return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
		[self _initialize];
	return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
		[self _initialize];
	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	if (!initialLayoutDone && self.frame.size.width > 0 && self.frame.size.height > 0)
	{
		[self initial_layout];
		initialLayoutDone = YES;
	}
}

-(void)initial_layout
{
	
}

-(void)_initialize
{
	if (!initialized)
	{
		[self initialize];
		initialized = YES;
	}
}

-(void)initialize
{
	
}

-(void)configureWithDictionary:(NSMutableDictionary *)dic
{
	
}

+(NSString *)reuseIdentifier
{
    NSString* reuseIdentifier = [self dataObjectForKey:@"reuseIdentifier"];
    if (!reuseIdentifier)
    {
        reuseIdentifier = NSStringFromClass([self class]);
        [self setDataObject:reuseIdentifier forKey:@"reuseIdentifier"];
    }
    return reuseIdentifier;
}

@end
