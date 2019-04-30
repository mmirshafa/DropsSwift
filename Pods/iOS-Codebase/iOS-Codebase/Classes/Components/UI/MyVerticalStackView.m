//
//  MyStackView.m
//  Pods
//
//  Created by hAmidReza on 6/21/17.
//
//

#import "MyVerticalStackView.h"
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

@interface MyStackViewArrangedViewHolder : _viewBase
@property (retain, nonatomic) NSLayoutConstraint* top;
@property (retain, nonatomic) NSLayoutConstraint* left;
@property (retain, nonatomic) NSLayoutConstraint* bottom;
@property (retain, nonatomic) NSLayoutConstraint* right;
@property (retain, nonatomic) UIView* mainView;
@property (retain, nonatomic) NSLayoutConstraint* heightCon;

@property (weak, nonatomic) UIView* view2Layout;
@end

@implementation MyStackViewArrangedViewHolder

-(instancetype)initWithView:(UIView*)view andMargins:(UIEdgeInsets)margins initiallyHidden:(BOOL)hidden
{
    self = [super init];
    if (self)
    {
        self.clipsToBounds = YES;
        _mainView = view;
        [_mainView setDataObject:[[_weakContainer alloc] initWithWeakObject:self] forKey:@"MyStackViewArrangedViewHolder"];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        _top = [view sdc_alignTopEdgeWithSuperviewMargin:margins.top];
        _left = [view sdc_alignLeftEdgeWithSuperviewMargin:margins.left];
        _right = [view sdc_alignRightEdgeWithSuperviewMargin:margins.right];
        [UIView sdc_priority:UILayoutPriorityDefaultLow block:^{
            _bottom = [view sdc_alignBottomEdgeWithSuperviewMargin:margins.bottom];
        }];
        
        _heightCon = [self sdc_setMaximumHeight:hidden ? 0 : 10000];
    }
    
    return self;
}

-(void)hideAnimated:(BOOL)aniamted
{
    [self hideAnimated:aniamted completion:nil];
}

