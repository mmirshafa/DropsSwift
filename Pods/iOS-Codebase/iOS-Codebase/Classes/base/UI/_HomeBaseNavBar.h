//
//  _HomeBaseNavBar.h
//  Kababchi
//
//  Created by hAmidReza on 7/20/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShapeButton.h"
#import "NSObject+uniconf.h"

@interface _HomeBaseNavBar : UINavigationBar <uniconf>

@property (retain, nonatomic) MyShapeButton* leftButton;
@property (retain, nonatomic) MyShapeButton* rightButton;

@property (retain, nonatomic) NSDictionary* u_titleTextAttributes UI_APPEARANCE_SELECTOR;


/**
 if you set it to true it may render over the back button of the viewcontroller. use with caution.
 */
@property (assign, nonatomic) BOOL bringButtonsToFront;

@end
