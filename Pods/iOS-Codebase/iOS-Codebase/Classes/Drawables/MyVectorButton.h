//
//  MyVectorButton.h
//  mactehrannew
//
//  Created by hAmidReza on 8/30/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_UIControlBase2.h"
@class MyVector;

@interface MyVectorButton : _UIControlBase2

-(instancetype)initWithVector:(NSDictionary*)vector andButtonClick:(void (^)(void))buttonClick;
@property (retain, nonatomic) MyVector* vectorView;
@property (copy, nonatomic) void (^buttonClick)();

@property (retain, nonatomic) UIColor* shadowColor;
@property (assign, nonatomic) float shadowOpacity;
@property (assign, nonatomic) CGSize shadowOffset;
@property (assign, nonatomic) CGFloat shadowRadius;

@property (assign, nonatomic) UIEdgeInsets shapeMargins;
@property (assign, nonatomic) BOOL setsCornerRadiusForVectorView;

@property (retain, nonatomic) UIColor* highlightColor;


@end
