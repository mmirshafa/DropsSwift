//
//  MyBouncyButton.h
//  mactehrannew
//
//  Created by hAmidReza on 5/29/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "MyShapeButton.h"
#import "NSObject+uniconf.h"


@interface MyBouncyButton : MyShapeButton <uniconf>


-(instancetype)initWithShapeDesc:(NSArray *)desc andShapeTintColor:(UIColor *)shapeTintColor andButtonClick:(void (^)(BOOL on))buttonClick;

@property (copy, nonatomic) void (^bouncyButtonClick)(BOOL);
@property (copy, nonatomic) BOOL (^canChangeToMode)(BOOL);

@property (assign, nonatomic) BOOL onOffBehavior; //default: true
@property (assign, nonatomic) BOOL on;

//off state
@property (retain, nonatomic) NSArray* icon1;
@property (retain, nonatomic) UIColor* shapeTintColor1;
@property (retain, nonatomic) UIColor* backgroundColor1;
@property (retain, nonatomic) UIColor* borderColor1;


/**
 default: 1
 */
@property (assign, nonatomic) CGFloat u_offstate_transform_ratio;


/**
 default: 20.0f
 */
@property (assign, nonatomic) CGFloat u_onstate_bounce;

/**
 default: 10.0f
 */
@property (assign, nonatomic) CGFloat u_offstate_bounce;

/**
 default: 10.0f
 */
@property (assign, nonatomic) CGFloat u_normal_velocity;

/**
 default: 10.0f
 */
@property (assign, nonatomic) CGFloat u_on_velocity;

/**
 default: 10.0f
 */
@property (assign, nonatomic) CGFloat u_off_velocity;

//on state
@property (retain, nonatomic) NSArray* icon2;
@property (retain, nonatomic) UIColor* shapeTintColor2;
@property (retain, nonatomic) UIColor* backgroundColor2;
@property (retain, nonatomic) UIColor* borderColor2;

@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) CGFloat borderWidth;

/**
 default: 1
 */
@property (assign, nonatomic) CGFloat u_onstate_transform_ratio;

-(void)setOn:(BOOL)on animated:(BOOL)animated;

-(void)buttonTouch:(id)sender;

@end
