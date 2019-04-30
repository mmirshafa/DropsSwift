
//
//  emImageView.h
//  HVFancyEffects
//
//  Created by hAmidReza on 5/19/92.
//  Copyright (c) 1392 hAmidReza. All rights reserved.
//

#import <UIKit/UIKit.h>

#define top_margin 20
#define left_margin 20

//#define thumb_size    56
//#define thumb_border 4
//#define thumb_spacing 5
//#define thumb_corner_radius 4
//#define thumb_bottom_margin 15
//#define thumb_size_enlargement 16
//#define thumb_enlarge_duration 1.0
//#define thumb_idle_border_color [UIColor grayColor]
//#define thumb_highlighted_border_color [UIColor colorWithRed:0.792 green:0.631 blue:0.333 alpha:1]

//#define thumb_enlargement_animation_duration .5

#import "_viewBase.h"

@interface emImageShow : _viewBase


-(instancetype)initWithImageArray:(NSArray<UIImage*>*)imageArray;

//@property (retain, nonatomic) NSNumber* cornerRadius;
//@property (retain, nonatomic) NSArray* imagesFileNames;

//@property (assign, nonatomic) CGRect frameToDisplay;

@property (retain, nonatomic, readonly) NSArray<UIImage*>* imageArray;


/**
 default: 1.0f
 */
@property (assign, nonatomic) float switchingDuration;

/**
 default: 4.0f
 */
@property (assign, nonatomic) float switchingInterval;

/**
 default: 1.1
 */
@property (assign, nonatomic) float scaleMax;

/**
 default: 1.0
 */
@property (assign, nonatomic) float scaleMin;

-(void)beginSliding;
//-(void)displayThumbnails;
-(void)stop;

@end
