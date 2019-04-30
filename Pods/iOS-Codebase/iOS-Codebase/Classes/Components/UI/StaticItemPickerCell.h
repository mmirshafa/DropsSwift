//
//  StaticItemPickerCell.h
//  mactehrannew
//
//  Created by Hamidreza Vakilian on 8/3/1396 AP.
//  Copyright © 1396 archibits. All rights reserved.
//

#import "_tableViewCellBase.h"
#import "NSObject+uniconf.h"

@interface StaticItemPickerCell : _tableViewCellBase <uniconf>

-(void)setChosenAnimated:(BOOL)chosen;


/**
 defaults to [UIFont fontWithName:@"Helvetica-Neue" size:14]
 */
@property (retain, nonatomic) UIFont* u_titleLabelFont;

@property (retain, nonatomic) UIColor* u_chooseButtonBorderColor2;

@property (retain, nonatomic) UIColor* u_chooseButtonBackgroundColor2;

@property (retain, nonatomic) NSArray* u_chooseButtonIcon2;

@property (retain, nonatomic) UIColor* u_chooseButtonShapeTintColor;

@end
