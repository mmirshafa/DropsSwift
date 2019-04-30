//
//  MyHorizontalStackView.h
//  healthapp-iOS
//
//  Created by Hamidreza Vakilian on 5/28/1397 AP.
//  Copyright © 1397 Nizek. All rights reserved.
//

#import "_viewBase.h"

typedef enum : NSUInteger {
    MyHorizontalStackViewFillModeFill,
    MyHorizontalStackViewFillModeCenter,
    MyHorizontalStackViewFillModeTop,
    MyHorizontalStackViewFillModeBottom,
} MyHorizontalStackViewFillMode;

@interface MyHorizontalStackView : _viewBase

-(void)removeArrangedSubview:(UIView*)subview animated:(BOOL)animated;

/**
 Adds an arranged view into the stackview.
 
 @param subview subview to add
 @param margins margins of the item (not offsets!)
 @param animated add to stackview with animation or not
 @param fillMode fillmode can be fillmode, right, left, center
 @param hidden initially hidden or not
 @param onLeft if true it will be inserted on leftmost. if false it will be appended.
 @param targetView if onLeft is true, the subview will inserted on left of targetView. if onLeft is false the subview will be appended after the targetView.
 */
-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyHorizontalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden onLeft:(BOOL)onLeft targetView:(UIView*)targetView;
-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyHorizontalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden onLeft:(BOOL)onLeft;
-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyHorizontalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden;
-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyHorizontalStackViewFillMode)fillMode;
-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated;
-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins;
-(void)addArrangedSubview:(UIView *)subview;
-(void)addArrangedSubview:(UIView *)subview initiallyHidden:(BOOL)hidden;
-(void)hideArrangedSubview:(UIView*)view animated:(BOOL)animated;
-(void)showArrangedSubview:(UIView*)view animated:(BOOL)animated;
-(void)hideArrangedSubview:(UIView*)view animated:(BOOL)animated completion:(void(^)(void))callback;
-(void)showArrangedSubview:(UIView*)view animated:(BOOL)animated completion:(void(^)(void))callback;
-(BOOL)arrangedViewIsHidden:(UIView*)view;
-(BOOL)hasArrangedSubview:(UIView*)aView;
-(NSArray<UIView*>*)arrangedSubviews;
/**
 In order to get a nice sliding animation when showing or hiding an arrangedview, MyVerticalStackView will execute layoutIfNeeded on this view. otherwise it will perform it on nearest uiviewcontroller's view.
 */
@property (weak, nonatomic) UIView* view2Layout;

@end
