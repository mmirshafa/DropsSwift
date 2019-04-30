//
//  _FormBaseVC.h
//  mactehrannew
//
//  Created by hAmidReza on 8/2/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_HomeBaseVC.h"

@class MyShapeButton, _loadingEnabledView;

@interface _FormBaseVC : _HomeBaseVC

@property (retain, nonatomic) MyShapeButton* backButton;
//@property (retain, nonatomic) NSArray* iconShapeDesc;
@property (retain, nonatomic) _loadingEnabledView* contents;
@property (retain, nonatomic) NSLayoutConstraint* contentsTopSpacingCon; //default 50
@property (retain, nonatomic) NSLayoutConstraint* yCenteredVerticalOffset; //default -80
@property (nonatomic) BOOL keyboardIsUp;

@property (retain, nonatomic) UIView* visualEffectViewOverlay;

//-(IntroNavC*)navC;
//-(void)presentWithCompletion:(void (^) ())completionHandler;
-(void)selfTap:(id)sender;


@end
