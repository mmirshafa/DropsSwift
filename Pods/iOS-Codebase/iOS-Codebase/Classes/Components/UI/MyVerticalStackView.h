//
//  MyStackView.h
//  Pods
//
//  Created by hAmidReza on 6/21/17.
//
//

#import "_viewBase.h"


typedef enum : NSUInteger {
    MyVerticalStackViewFillModeFill,
    MyVerticalStackViewFillModeCenter,
    MyVerticalStackViewFillModeLeft,
    MyVerticalStackViewFillModeRight,
} MyVerticalStackViewFillMode;

@interface MyVerticalStackView : _viewBase

-(void)removeArrangedSubview:(UIView*)subview animated:(BOOL)animated;

/**
 Adds an arranged view into the stackview.
 
 @param subview subview to add
 @param margins margins of the item (not offsets!)
 @param animated add to stackview with animation or not
 @param fillMode fillmode can be fillmode, right, left, center
 @param hidden initially hidden or not
 @param onTop if true it will be inserted on top. if false it will be appended.
 @param targetView if onTop is true, the subview will inserted on top of targetView. if onTop is false the subview will be appended right after the targetView.
 */
-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyVerticalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden onTop:(BOOL)onTop targetView:(UIView*)targetView;
-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyVerticalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden onTop:(BOOL)onTop;
-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyVerticalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden;
-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyVerticalStackViewFillMode)fillMode;
-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated;
-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins;
-(void)addArrangedSubview:(UIView *)subview;
-(void)addArrangedSubview:(UIView *)subview initiallyHidden:(BOOL)hidden;
-(void)hideArrangedSubview:(UIView*)view animated:(BOOL)animated;
-(void)showArrangedSubview:(UIView*)view animated:(BOOL)animated;
-(void)hideArrangedSubview:(UIView*)view animated:(BOOL)animated completion:(void(^)())callback;
-(void)showArrangedSubview:(UIView*)view animated:(BOOL)animated completion:(void(^)())callback;
-(BOOL)arrangedViewIsHidden:(UIView*)view;
-(BOOL)hasArrangedSubview:(UIView*)aView;
-(NSArray<UIView*>*)arrangedSubviews;
/**
 In order to get a nice sliding animation when showing or hiding an arrangedview, MyVerticalStackView will execute layoutIfNeeded on this view. otherwise it will perform it on nearest uiviewcontroller's view.
 */
@property (weak, nonatomic) UIView* view2Layout;

@end
