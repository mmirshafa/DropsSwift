//
//  MyHorizontalStackView.m
//  healthapp-iOS
//
//  Created by Hamidreza Vakilian on 5/28/1397 AP.
//  Copyright © 1397 Nizek. All rights reserved.
//

#import "MyHorizontalStackView.h"
#import "UIView+SDCAutoLayout.h"
#import "NSObject+DataObject.h"
#import "Codebase_definitions.h"
#import "UIView+Extensions.h"
#import "_weakContainer.h"

#define kTopKey            @"top"
#define kLeftKey        @"left"
#define kRightKey        @"right"
#define kBottomKey        @"bottom"
#define kCenterKey        @"center"

@interface MyHorizontalStackViewArrangedViewHolder : _viewBase
@property (retain, nonatomic) NSLayoutConstraint* top;
@property (retain, nonatomic) NSLayoutConstraint* left;
@property (retain, nonatomic) NSLayoutConstraint* bottom;
@property (retain, nonatomic) NSLayoutConstraint* right;
@property (retain, nonatomic) UIView* mainView;
@property (retain, nonatomic) NSLayoutConstraint* widthCon;

@property (weak, nonatomic) UIView* view2Layout;
@end

@implementation MyHorizontalStackViewArrangedViewHolder

-(instancetype)initWithView:(UIView*)view andMargins:(UIEdgeInsets)margins initiallyHidden:(BOOL)hidden
{
    self = [super init];
    if (self)
    {
        self.clipsToBounds = YES;
        self.mainView = view;
        [self.mainView setDataObject:[[_weakContainer alloc] initWithWeakObject:self] forKey:@"MyStackViewArrangedViewHolder"];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        self.top = [view sdc_alignTopEdgeWithSuperviewMargin:margins.top];
        self.left = [view sdc_alignLeftEdgeWithSuperviewMargin:margins.left];
        self.bottom = [view sdc_alignBottomEdgeWithSuperviewMargin:margins.bottom];
        _defineWeakSelf;
        [UIView sdc_priority:UILayoutPriorityDefaultLow block:^{
            weakSelf.right = [view sdc_alignRightEdgeWithSuperviewMargin:margins.right];
        }];
        
        self.widthCon = [self sdc_setMaximumWidth:hidden ? 0 : 10000];
    }
    
    return self;
}

-(void)hideAnimated:(BOOL)aniamted
{
    [self hideAnimated:aniamted completion:nil];
}

