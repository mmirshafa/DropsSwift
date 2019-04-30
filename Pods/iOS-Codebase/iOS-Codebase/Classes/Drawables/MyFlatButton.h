//
//  MyBoredredFlatButton.h
//  mactehrannew
//
//  Created by hAmidReza on 5/29/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_UIControlBase.h"

@interface MyFlatButton : _UIControlBase <UIAppearance>


@property (retain, nonatomic) NSNumber* disabled_alpha;

@property (copy, nonatomic) void (^buttonClick)();

/**
 title for the button default: NaN
 */
@property (retain, nonatomic) NSString* title;
/**
 default: 20.0f
 */
@property (assign, nonatomic) CGFloat titleSideMargins UI_APPEARANCE_SELECTOR;

/**
 default: NaN
 */
@property (retain, nonatomic) UIColor* textColor UI_APPEARANCE_SELECTOR;

/**
 default: NaN
 */
@property (retain, nonatomic) UIFont* font UI_APPEARANCE_SELECTOR;

/**
 default: 140, 140, 140, 1.0f
 */
@property (retain, nonatomic) UIColor* borderColor UI_APPEARANCE_SELECTOR;


/**
 default: 1.0f
 */
@property (assign, nonatomic) CGFloat borderWidth UI_APPEARANCE_SELECTOR;

/**
 default: 0
 */
@property (assign, nonatomic) CGFloat titleVerticalOffset UI_APPEARANCE_SELECTOR;


/**
 default: 3.0f
 */
@property (assign, nonatomic) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

-(void)setEnabled:(BOOL)enabled animated:(BOOL)animated;


-(UILabel *)titleLabel NS_UNAVAILABLE; //developer should not use titleLabel! it's for the UIBUTTON. Use the attributes instead.
@end
