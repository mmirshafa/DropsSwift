//
//  MyShapeView.h
//  Prediscore
//
//  Created by Hamidreza Vaklian on 7/5/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 thanks to HVVectorizer 1.1, MyShapeView is now able to take care of all Artboard sizes. Still the old shapeDescs will work and the new HVVectorizer 1.1 transfers the size of the artboards to MyShapeView so it can aspect fit the drawing rect inside the view.
 */
@interface MyShapeView : UIView

-(instancetype)initWithShapeDesc:(NSArray*)desc andShapeTintColor:(UIColor*)shapeTintColor;
@property (retain, nonatomic) UIColor* shapeTintColor;
@property (retain, nonatomic) NSArray* shapeDesc;
@property (retain, nonatomic) UIBezierPath* path;

@property (retain, nonatomic) NSNumber* rotation; //degress

@property (retain, nonatomic) UIColor* shadowColor;
@property (assign, nonatomic) float shadowOpacity;
@property (assign, nonatomic) CGSize shadowOffset;
@property (assign, nonatomic) CGFloat shadowRadius;

@property (assign, nonatomic) CGFloat borderWidth;
@property (retain, nonatomic) UIColor* borderColor;


/**
 By setting the option to true, MyShapeView will maintain it's aspect ratio with AutoLayout based on it's content. In this case you will have to put a constraint on one of either width or height. The other value will be computed by the aspectRatio of the MyShapeView.
 default: false.
 */
@property (assign, nonatomic) BOOL maintainAspectRatio;

@property (nonatomic, readonly) CAShapeLayer* shapeLayer;

+(UIImage*)imageFromShapeDesc:(NSArray*)desc andShapeTintColor:(UIColor*)shapeTintColor andSize:(CGSize)size;

@end
