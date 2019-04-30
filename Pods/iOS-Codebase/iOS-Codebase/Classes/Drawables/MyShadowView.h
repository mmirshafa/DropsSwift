//
//  MyShadowView.h
//  mactehrannew
//
//  Created by hAmidReza on 7/26/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_viewBase.h"

@interface MyShadowView : _viewBase


/**
 default: blackColor
 */
@property (retain, nonatomic) UIColor* shadowColor;


/**
 default 4.0f
 */
@property (assign, nonatomic) CGFloat shadowRadius;

/**
 default 4.0f
 */
@property (assign, nonatomic) CGFloat cornerRadius;


/**
 default: CGSizeZero
 */
@property (assign, nonatomic) CGSize shadowOffset;


/**
 default .5
 */
@property (assign, nonatomic) CGFloat shadowOpacity;

@end
