//
//  _tableViewCellBase2.h
//  oncost
//
//  Created by Hamidreza Vakilian on 3/6/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "_tableViewCellBase.h"

@interface _tableViewCellBase2 : _tableViewCellBase

@property (retain, nonatomic, readonly) UIView* theContentView;

-(void)selfTap:(id)sender;

@property (nonatomic) UIView* contentView NS_UNAVAILABLE;


@property (retain, nonatomic) UIColor* highlightedBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 default true
 */
@property (assign, nonatomic) BOOL touchEnabled;

@end
