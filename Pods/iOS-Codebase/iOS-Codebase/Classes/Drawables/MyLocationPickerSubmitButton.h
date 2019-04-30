//
//  MyLocationPickerSubmitButton.h
//  Kababchi
//
//  Created by hAmidReza on 7/20/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "_UIControlBase.h"

@interface MyLocationPickerSubmitButton : _UIControlBase


/**
 background color for the button
 */
@property (retain, nonatomic) UIColor* theBackgroundColor UI_APPEARANCE_SELECTOR;


/**
 font for the title label
 */
@property (retain, nonatomic) UIFont* titleFont UI_APPEARANCE_SELECTOR;

/**
	text color for the label
 */
@property (retain, nonatomic) UIColor* titleTextColor UI_APPEARANCE_SELECTOR;

/**
	text for the title label. default: _str(@"Set Location")
 */
@property (retain, nonatomic) NSString* titleText UI_APPEARANCE_SELECTOR;


@end
