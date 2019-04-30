//
//  YesNoConfirmationDialog.h
//  Kababchi
//
//  Created by hAmidReza on 7/8/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "_MTDialog.h"
#import "NSObject+uniconf.h"

@class MyVector;

@interface YesNoConfirmationDialog : _MTDialog <uniconf>

@property (copy, nonatomic) void (^callback)();

@property (copy, nonatomic) void (^cancelCallback)();

@property (retain, nonatomic) MyVector* vector;

@property (retain, nonatomic) UIView* customHeader;

@property (retain, nonatomic) UIFont* u_titleFont;
@property (retain, nonatomic) UIFont* u_msgFont;

@property (retain, nonatomic) UIFont* u_buttonFonts;


/**
 default: true,
 if false, when user touches submit or cancel, it won't be dismissed by itself
 */
@property (assign, nonatomic) BOOL autoDismissDialog;

@property (retain, nonatomic) UIColor* u_submitButtonTextColor;

-(void)configureWithTitle:(NSString*)title message:(NSString*)msg submit:(NSString*)submit cancel:(NSString*)cancel;

@property (retain, nonatomic) NSDictionary* vector_desc;

/**
 default: UIStatusBarStyleLightContent
 
 */
@property (assign, nonatomic) UIStatusBarStyle u_statusBarStyle;

@end
