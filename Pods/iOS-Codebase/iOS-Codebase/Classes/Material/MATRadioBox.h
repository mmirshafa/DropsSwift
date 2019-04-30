//
//  MATRadioBox.h
//  mactehrannew
//
//  Created by hAmidReza on 8/9/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_MATControlBase.h"

@interface MATRadioBox : _MATControlBase

/**
 default: .8
 */
@property (assign, nonatomic) float animationDuration UI_APPEARANCE_SELECTOR;


/**
  selected state with animation

 @param on true or false
 @param animated if you want it animated
 */
-(void)setOn:(BOOL)on animated:(BOOL)animated;
/**
 selected state, default false;
 */
@property (assign, nonatomic) BOOL on;

/**
 sets the primary color. will be used for background color. default: rgba(48, 125, 252, 1.000)
 */
@property (retain, nonatomic) UIColor* primaryColor UI_APPEARANCE_SELECTOR;

/**
 sets the primary color. will be used for background color. default: grayColor
 */
@property (retain, nonatomic) UIColor* inactiveColor UI_APPEARANCE_SELECTOR;

/**
 if on the impression circle will have the primaryColor but with this alpha. also applies when on==false and it will use inactiveColor with comibination of this value as the alpha.
 default: .2
 */
@property (assign, nonatomic) CGFloat impressionCircleAlphaBlendingValue UI_APPEARANCE_SELECTOR;

/**
	default: 1.08
 */
@property (assign, nonatomic) CGFloat bounceRatio;

/**
	default: .5
 */
@property (assign, nonatomic) float bounceDuration;


/**
 pass the array of all radioBoxes including this instance to this property. So when it's state is changed to on, it will turn off other radio boxes. default: nil
 */
@property (retain, nonatomic) NSArray* radioBoxesGroup;


@end
