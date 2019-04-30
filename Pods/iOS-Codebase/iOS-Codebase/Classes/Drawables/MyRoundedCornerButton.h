//
//  DFRoundedCornerButton.h
//  deepfinity
//
//  Created by Hamidreza Vakilian on 10/15/1396 AP.
//  Copyright © 1396 nizek. All rights reserved.
//

#import "_UIControlBase2.h"
#import "Codebase_definitions.h"

@interface MyRoundedCornerButton : _UIControlBase2

@property (retain, nonatomic) NSString* title;
@property (retain, nonatomic) NSDictionary* iconVectorDesc;
@property (retain, nonatomic) NSArray* iconShapeDesc;

@property (retain, nonatomic) UIFont* font UI_APPEARANCE_SELECTOR;



/**
 default true
 */
@property (assign, nonatomic) BOOL fullRoundCorner UI_APPEARANCE_SELECTOR;


/**
 default: 0
 */
@property (assign, nonatomic) CGFloat roundCorner UI_APPEARANCE_SELECTOR;

_simple_property_block(tapCallback);
/**
 default: darkgraycolor
 */
@property (retain, nonatomic) UIColor* textColor;

-(void)setIconShapeDesc:(NSArray *)iconShapeDesc tintColor:(UIColor*)color;

@end
