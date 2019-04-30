//
//  ShadowedBlockView.h
//  mactehrannew
//
//  Created by hAmidReza on 6/29/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_viewBase.h"
@interface ShadowedBlockView : _viewBase

@property (retain, nonatomic) UIView* contentView;


/**
 default: 3.0
 */
@property (assign, nonatomic) CGFloat cornerRadius;


/**
 default CGSizeMake(3, 3)
 */
@property (assign, nonatomic) CGSize shadowOffset;


/**
 default .1
 */
@property (assign, nonatomic) CGFloat shadowOpacity;


/**
 default 4.0
 */
@property (assign, nonatomic) CGFloat shadowRadius;

/**
 default UIEdgeInsetsMake(10, 20, 10, 20)
 */
@property (assign, nonatomic) UIEdgeInsets contentViewMargins;


/**
 default 0.0f
 */
@property (assign, nonatomic) CGFloat borderWidth;


/**
 default nil;
 */
@property (readonly, nonatomic) UIColor* borderColor;

@end
