//
//  NZRangeSelector.h
//  Gear-iOS
//
//  Created by Developer on 11/28/18.
//  Copyright © 2018 Nizek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NZRangeSelector;

typedef enum : NSUInteger {
    NZRangeSelectorEventBegan,
    NZRangeSelectorEventChanged,
    NZRangeSelectorEventEnded,
} NZRangeSelectorEvent;

typedef enum : NSUInteger {
    NZRangeSelectorHandleLeft,
    NZRangeSelectorHandleRight,
} NZRangeSelectorHandle;

NS_ASSUME_NONNULL_BEGIN
@protocol NZRangeSelectorCompatibleViewDelegate <NSObject>
-(void)NZRangeSelector:(NZRangeSelector*)instance event:(NZRangeSelectorEvent)event value:(float)value;
@optional
-(void)NZRangeSelector:(NZRangeSelector*)instance configureWithType:(NZRangeSelectorHandle)type;
@end

@interface NZRangeSelector : UIControl

-(instancetype)initWithLeftHandle:(Class)leftHandleClass andRightHandle:(Class)rightHandleClass;

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)new NS_UNAVAILABLE;
-(instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
-(instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;


@property (assign, nonatomic) float minValue;
@property (assign, nonatomic) float maxValue;

@property (assign, nonatomic) float leftValue;
@property (assign, nonatomic) float rightValue;

@property (assign, nonatomic) float minDistance;

@property (weak, nonatomic) id<NZRangeSelectorCompatibleViewDelegate> delegate;


/**
 default: #c7c7cc
 */
@property (retain, nonatomic) UIColor* trackColor UI_APPEARANCE_SELECTOR;

/**
 default: #000000
 */
@property (retain, nonatomic) UIColor* tintColor UI_APPEARANCE_SELECTOR;

/**
 default: 4.0f
 */
@property (assign, nonatomic) CGFloat trackHeight UI_APPEARANCE_SELECTOR;

-(void)setLeftValue:(float)leftValue animated:(BOOL)animated;
-(void)setRightValue:(float)rightValue animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