-(void)hideAnimated:(BOOL)aniamted completion:(void(^)())callback
{
    _heightCon.constant = 0;
    
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

-(void)showAnimated:(BOOL)aniamted completion:(void(^)())callback
{
    _heightCon.constant = 10000;
    
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

-(BOOL)arrangedViewHidden
{
    return _heightCon.constant == 0 ? YES : NO;
}

@end

////////////////////////////////////////////////////////////////////////////////

@interface MyVerticalStackView ()
{
    NSMutableArray* views;
}

@end

@implementation MyVerticalStackView

-(void)addSubview:(UIView *)view
{
    NSAssert(false, @"MyVerticalStackView: don't use addSubview. please use addArrangedSubview.");
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
    
    MyStackViewArrangedViewHolder* holder = weakContainer.weakObject;
    
    NSAssert(holder && [views containsObject:holder], @"arrangedViewIsHidden: view is not added to the stack");
    
    return [holder arrangedViewHidden];
}

-(void)hideArrangedSubview:(UIView*)view animated:(BOOL)animated
{
    [self hideArrangedSubview:view animated:animated completion:nil];
}

-(void)hideArrangedSubview:(UIView*)view animated:(BOOL)animated completion:(void(^)())callback

{
    MyStackViewArrangedViewHolder* holder = [self getHolderForArrangedSubview:view];
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

-(void)showArrangedSubview:(UIView*)view animated:(BOOL)animated completion:(void(^)())callback
{
    MyStackViewArrangedViewHolder* holder = [self getHolderForArrangedSubview:view];
    holder.view2Layout = _view2Layout;
    [holder showAnimated:animated completion:callback];
}

-(MyStackViewArrangedViewHolder*)getHolderForArrangedSubview:(UIView*)view
{
    return [self getHolderForArrangedSubview:view forceGet:YES];
}

-(MyStackViewArrangedViewHolder*)getHolderForArrangedSubview:(UIView*)view forceGet:(bool)force_get
{
    _weakContainer* weakContainer = [view dataObjectForKey:@"MyStackViewArrangedViewHolder"];
    
    MyStackViewArrangedViewHolder* holder = weakContainer.weakObject;
    
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
    [self addArrangedSubview:subview margins:margins animated:animated fillMode:MyVerticalStackViewFillModeFill initiallyHidden:NO];
}

-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyVerticalStackViewFillMode)fillMode
{
    [self addArrangedSubview:subview margins:margins animated:animated fillMode:fillMode initiallyHidden:NO];
}

//-(void)addArrangedSubviewOnTop:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyVerticalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden
//{
//
//}

-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyVerticalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden
{
    [self addArrangedSubview:subview margins:margins animated:animated fillMode:fillMode initiallyHidden:hidden onTop:NO];
}

-(void)addArrangedSubview:(UIView *)subview initiallyHidden:(BOOL)hidden
{
    [self addArrangedSubview:subview margins:UIEdgeInsetsZero animated:NO fillMode:MyVerticalStackViewFillModeFill initiallyHidden:hidden onTop:NO targetView:nil];
}

-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyVerticalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden onTop:(BOOL)onTop
{
    [self addArrangedSubview:subview margins:margins animated:animated fillMode:fillMode initiallyHidden:hidden onTop:onTop targetView:nil];
}

-(MyStackViewArrangedViewHolder*)getLowerViewOf:(MyStackViewArrangedViewHolder*)view
{
    int idx = (int)[views indexOfObject:view];
    NSAssert(idx != NSNotFound, @"view is not in the hierarchy!");
    
    if (idx - (int)views.count + 2 <= 0)
        return views[idx+1];
    else
        return nil;
}

-(MyStackViewArrangedViewHolder*)getUpperViewOf:(MyStackViewArrangedViewHolder*)view
{
    NSUInteger idx = [views indexOfObject:view];
    NSAssert(idx != NSNotFound, @"view is not in the hierarchy!");
    
    if (idx >= 1)
        return views[idx-1];
    else
        return nil;
}

-(void)removeTopConForArrangedView:(MyStackViewArrangedViewHolder*)view
{
    if (!view) return;
    NSLayoutConstraint* pivotViewTopCon = view.objectData[kTopKey];
    [self removeConstraint:pivotViewTopCon];
    [view.objectData removeObjectForKey:kTopKey];
}

-(void)removeBottomConForArrangedView:(MyStackViewArrangedViewHolder*)view
{
    if (!view) return;
    NSLayoutConstraint* pivotViewBottomCon = view.objectData[kBottomKey];
    [self removeConstraint:pivotViewBottomCon];
    [view.objectData removeObjectForKey:kBottomKey];
}

-(void)assignConstraint:(NSLayoutConstraint*)con withKey:(NSString*)key toArrangedView:(MyStackViewArrangedViewHolder*)view
{
    NSMutableDictionary* desc = view.objectData;
    desc[key] = con;
}

-(void)removeArrangedSubview:(UIView*)subview animated:(BOOL)animated
{
    MyStackViewArrangedViewHolder* subviewHolder = [self getHolderForArrangedSubview:subview];
    
    if (animated)
    {
        [subviewHolder hideAnimated:YES completion:^{
            [self _removeArrangedViewHolder:subviewHolder];
        }];
    }
    else
        [self _removeArrangedViewHolder:subviewHolder];
    
}

-(void)_removeArrangedViewHolder:(MyStackViewArrangedViewHolder*)subviewHolder
{
    MyStackViewArrangedViewHolder* upperView = [self getUpperViewOf:subviewHolder];
    MyStackViewArrangedViewHolder* lowerView = [self getLowerViewOf:subviewHolder];
    
    [self removeBottomConForArrangedView:upperView];
    [self removeTopConForArrangedView:lowerView];
    
    if (upperView)
    {
        NSLayoutConstraint* upperViewBottomCon;
        if (lowerView)
        {
            upperViewBottomCon = [upperView sdc_alignEdge:UIRectEdgeBottom withEdge:UIRectEdgeTop ofView:lowerView];
            [self assignConstraint:upperViewBottomCon withKey:kBottomKey toArrangedView:upperView];
            [self assignConstraint:upperViewBottomCon withKey:kTopKey toArrangedView:lowerView];
        }
        else
        {
            upperViewBottomCon = [upperView sdc_alignBottomEdgeWithSuperviewMargin:0];
            [self assignConstraint:upperViewBottomCon withKey:kBottomKey toArrangedView:upperView];
        }
    }
    else if (lowerView)
    {
        NSLayoutConstraint* lowerViewTopCon = [lowerView sdc_alignTopEdgeWithSuperviewMargin:0];
        [self assignConstraint:lowerViewTopCon withKey:kTopKey toArrangedView:lowerView];
    }
    
    [views removeObject:subviewHolder];
    [subviewHolder removeFromSuperview];
}

-(void)addArrangedSubview:(UIView *)subview margins:(UIEdgeInsets)margins animated:(BOOL)animated fillMode:(MyVerticalStackViewFillMode)fillMode initiallyHidden:(BOOL)hidden onTop:(BOOL)onTop targetView:(UIView*)targetView
{
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    MyStackViewArrangedViewHolder* subviewHolder = [[MyStackViewArrangedViewHolder alloc] initWithView:subview andMargins:margins initiallyHidden:hidden];
    subviewHolder.translatesAutoresizingMaskIntoConstraints = NO;
    
    MyStackViewArrangedViewHolder* upperView;
    MyStackViewArrangedViewHolder* lowerView;
    
    if (targetView)
    {
        if (onTop)
        {
            lowerView = [self getHolderForArrangedSubview:targetView];
            upperView = [self getUpperViewOf:lowerView];
        }
        else //on bottom
        {
            upperView = [self getHolderForArrangedSubview:targetView];
            lowerView = [self getLowerViewOf:upperView];
        }
    }
    else
    {
        if (onTop) //on topmost
        {
            lowerView = _arr_ok2(views) ? views[0] : nil;
            upperView = nil;
        }
        else //on bottommost
        {
            lowerView = nil;
            upperView = _arr_ok2(views) ? [views lastObject] : nil;
        }
    }
    
    [self removeBottomConForArrangedView:upperView];
    [self removeTopConForArrangedView:lowerView];
    
    [super addSubview:subviewHolder];
    
    if (animated)
    {
        [subviewHolder hideAnimated:NO];
    }
    
    NSLayoutConstraint* topCon;
    NSLayoutConstraint* bottomCon;
    
    if (upperView)
    {
        topCon = [subviewHolder sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:upperView];
        [self assignConstraint:topCon withKey:kBottomKey toArrangedView:upperView];
    }
    else
        topCon = [subviewHolder sdc_alignTopEdgeWithSuperviewMargin:0];
    
    if (lowerView)
    {
        bottomCon = [subviewHolder sdc_alignEdge:UIRectEdgeBottom withEdge:UIRectEdgeTop ofView:lowerView];
        [self assignConstraint:bottomCon withKey:kTopKey toArrangedView:lowerView];
    }
    else
        bottomCon = [subviewHolder sdc_alignBottomEdgeWithSuperviewMargin:0];
    
    if (fillMode == MyVerticalStackViewFillModeFill)
    {
        NSLayoutConstraint* leftCon = [subviewHolder sdc_alignLeftEdgeWithSuperviewMargin:0];
        NSLayoutConstraint* rightCon = [subviewHolder sdc_alignRightEdgeWithSuperviewMargin:0];
        
        subviewHolder.objectData = [@{kTopKey: topCon, kLeftKey: leftCon, kRightKey: rightCon, kBottomKey: bottomCon} mutableCopy];
    }
    else if (fillMode ==MyVerticalStackViewFillModeLeft)
    {
        NSLayoutConstraint* leftCon = [subviewHolder sdc_alignLeftEdgeWithSuperviewMargin:0];
        
        subviewHolder.objectData = [@{kTopKey: topCon, kLeftKey: leftCon, kBottomKey: bottomCon} mutableCopy];
    }
    else if (fillMode == MyVerticalStackViewFillModeRight)
    {
        NSLayoutConstraint* rightCon = [subviewHolder sdc_alignRightEdgeWithSuperviewMargin:0];
        
        subviewHolder.objectData = [@{kTopKey: topCon, kRightKey: rightCon, kBottomKey: bottomCon} mutableCopy];
    }
    else if (fillMode ==MyVerticalStackViewFillModeCenter)
    {
        NSLayoutConstraint* centerCon = [subviewHolder sdc_horizontallyCenterInSuperview];
        
        subviewHolder.objectData = [@{kTopKey: topCon, kCenterKey: centerCon, kBottomKey: bottomCon} mutableCopy];
    }
    
    if (!upperView) //it's on top of the stackview
    {
        [views insertObject:subviewHolder atIndex:0];
    }
    else if (!lowerView) //it's on bottom of the stackview
    {
        [views addObject:subviewHolder];
    }
    else if (!upperView && !lowerView) //it's the only view
    {
        [views addObject:subviewHolder];
    }
    else //it's something in middle
    {
        [views insertObject:subviewHolder atIndex:[views indexOfObject:upperView]+1];
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
    for (MyStackViewArrangedViewHolder* holder in self.subviews)
    {
        [result addObject:holder.mainView];
    }
    return result;
}

@end
