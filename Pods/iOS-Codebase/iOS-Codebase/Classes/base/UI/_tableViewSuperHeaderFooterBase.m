//
//  _tableViewSuperHeaderFooterBase.m
//  FieldBooker
//
//  Created by hAmidReza on 5/13/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "_tableViewSuperHeaderFooterBase.h"
#import "UIView+SDCAutoLayout.h"

@interface _tableViewSuperHeaderFooterBase ()
{
	bool initialized;
	bool layoutDone;
	bool internal_layout_done;
}

@end

@implementation _tableViewSuperHeaderFooterBase

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

-(void)_initialize
{
	if (!initialized)
	{
		_contentView = [UIView new];
		_contentView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_contentView];
		[self initialize];
		initialized = YES;
	}
}

-(void)initialize
{
	
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	
	if (self.frame.size.width > 0 && !layoutDone)
	{
		[self _configAutoLayout];
		layoutDone = YES;
		[self layoutIfNeeded];
		if (_onDidInitialLayout)
			_onDidInitialLayout(self);
	}
	
	if (_onDidLayout)
		_onDidLayout(self);
}

-(void)_configAutoLayout
{
	if (!internal_layout_done)
	{
		[_contentView sdc_alignEdgesWithSuperview:UIRectEdgeAll ^ UIRectEdgeBottom];
		internal_layout_done = YES;
	}
	[self configAutoLayout];
}

-(void)configAutoLayout
{
	
}

-(void)configureWithDesc:(NSMutableDictionary *)dic
{
}

@end
