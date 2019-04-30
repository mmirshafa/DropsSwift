//
//  HyperSegmentedControl.h
//  HyperSegmentedControl
//
//  Created by hAmidReza on 8/21/16.
//  Copyright © 2016 innovian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HyperSegmentedControl;

@protocol HyperSegmentedControlDataSource <NSObject>

-(NSUInteger)numberOfViewsForHyperSegmentedControl:(HyperSegmentedControl*)control;
-(CGSize)HyperSegmentedControl:(HyperSegmentedControl*)control sizeOfItemAtIndex:(NSUInteger)index;
-(UIView*)HyperSegmentedControl:(HyperSegmentedControl*)control viewForItemAtIndex:(NSUInteger)index;

@optional
-(UIColor*)HyperSegmentedControl:(HyperSegmentedControl*)control colorOfIndicatorAtIndex:(NSUInteger)index;
-(CGFloat)HyperSegmentedControl:(HyperSegmentedControl*)control widthOfIndicatorAtIndex:(NSUInteger)index;

@end

@protocol HyperSegmentedControlDelegate <NSObject>

@optional
-(void)HyperSegmentedControl:(HyperSegmentedControl*)control didSelectedItemAtIndex:(NSUInteger)index;

@end


typedef enum : NSUInteger {
	HyperSegmentedControlCapModeRoundDown,
	HyperSegmentedControlCapModeRect,
} HyperSegmentedControlCapMode;

@interface HyperSegmentedControl : UIScrollView

@property (assign, nonatomic) CGFloat indicatorHeight;
@property (retain, nonatomic) UIColor* indicatorColor;
@property (assign, nonatomic) NSUInteger selectedIndex;
@property (assign, nonatomic) float preciseIndex;


/**
 cap mode for indicator view. defaults to HyperSegmentedControlCapModeRoundDown
 */
@property (assign, nonatomic) HyperSegmentedControlCapMode indicatorCapMode;

@property (weak, nonatomic) id <HyperSegmentedControlDataSource> hyperSegmentedControlDataSource;
@property (weak, nonatomic) id <HyperSegmentedControlDelegate> hyperSegmentedControlDelegate;

-(void)reloadView;
-(void)snapToNearestAnimated:(BOOL)animated;

@end
