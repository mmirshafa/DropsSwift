//
//  MyTableViewPickerCell.h
//  oncost
//
//  Created by Hamidreza Vakilian on 3/22/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "_tableViewCellBase2.h"

@protocol MyTableViewPickerCompatibleCellDelegate;

@interface MyTableViewPickerCell : _tableViewCellBase2 <UIAppearance>

@property (weak, nonatomic) id<MyTableViewPickerCompatibleCellDelegate> delegate;

/**
 default NaN
 */
@property (retain, nonatomic) UIFont* titleFont UI_APPEARANCE_SELECTOR;

@property (retain, nonatomic) UIColor* titleColor UI_APPEARANCE_SELECTOR;

@end
