//
//  MyLocationPicker.h
//  Kababchi
//
//  Created by hAmidReza on 7/20/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "_HomeBaseVC.h"
#import "MyLocationPickerIndicatorView.h"
#import "MyLocationPickerSubmitButton.h"

@interface MyLocationPicker : _HomeBaseVC <UIAppearance, UIAppearanceContainer>

@property (retain, nonatomic) CLLocation* location;

@property (copy, nonatomic) void (^callback) (CLLocation* coordinate);



/**
 In case of not GPS it will load this location at first.
 */
@property (retain, nonatomic) CLLocation* defaultLocation UI_APPEARANCE_SELECTOR;



/**
 default zoom amount. defaults to: .03
 */
@property (assign, nonatomic) float spanDelta UI_APPEARANCE_SELECTOR;



/**
 default true,
 */
@property (assign, nonatomic) BOOL disableRotation UI_APPEARANCE_SELECTOR;


/**
 default true
 */
@property (assign, nonatomic) BOOL dismissVCAfterChooseLocation;


/**
 default: _statusBarHeight+44+20
 */
@property (assign, nonatomic) CGFloat locationButtonTopMargin;
@end
