//
//  _myModalDialog.h
//  Kababchi
//
//  Created by hAmidReza on 6/9/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShadowView.h"

@class _loadingEnabledView;

@interface _myModalDialog : UIViewController

@property (retain, nonatomic) NSLayoutConstraint* contentsTopSpacingCon; //default 50
@property (retain, nonatomic) NSLayoutConstraint* yCenteredVerticalOffset; //default -80
@property (retain, nonatomic) UIVisualEffectView* visualEffectView;
@property (retain, nonatomic) UIView* dimView;
@property (retain, nonatomic) _loadingEnabledView* contentView;
@property (retain, nonatomic) MyShadowView* myShadowView;

@property (retain, nonatomic) UIView* scrollViewYCentered;

@property (assign, nonatomic) BOOL transition_NoBackZoom; //default NO

@property (nonatomic) BOOL keyboardIsUp;

@property (weak, nonatomic) UIView* importantView;


@property (assign, nonatomic) CGFloat contentViewCornerRadius;

-(void)initialize;
-(CGFloat)contentView2DeviceWidthOffset;
-(CGFloat)dialogMaxWidth;

@end