-(void)hideAnimated:(BOOL)aniamted completion:(void(^)(void))callback
{
    self.widthCon.constant = 0;
    
    UIView* finalView2Layout = [[self getNearestVC] view];
    
    if (!finalView2Layout)
        return;
    
    
    [UIView animateWithDuration:aniamted ? .3 : 0 animations:^{
        [finalView2Layout  layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (callback)
            callback();
    }];
}

-(void)showAnimated:(BOOL)aniamted
{
    [self showAnimated:aniamted completion:nil];
}

-(void)showAnimated:(BOOL)aniamted completion:(void(^)(void))callback
{
    self.widthCon.constant = 10000;
    
    UIView* finalView2Layout = [[self getNearestVC] view];
    
    if (!finalView2Layout)
        return;
    
    [UIView animateWithDuration:aniamted ? .3 : 0 animations:^{
        [finalView2Layout layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (callback)
            callback();
    }];
}

-(BOOL)arrangedViewHidden
{
    return self.widthCon.constant == 0 ? YES : NO;
}

@end

////////////////////////////////////////////////////////////////////////////////

@interface MyHorizontalStackView ()
{
    NSMutableArray* views;
}

@end

@implementation MyHorizontalStackView

-(void)addSubview:(UIView *)view
{
    NSAssert(false, @"MyHorizontalStackView: don't use addSubview. please use addArrangedSubview.");
}

-(void)initialize
{
    views = [NSMutableArray new];
}

-(void)addArrangedSubview:(UIView *)subview
{
    [self addArrangedSubview:subview margins:UIEdgeInsetsZero];
}

-(BOOL)arrangedViewIsHidden:(UIView*)view
{
    _weakContainer* weakContainer = [view dataObjectForKey:@"MyStackViewArrangedViewHolder"];
    
    MyHorizontalStackViewArrangedViewHolder* holder = (MyHorizontalStackViewArrangedViewHolder*)weakContainer.weakObject;
    
    NSAssert(holder && [views containsObject:holder], @"arrangedViewIsHidden: view is not added to the stack");
    
    return [holder arrangedViewHidden];
}

-(void)hideArrangedSubview:(UIView*)view animated:(BOOL)animated
{
    [self hideArrangedSubview:view animated:animated completion:nil];
}

-(void)hideArrangedSubview:(UIView*)view animated:(BOOL)animated completion:(void(^)(void))callback

{
    MyHorizontalStackViewArrangedViewHolder* holder = [self getHolderForArrangedSubview:view];
    holder.view2Layout = _view2Layout;
    [holder hideAnimated:animated completion:callback];
}

-(BOOL)hasArrangedSubview:(UIView*)aView
{
    return [self getHolderForArrangedSubview:aView forceGet:NO] ? YES : NO;
}

-(void)showArrangedSubview:(UIView*)view animated:(BOOL)animated
{
    [self showArrangedSubview:view animated:animated completion:nil];
}

-(void)showArrangedSubview:(UIView*)view animated:(BOOL)animated completion:(void(^)(void))callback
{
    MyHorizontalStackViewArrangedViewHolder* holder = [self getHolderForArrangedSubview:view];
    holder.view2Layout = _view2Layout;
    [holder showAnimated:animated completion:callback];
}

-(MyHorizontalStackViewArrangedViewHolder*)getHolderForArrangedSubview:(UIView*)view
{
    return [self getHolderForArrangedSubview:view forceGet:YES];
}

-(MyHorizontalStackViewArrangedViewHolder*)getHolderForArrangedSubview:(UIView*)view forceGet:(bool)force_get
{
    _weakContainer* weakContainer = [view dataObjectForKey:@"MyStackViewArrangedViewHolder"];
    
    MyHorizontalStackViewArrangedViewHolder* holder = (MyHorizontalStackViewArrangedViewHolder*)weakContainer.weakObject;
    
    if (force_get)
        NSAssert(holder && [views containsObject:holder], @"hideArrangedSubview: view is not added to the stack");
    
    return holder;
}

-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins
{
    [self addArrangedSubview:subview margins:margins animated:NO];
}

-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated
{
    [self addArrangedSubview:subview margins:margins animated:animated fillMode:MyHorizontalStackViewFillModeFill initiallyHidden:NO];
}

-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyHorizontalStackViewFillMode)fillMode
{
    [self addArrangedSubview:subview margins:margins animated:animated fillMode:fillMode initiallyHidden:NO];
}

//-(void)addArrangedSubviewonLeft:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyHorizontalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden
//{
//
//}

-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyHorizontalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden
{
    [self addArrangedSubview:subview margins:margins animated:animated fillMode:fillMode initiallyHidden:hidden onLeft:NO];
}

-(void)addArrangedSubview:(UIView *)subview initiallyHidden:(BOOL)hidden
{
    [self addArrangedSubview:subview margins:UIEdgeInsetsZero animated:NO fillMode:MyHorizontalStackViewFillModeFill initiallyHidden:hidden onLeft:NO targetView:nil];
}

-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyHorizontalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden onLeft:(BOOL)onLeft
{
    [self addArrangedSubview:subview margins:margins animated:animated fillMode:fillMode initiallyHidden:hidden onLeft:onLeft targetView:nil];
}

-(MyHorizontalStackViewArrangedViewHolder*)getRightViewOf:(MyHorizontalStackViewArrangedViewHolder*)view
{
    int idx = (int)[views indexOfObject:view];
    NSAssert(idx != NSNotFound, @"view is not in the hierarchy!");
    
    if (idx - (int)views.count + 2 <= 0)
        return views[idx+1];
    else
        return nil;
}

-(MyHorizontalStackViewArrangedViewHolder*)getLeftViewOf:(MyHorizontalStackViewArrangedViewHolder*)view
{
    NSUInteger idx = [views indexOfObject:view];
    NSAssert(idx != NSNotFound, @"view is not in the hierarchy!");
    
    if (idx >= 1)
        return views[idx-1];
    else
        return nil;
}

-(void)removeLeftConForArrangedView:(MyHorizontalStackViewArrangedViewHolder*)view
{
    if (!view) return;
    NSLayoutConstraint* pivotViewLeftCon = view.objectData[kLeftKey];
    [self removeConstraint:pivotViewLeftCon];
    [view.objectData removeObjectForKey:kLeftKey];
}

-(void)removeRightConForArrangedView:(MyHorizontalStackViewArrangedViewHolder*)view
{
    if (!view) return;
    NSLayoutConstraint* pivotViewRightCon = view.objectData[kRightKey];
    [self removeConstraint:pivotViewRightCon];
    [view.objectData removeObjectForKey:kRightKey];
}

-(void)assignConstraint:(NSLayoutConstraint*)con withKey:(NSString*)key toArrangedView:(MyHorizontalStackViewArrangedViewHolder*)view
{
    NSMutableDictionary* desc = view.objectData;
    desc[key] = con;
}

-(void)removeArrangedSubview:(UIView*)subview animated:(BOOL)animated
{
    MyHorizontalStackViewArrangedViewHolder* subviewHolder = [self getHolderForArrangedSubview:subview];
    
    if (animated)
    {
        [subviewHolder hideAnimated:YES completion:^{
            [self _removeArrangedViewHolder:subviewHolder];
        }];
    }
    else
        [self _removeArrangedViewHolder:subviewHolder];
    
}

-(void)_removeArrangedViewHolder:(MyHorizontalStackViewArrangedViewHolder*)subviewHolder
{
    MyHorizontalStackViewArrangedViewHolder* leftView = [self getLeftViewOf:subviewHolder];
    MyHorizontalStackViewArrangedViewHolder* rightView = [self getRightViewOf:subviewHolder];
    
    [self removeRightConForArrangedView:leftView];
    [self removeLeftConForArrangedView:rightView];
    
    if (leftView)
    {
        NSLayoutConstraint* leftViewRightCon;
        if (rightView)
        {
            leftViewRightCon = [leftView sdc_alignEdge:UIRectEdgeRight withEdge:UIRectEdgeLeft ofView:rightView];
            [self assignConstraint:leftViewRightCon withKey:kRightKey toArrangedView:leftView];
            [self assignConstraint:leftViewRightCon withKey:kLeftKey toArrangedView:rightView];
        }
        else
        {
            leftViewRightCon = [leftView sdc_alignRightEdgeWithSuperviewMargin:0];
            [self assignConstraint:leftViewRightCon withKey:kRightKey toArrangedView:leftView];
        }
    }
    else if (rightView)
    {
        NSLayoutConstraint* rightViewLeftCon = [rightView sdc_alignLeftEdgeWithSuperviewMargin:0];
        [self assignConstraint:rightViewLeftCon withKey:kLeftKey toArrangedView:rightView];
    }
    
    [views removeObject:subviewHolder];
    [subviewHolder removeFromSuperview];
}

-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyHorizontalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden onLeft:(BOOL)onLeft targetView:(UIView*)targetView
{
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    MyHorizontalStackViewArrangedViewHolder* subviewHolder = [[MyHorizontalStackViewArrangedViewHolder alloc] initWithView:subview andMargins:margins initiallyHidden:hidden];
    subviewHolder.translatesAutoresizingMaskIntoConstraints = NO;
    
    MyHorizontalStackViewArrangedViewHolder* leftView;
    MyHorizontalStackViewArrangedViewHolder* rightView;
    
    if (targetView)
    {
        if (onLeft)
        {
            rightView = [self getHolderForArrangedSubview:targetView];
            leftView = [self getLeftViewOf:rightView];
        }
        else //on bottom
        {
            leftView = [self getHolderForArrangedSubview:targetView];
            rightView = [self getRightViewOf:leftView];
        }
    }
    else
    {
        if (onLeft) //on leftMost
        {
            rightView = _arr_ok2(views) ? views[0] : nil;
            leftView = nil;
        }
        else //on rightmost
        {
            rightView = nil;
            leftView = _arr_ok2(views) ? [views lastObject] : nil;
        }
    }
    
    [self removeRightConForArrangedView:leftView];
    [self removeLeftConForArrangedView:rightView];
    
    [super addSubview:subviewHolder];
    
    if (animated)
    {
        [subviewHolder hideAnimated:NO];
    }
    
    NSLayoutConstraint* leftCon;
    NSLayoutConstraint* rightCon;
    
    if (leftView)
    {
        leftCon = [subviewHolder sdc_alignEdge:UIRectEdgeLeft withEdge:UIRectEdgeRight ofView:leftView];
        [self assignConstraint:leftCon withKey:kRightKey toArrangedView:leftView];
    }
    else
        leftCon = [subviewHolder sdc_alignLeftEdgeWithSuperviewMargin:0];
    
    if (rightView)
    {
        rightCon = [subviewHolder sdc_alignEdge:UIRectEdgeRight withEdge:UIRectEdgeLeft ofView:rightView];
        [self assignConstraint:rightCon withKey:kLeftKey toArrangedView:rightView];
    }
    else
        rightCon = [subviewHolder sdc_alignRightEdgeWithSuperviewMargin:0];
    
    if (fillMode == MyHorizontalStackViewFillModeFill)
    {
        NSLayoutConstraint* topCon = [subviewHolder sdc_alignTopEdgeWithSuperviewMargin:0];
        NSLayoutConstraint* bottomCon = [subviewHolder sdc_alignBottomEdgeWithSuperviewMargin:0];
        
        subviewHolder.objectData = [@{kTopKey: topCon, kLeftKey: leftCon, kRightKey: rightCon, kBottomKey: bottomCon} mutableCopy];
    }
    else if (fillMode == MyHorizontalStackViewFillModeTop)
    {
        NSLayoutConstraint* topCon = [subviewHolder sdc_alignTopEdgeWithSuperviewMargin:0];
        
        subviewHolder.objectData = [@{kTopKey: topCon, kLeftKey: leftCon, kRightKey: rightCon} mutableCopy];
    }
    else if (fillMode == MyHorizontalStackViewFillModeBottom)
    {
        NSLayoutConstraint* bottomCon = [subviewHolder sdc_alignBottomEdgeWithSuperviewMargin:0];
        
        subviewHolder.objectData = [@{kLeftKey: leftCon, kRightKey: rightCon, kBottomKey: bottomCon} mutableCopy];
    }
    else if (fillMode == MyHorizontalStackViewFillModeCenter)
    {
        NSLayoutConstraint* centerCon = [subviewHolder sdc_verticallyCenterInSuperview];
        
        subviewHolder.objectData = [@{kLeftKey: leftCon, kCenterKey: centerCon, kRightKey: rightCon} mutableCopy];
    }
    
    if (!leftView) //it's on top of the stackview
    {
        [views insertObject:subviewHolder atIndex:0];
    }
    else if (!rightView) //it's on bottom of the stackview
    {
        [views addObject:subviewHolder];
    }
    else if (!leftView && !rightView) //it's the only view
    {
        [views addObject:subviewHolder];
    }
    else //it's something in middle
    {
        [views insertObject:subviewHolder atIndex:[views indexOfObject:leftView]+1];
    }
    
    if (animated && !hidden)
    {
        [self layoutIfNeeded];
        [subviewHolder showAnimated:YES];
    }
}

-(NSArray<UIView*>*)arrangedSubviews
{
    NSMutableArray* result = [NSMutableArray new];
    for (MyHorizontalStackViewArrangedViewHolder* holder in self.subviews)
    {
        [result addObject:holder.mainView];
    }
    return result;
}
@end
