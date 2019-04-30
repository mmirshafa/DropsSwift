//
//  _myModalDialog.m
//  Kababchi
//
//  Created by hAmidReza on 6/9/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "_myModalDialog.h"
#import "_myModalDialogTransition.h"
#import "UIViewController+strongTransitioningDelegate.h"
#import "UIView+SDCAutoLayout.h"
#import "_loadingEnabledView.h"
#import "UIView+Extensions.h"
#import "MATTextField.h"

@interface _myModalDialog ()
{
    NSLayoutConstraint* contentViewHeightCon;
}

@property (retain, nonatomic) UIScrollView* scrollView;
@property (retain, nonatomic) UIView* scrollViewContent;
@end

@implementation _myModalDialog

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initialize];
    }
    return self;
}

-(void)_initialize
{
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_visualEffectView];
    [_visualEffectView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    
    _dimView = [UIView new];
    _dimView.userInteractionEnabled = NO;
    _dimView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_dimView];
    [_dimView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    
    _scrollView = [UIScrollView new];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_scrollView];
    [_scrollView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    
    _scrollViewContent = [UIView new];
    _scrollViewContent.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_scrollViewContent];
    [_scrollViewContent sdc_pinWidthToWidthOfView:self.view];
    NSLayoutConstraint* con = [NSLayoutConstraint constraintWithItem:_scrollViewContent attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    con.priority = 900;
    [self.view addConstraint:con];
    contentViewHeightCon = con;
    [_scrollViewContent sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    
    _scrollViewYCentered = [UIView new];
    //    _scrollViewYCentered.backgroundColor = RGBAColor(255, 255, 255, .1);
    _scrollViewYCentered.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollViewContent addSubview:_scrollViewYCentered];
    [_scrollViewYCentered sdc_horizontallyCenterInSuperview];
    //    [_scrollViewYCentered sdc_pinHeightToHeightOfView:_scrollViewContent];
    _yCenteredVerticalOffset = [_scrollViewYCentered sdc_verticallyCenterInSuperviewWithOffset:0];
    [_scrollViewYCentered sdc_setMaximumWidth:[self dialogMaxWidth]];
    [UIView sdc_priority:200 block:^{
        [_scrollViewYCentered sdc_pinWidthToWidthOfView:_scrollViewContent offset:[self contentView2DeviceWidthOffset]];
    }];
    
    [UIView sdc_priority:200 block:^{
        [_scrollViewYCentered sdc_alignTopEdgeWithSuperviewMargin:60];
        [_scrollViewYCentered sdc_alignBottomEdgeWithSuperviewMargin:60];
    }];
    
    _contentView = [_loadingEnabledView new];
    //    _contentView.alpha = 0;
    //    _contentView.backgroundColor = [UIColor yellowColor];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollViewYCentered addSubview:_contentView];
    [_contentView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    //    [_contentView sdc_pinHeight:300];
    
    _myShadowView = [MyShadowView new];
    _myShadowView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollViewYCentered insertSubview:_myShadowView belowSubview:_contentView];
    [_myShadowView sdc_alignEdges:UIRectEdgeAll withView:_contentView];
    
    [self configKeyboardEvents];
    
    UITapGestureRecognizer* tapgest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
    [self.view addGestureRecognizer:tapgest];
    
    self.strongTransitioningDelegate = [_myModalDialogTransition new];
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    
    [self initialize];
}

-(CGFloat)dialogMaxWidth
{
    return 330;
}

-(void)setContentViewCornerRadius:(CGFloat)contentViewCornerRadius
{
    _contentViewCornerRadius = contentViewCornerRadius;
    _myShadowView.cornerRadius = contentViewCornerRadius;
    _contentView.layer.cornerRadius = contentViewCornerRadius;
}

-(CGFloat)contentView2DeviceWidthOffset
{
    return -80.0f;
}

-(void)initialize
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)selfTap:(id)sender
{
    [self.view endEditing:YES];
}

-(void)configKeyboardEvents
{
    //    if ([self respondsToSelector:@selector(keyboardWasShown:)])
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //    if ([self respondsToSelector:@selector(keyboardWillShow:)])
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //    if ([self respondsToSelector:@selector(keyboardDidShow:)])
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //    if ([self respondsToSelector:@selector(keyboardWillBeHidden:)])
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    if (_keyboardIsUp)
        return;
    
    //    [self disableDismissalTap];
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    contentViewHeightCon.constant = -kbSize.height;
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    if (_importantView)
    {
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height; //visible rect height
        
        if (self.scrollView.contentSize.height > aRect.size.height)
        {
            CGRect activeFieldRealRect = [_importantView convertRect:_importantView.bounds toView:self.view];
            activeFieldRealRect = CGRectOffset(activeFieldRealRect, 0, 20);
            if (!CGRectContainsRect(aRect, activeFieldRealRect))
            {
                CGFloat howMuchScrollDown = CGRectGetMaxY(activeFieldRealRect) - CGRectGetMaxY(aRect);
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
                [UIView setAnimationCurve:[info[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
                [UIView setAnimationBeginsFromCurrentState:YES];
                
                [self.scrollView setContentOffset:CGPointMake(0, howMuchScrollDown)];
                
                [UIView commitAnimations];
                
            }
        }
    }
    _keyboardIsUp = YES;
}

-(void)keyboardDidShow:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    //    self.scrollView.contentInset = contentInsets;
    //    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    //    contentViewHeightCon.constant = -kbSize.height;
    
    
    UIView* focusedView = [self.view findFirstResponder];
    
    
    if (focusedView)
    {
        
        CGRect aRect = self.scrollView.frame;
        aRect.size.height -= kbSize.height; //visible rect height
        
        
        if ([focusedView conformsToProtocol:@protocol(_MATTextField_FieldAndViewSharedProtocol)])
        {
            NSObject<_MATTextField_FieldAndViewSharedProtocol>* f = (NSObject<_MATTextField_FieldAndViewSharedProtocol>*)focusedView;
            focusedView = [f mainView];
        }
        
        CGRect rrr = [focusedView convertRect:focusedView.bounds toView:self.scrollView];
        //        NSLog(@" rrrr: %@", NSStringFromCGRect(rrr));
        rrr.origin.y -= self.scrollView.contentOffset.y;
        
        //        rrr.size.height += 20;
        
        if (!CGRectContainsRect(aRect, rrr))
        {
            //            CGRect activeFieldRealRect = [_importantView convertRect:_importantView.bounds toView:self.view];
            //            activeFieldRealRect = CGRectOffset(activeFieldRealRect, 0, 20);
            //            if (!CGRectContainsRect(aRect, activeFieldRealRect))
            //            {
            CGFloat howMuchScrollDown = CGRectGetMaxY(rrr) - CGRectGetMaxY(aRect);
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
            [UIView setAnimationCurve:[info[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
            [UIView setAnimationBeginsFromCurrentState:YES];
            
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + howMuchScrollDown)];
            
            [UIView commitAnimations];
            
            //            }
        }
        
    }
    
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    _keyboardIsUp = NO;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    contentViewHeightCon.constant = 0;
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //    [self enableDismissalTap];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

