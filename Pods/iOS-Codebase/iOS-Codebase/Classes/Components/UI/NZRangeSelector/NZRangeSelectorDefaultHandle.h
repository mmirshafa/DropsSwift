//
//  NZRangeSelectorComatibleView.h
//  MyAthath
//
//  Created by Developer on 1/21/19.
//  Copyright © 2019 Nizek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZRangeSelector.h"

NS_ASSUME_NONNULL_BEGIN

@interface NZRangeSelectorDefaultHandle : UIView <NZRangeSelectorCompatibleViewDelegate>

@property (retain, nonatomic) UIView* decor1;
@property (retain, nonatomic) UIView* decor2;


/**
 default: black color
 */
@property (retain, nonatomic) UIColor* mainTintColor UI_APPEARANCE_SELECTOR;

/**
 default: system font 15
 */
@property (retain, nonatomic) UIFont* theFont UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
