//
//  _FormBaseVC.m
//  mactehrannew
//
//  Created by hAmidReza on 8/2/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_FormBaseVC.h"
#import "_loadingEnabledView.h"
#import "MyShapeButton.h"
#import "UIView+SDCAutoLayout.h"
#import "UIView+Extensions.h"
#import "Codebase_definitions.h"

@interface _FormBaseVC ()
{
	NSLayoutConstraint* contentViewHeightCon;
}

@property (retain, nonatomic) UIScrollView* scrollView;
@property (retain, nonatomic) UIView* scrollViewContent;
@property (retain, nonatomic) UIView* scrollViewYCentered;

@end

@implementation _FormBaseVC


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.leftBarButtonItems = nil;
	
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	self.navigationItem.hidesBackButton = YES;
	
	_scrollView = [UIScrollView new2];
	[self.view addSubview:_scrollView];
	[_scrollView sdc_alignEdgesWithSuperview:UIRectEdgeAll insets:UIEdgeInsetsMake([super NavBarBackDropViewHeight], 0, 0, 0)];
	
	_scrollViewContent = [UIView new];
	_scrollViewContent.translatesAutoresizingMaskIntoConstraints = NO;
	[_scrollView addSubview:_scrollViewContent];
	[_scrollViewContent sdc_pinWidthToWidthOfView:self.view];
//	NSLayoutConstraint* con = [NSLayoutConstraint constraintWithItem:_scrollViewContent attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
//	con.priority = 900;
//	[self.view addConstraint:con];
//	contentViewHeightCon = con;
	[_scrollViewContent sdc_alignEdgesWithSuperview:UIRectEdgeAll];
	
//	_scrollViewYCentered = [UIView new];
//	//	_scrollViewYCentered.backgroundColor = RGBAColor(255, 255, 255, .1);
//	_scrollViewYCentered.translatesAutoresizingMaskIntoConstraints = NO;
//	[_scrollViewContent addSubview:_scrollViewYCentered];
//	[_scrollViewYCentered sdc_horizontallyCenterInSuperview];
//	//	[_scrollViewYCentered sdc_pinHeightToHeightOfView:_scrollViewContent];
//	_yCenteredVerticalOffset = [_scrollViewYCentered sdc_verticallyCenterInSuperviewWithOffset:0];
//	[_scrollViewYCentered sdc_setMaximumWidth:330];
//	[UIView sdc_priority:800 block:^{
//		[_scrollViewYCentered sdc_pinWidth:330];
//	}];
//	[UIView sdc_priority:200 block:^{
//		[_scrollViewYCentered sdc_pinWidthToWidthOfView:_scrollViewContent offset:-80];
//	}];
//	
//	[UIView sdc_priority:200 block:^{
//		[_scrollViewYCentered sdc_alignTopEdgeWithSuperviewMargin:10];
//		[_scrollViewYCentered sdc_alignBottomEdgeWithSuperviewMargin:10];
//	}];
	
	_contents = [_loadingEnabledView new];
//		_contents.backgroundColor = [UIColor groupTableViewBackgroundColor];
	_contents.translatesAutoresizingMaskIntoConstraints = NO;
	[_scrollViewContent addSubview:_contents];
	[_contents sdc_alignSideEdgesWithSuperviewInset:0];
	[_contents sdc_alignTopEdgeWithSuperviewMargin:0];
	[_contents sdc_alignBottomEdgeWithSuperviewMargin:0];
	
		[self configKeyboardEvents];
	
	UITapGestureRecognizer* tapgest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
	[self.view addGestureRecognizer:tapgest];
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.visualEffectView.clipsToBounds = YES;
	
	_visualEffectViewOverlay = [UIView new];
	_visualEffectViewOverlay.backgroundColor = rgba(48, 125, 252, 1.000);
	_visualEffectViewOverlay.translatesAutoresizingMaskIntoConstraints = NO;
	[self.visualEffectView.contentView addSubview:_visualEffectViewOverlay];
	[_visualEffectViewOverlay sdc_alignEdgesWithSuperview:UIRectEdgeAll];
}

-(void)selfTap:(id)sender
{
	[self.view endEditing:YES];
}

-(void)configKeyboardEvents
{
	if ([self respondsToSelector:@selector(keyboardWasShown:)])
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWasShown:)
													 name:UIKeyboardDidShowNotification object:nil];
	
	if ([self respondsToSelector:@selector(keyboardWillShow:)])
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification object:nil];
	
	if ([self respondsToSelector:@selector(keyboardWillBeHidden:)])
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillBeHidden:)
													 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification
{
	NSDictionary* info = [aNotification userInfo];
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
	
	self.scrollView.contentInset = contentInsets;
	self.scrollView.scrollIndicatorInsets = contentInsets;
	
//	contentViewHeightCon.constant = -kbSize.height;
	
	UIView* firstResponderView = [self.view findFirstResponder];
	
	CGRect fieldRect = [firstResponderView convertRect:firstResponderView.bounds toView:self.scrollView];
	CGRect testRect = [firstResponderView convertRect:firstResponderView.bounds toView:self.view];

	fieldRect.origin.y -= 35;
	fieldRect.size.height += 70;
	CGRect aRect = self.scrollView.frame;
	aRect.size.height -= kbSize.height; //visible rect height
	
	testRect.origin.y -= 35;
	testRect.size.height += 70;
	
	if (!CGRectContainsRect(aRect, testRect))
	{
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
			[UIView setAnimationCurve:[info[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
			[UIView setAnimationBeginsFromCurrentState:YES];
			
		[self.scrollView scrollRectToVisible:fieldRect animated:NO];
			[self.view layoutIfNeeded];
			[UIView commitAnimations];
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

-(CGFloat)NavBarBackDropViewHeight
{
	CGFloat result = [super NavBarBackDropViewHeight] + 155;
	[_scrollView sdc_get_top].constant = result;
	return result;
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
	//	[self enableDismissalTap];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
