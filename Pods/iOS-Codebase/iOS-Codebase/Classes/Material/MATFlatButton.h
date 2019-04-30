//
//  MATFlatButton.h
//  mactehrannew
//
//  Created by hAmidReza on 8/13/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_MATControlBase.h"

@interface MATFlatButton : _MATControlBase

/**
 button click callback
 */
@property (nonatomic, copy, nonnull) void (^click)(MATFlatButton* _Nonnull button);

/**
 the title for the title label.
 */
@property (retain, nonatomic) NSString* _Nullable title;


/**
 sets the primary color. will be used for background color. default: rgba(48, 125, 252, 1.000)
 */
@property (retain, nonatomic) UIColor* _Nullable primaryColor UI_APPEARANCE_SELECTOR;


/**
 the color for the title. default: white
 */
@property (retain, nonatomic) UIColor* _Nullable titleColor UI_APPEARANCE_SELECTOR;


/**
 default: 6.0f;
 */
@property (assign, nonatomic) CGFloat innerContentSideMargins UI_APPEARANCE_SELECTOR;

/**
 default: 6.0f;
 */
@property (assign, nonatomic) CGFloat innerContentTopPadding UI_APPEARANCE_SELECTOR;

/**
 default: 6.0f;
 */
@property (assign, nonatomic) CGFloat innerContentBottomPadding UI_APPEARANCE_SELECTOR;



/**
 font for the title label. default: NaN.
 */
@property (retain, nonatomic) UIFont* _Nullable titleFont UI_APPEARANCE_SELECTOR;


/**
 determines the highlighted state of the button.
 */
@property (assign, nonatomic, readonly) BOOL isHighlighted;


/**
 default: .8
 */
@property (assign, nonatomic) float animationDuration UI_APPEARANCE_SELECTOR;

/**
 default: 2.0f
 */
@property (assign, nonatomic) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;






/**
 default: c_opaqueWhite(.26)
 */
@property (retain, nonatomic) UIColor* _Nullable shadowNormalColor UI_APPEARANCE_SELECTOR;

/**
 default: CGSizeMake(0, 2)
 */
@property (assign, nonatomic) CGSize shadowNormalOffset UI_APPEARANCE_SELECTOR;

/**
 default: 2.0f
 */
@property (assign, nonatomic) CGFloat shadowNormalRadius UI_APPEARANCE_SELECTOR;



/**
 default: c_opaqueWhite(.26)
 */
@property (retain, nonatomic) UIColor* _Nullable shadowPressedColor UI_APPEARANCE_SELECTOR;

/**
 default: CGSizeMake(0, 2)
 */
@property (assign, nonatomic) CGSize shadowPressedOffset UI_APPEARANCE_SELECTOR;

/**
 default: 2.0f
 */
@property (assign, nonatomic) CGFloat shadowPressedRadius UI_APPEARANCE_SELECTOR;

@end