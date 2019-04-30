//
//  MyLocationPickerIndicatorView.h
//  Kababchi
//
//  Created by hAmidReza on 7/20/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "_viewBase.h"

@interface MyLocationPickerIndicatorView : _viewBase

@property (retain, nonatomic) UIColor* locationPinTintColor UI_APPEARANCE_SELECTOR;

-(void)lift;
-(void)drop;

@end
