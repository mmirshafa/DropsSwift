//
//  MyLocationPickerSubmitButton.m
//  Kababchi
//
//  Created by hAmidReza on 7/20/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "MyLocationPickerSubmitButton.h"
#import "UIView+SDCAutoLayout.h"
#import "helper.h"
#import "Codebase_definitions.h"

@interface MyLocationPickerSubmitButton ()

@property (retain, nonatomic) UIView* innerContent;
@property (retain, nonatomic) UILabel* theTitleLabel;

@end

@implementation MyLocationPickerSubmitButton

-(void)initialize
{
	[super initialize];
	
	//	_innerContent = [UIView new];
	//	_innerContent.translatesAutoresizingMaskIntoConstraints = NO;
	//	[self addSubview:_innerContent];
	//	_innerContent sdc_alignedge
	
	_theTitleLabel = [UILabel new];
	_theTitleLabel.text = _str(@"Set Location");
	//	_theTitleLabel.font = [UIFont fontWithName:@"IRANSansMobile" size:16];
	_theTitleLabel.textColor = [UIColor whiteColor];
	_theTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:_theTitleLabel];
	[_theTitleLabel sdc_horizontallyCenterInSuperview];
	[_theTitleLabel sdc_verticallyCenterInSuperviewWithOffset:0];
	
	_theBackgroundColor = [UIColor blueColor];
	self.layer.cornerRadius = 10;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOffset = CGSizeMake(0, 0);
	self.layer.shadowOpacity = .4;
	self.layer.shadowRadius = 4;
}

-(void)setTheBackgroundColor:(UIColor *)theBackgroundColor
{
	_theBackgroundColor = theBackgroundColor;
	self.backgroundColor = _theBackgroundColor;
}

-(void)setTitleFont:(UIFont *)titleFont
{
	_titleFont = titleFont;
	_theTitleLabel.font = titleFont;
}

-(void)setTitleTextColor:(UIColor *)titleTextColor
{
	_titleTextColor = titleTextColor;
	_theTitleLabel.textColor = titleTextColor;
}

-(void)setTitleText:(NSString *)titleText
{
	_titleText = titleText;
	_theTitleLabel.text = titleText;
}

@end
