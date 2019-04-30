//
//  _tableViewHeaderFooterBase.m
//  FieldBooker
//
//  Created by hAmidReza on 5/12/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "_tableViewHeaderFooterBase.h"
#import "NSObject+DataObject.h"

@interface _tableViewHeaderFooterBase ()
{
	BOOL initialized;
}

@end

@implementation _tableViewHeaderFooterBase

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithReuseIdentifier:reuseIdentifier];
	if (self)
	{
		[self _initialize];
	}
	return self;
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

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.backgroundColor = [UIColor clearColor];
}

@end
