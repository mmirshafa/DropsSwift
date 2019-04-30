//
//  NZRangeSelectorHandleView.h
//  MyAthath
//
//  Created by Developer on 1/21/19.
//  Copyright © 2019 Nizek. All rights reserved.
//

#import "_viewBase.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    NZRangeSelectorHandleBallonViewTypeLeft,
    NZRangeSelectorHandleBallonViewTypeRight,
} NZRangeSelectorHandleBallonViewType;

@interface NZRangeSelectorHandleBallonView : _viewBase

/**
 defaults to black
 */
@property (retain, nonatomic) UIColor* theColor;

@property (assign, nonatomic) NZRangeSelectorHandleBallonViewType type;

-(instancetype)initWithType:(NZRangeSelectorHandleBallonViewType)type;

@end

NS_ASSUME_NONNULL_END
