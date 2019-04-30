//
//  MyShapeButton.h
//  Prediscore
//
//  Created by Hamidreza Vaklian on 7/5/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyShapeView;
@interface MyShapeButton : UIButton

-(instancetype)initWithShapeDesc:(NSArray*)desc andShapeTintColor:(UIColor*)shapeTintColor andButtonClick:(void (^)(void))buttonClick;
@property (retain, nonatomic) MyShapeView* shapeView;
@property (copy, nonatomic) void (^buttonClick)(void);

@property (retain, nonatomic) UIColor* shadowColor;
@property (assign, nonatomic) float shadowOpacity;
@property (assign, nonatomic) CGSize shadowOffset;
@property (assign, nonatomic) CGFloat shadowRadius;

@property (retain, nonatomic) UIColor* borderColor;

@property (assign, nonatomic) UIEdgeInsets shapeMargins;
@property (assign, nonatomic) BOOL setsCornerRadiusForShapeView;

@property (retain, nonatomic) UIColor* shapeBorderColor;
@property (assign, nonatomic) CGFloat shapeBorderWidth;


/**
 default: true
 */
@property (assign, nonatomic) BOOL setsBackgroundColorForShapeView;

@property (retain, nonatomic) UIColor* highlightColor;


@end
