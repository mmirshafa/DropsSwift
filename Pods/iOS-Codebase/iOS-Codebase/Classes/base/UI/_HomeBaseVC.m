//
//  _HomeBaseVC.m
//  mactehrannew
//
//  Created by hAmidReza on 4/30/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_HomeBaseVC.h"
#import "myLoadingView.h"
#import "Codebase.h"
#import "Codebase_definitions.h"
#import "helper.h"

#define kAnimationsDuration .3

@interface _HomeBaseVC_View : _viewBase
{
    UIView* contentView;
}

-(void)_addSubview:(UIView*)view;

@end

@implementation _HomeBaseVC_View

-(void)initialize
{
    contentView = [UIView new];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [super addSubview:contentView];
}

-(void)addSubview:(UIView *)view
{
    [contentView addSubview:view];
    //    [self sendSubviewToBack:contentView];
}

-(void)_addSubview:(UIView*)view
{
    [super addSubview:view];
}
@end

@interface _HomeBaseVC ()
{
    UIView* loadingView;
    UIView* generalErrorView;
    NSLayoutConstraint* visualEffectViewHeightCon;
}

@property (weak, nonatomic) MyShapeButton* backButton;
@property (weak, nonatomic) MyShapeButton* rightBarButton;

@property (retain, nonatomic) myLoadingView* loadingIndicator;
@end

@implementation _HomeBaseVC


-(void)loadView
{
    _HomeBaseVC_View* view = [_HomeBaseVC_View new];
    self.view = view;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    [self _initialize];
    return self;
}

-(void)_initialize
{
    _hideVisualEffectViewOnLoading = YES;
    _ifErrorCallBackDontShowErrorView = false;
    [self initialize];
}

-(void)initialize
{
    
}

-(UIVisualEffect*)effectForVisualEffectView
{
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert(self.navigationController, @"_HomeBaseVC: navigationController is nil. Are you calling configureWithDictionary before pushing or presenting this view controller?!?");
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIVisualEffect* effect = [self effectForVisualEffectView];
    if (!effect)
    effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    _visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    _HomeBaseVC_View* v = (_HomeBaseVC_View*)self.view;
    [v _addSubview:_visualEffectView];
    [_visualEffectView sdc_alignEdgesWithSuperview:UIRectEdgeAll ^ UIRectEdgeBottom];
    visualEffectViewHeightCon = [_visualEffectView sdc_pinHeight:[self NavBarBackDropViewHeight]];
    
    if ([self hasRightBarButton])
    {
        _defineWeakSelf;
        UIBarButtonItem* item = [helper shapeBarButtonWithConf:^(MyShapeButton *button) {
            weakSelf.rightBarButton = button;
            [weakSelf customizeRightBarButton:button];
        } andCallback:^{
            [weakSelf rightBarButtonTouch];
        }];
        
        if ([self reserveSpaceForRightNavBarItem])
        {
            UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self navBarRightItemRightMargin], 30)];
            UIBarButtonItem* rightSpacer = [[UIBarButtonItem alloc] initWithCustomView:v];
            
            self.navigationItem.rightBarButtonItems = @[rightSpacer, item];
        }
        else
        {
            if (@available(iOS 11.0, *)) {
                self.navigationItem.rightBarButtonItems = @[item];
            } else {
                UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                   target:nil action:nil];
                negativeSpacer.width = -16;
                self.navigationItem.rightBarButtonItems = @[negativeSpacer, item];
            }
            
        }
        
    }
    
    //
    if ( ([self.navigationController.viewControllers indexOfObject:self] > 0)  || self.forceShowBackButton)
    {
        _defineWeakSelf;
        UIBarButtonItem* item = [helper shapeBarButtonWithConf:^(MyShapeButton *button) {
            weakSelf.backButton = button;
            button.shapeView.shapeDesc = [weakSelf backButtonShapeDesc];
            button.shapeMargins = [weakSelf backButtonShapeMargins];
            [weakSelf customizeBackButton:button];
        } andCallback:^{
            [weakSelf backButtonTouch];
        }];
        
        if ([self reserveSpaceForLeftNavBarItem])
        {
            UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self navBarLeftItemLeftMargin], 30)];
            UIBarButtonItem* leftSpacer = [[UIBarButtonItem alloc] initWithCustomView:v];
            
            self.navigationItem.leftBarButtonItems = @[leftSpacer, item];
        }
        else
        {
            if (@available(iOS 11.0, *)) {
                self.navigationItem.leftBarButtonItems = @[item];
            } else {
                UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                   target:nil action:nil];
                negativeSpacer.width = -16;
                self.navigationItem.leftBarButtonItems = @[negativeSpacer, item];
            }
            
        }
    }
    
    //fixing a bug that caused to appear ... dots when panning back
    UIBarButtonItem *backButton2 = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object: nil];
}

-(BOOL)reserveSpaceForRightNavBarItem
{
    if (self.overriddenReserveSpaceForRightNavBarItem)
    return [self.overriddenReserveSpaceForRightNavBarItem boolValue];
    
    return true;
}

-(CGFloat)navBarRightItemRightMargin
{
    return 5.0;
}

-(void)rightBarButtonTouch
{
    
}

-(void)customizeRightBarButton:(MyShapeButton*)button
{
    
}

-(BOOL)hasRightBarButton
{
    return false;
}

-(CGFloat)navBarLeftItemLeftMargin
{
    return 5.0;
}

-(UIEdgeInsets)backButtonShapeMargins
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

-(NSArray*)backButtonShapeDesc
{
    if (self.overriddenBackButtonShapeDesc)
    return self.overriddenBackButtonShapeDesc;
    else
    return k_iconLeftArrow();
}

-(void)setOverriddenBackButtonShapeDesc:(NSArray *)overriddenBackButtonShapeDesc
{
    _overriddenBackButtonShapeDesc = overriddenBackButtonShapeDesc;
    self.backButton.shapeView.shapeDesc = overriddenBackButtonShapeDesc;
}

-(void)backButtonTouch
{
    if (self.backButtonTouchCallBack)
    self.backButtonTouchCallBack();
    else
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)customizeBackButton:(MyShapeButton*)button
{
    
}



-(void)setOverridenNavBarBackDropHeight:(NSNumber*)overriddenNavBarBackDropHeight
{
    _overriddenNavBarBackDropHeight = overriddenNavBarBackDropHeight;
    [self updateNavBarBackDropView:NO];
}

-(BOOL)reserveSpaceForLeftNavBarItem
{
    if (self.overriddenReserveSpaceForLeftNavBarItem)
    return [self.overriddenReserveSpaceForLeftNavBarItem boolValue];
    
    return true;
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //    [self updateNavBarBackDropView:YES];
}

static UIView* (^loadingViewProviderBlock)(UIView* superview);
+(void)setLoadingViewProviderBlock:(UIView* (^)(UIView* superview))_loadingViewProviderBlock;
{
    loadingViewProviderBlock = _loadingViewProviderBlock;
}

static UIView* (^generalErrorViewProviderBlock)(UIView* superview, _HomeBaseVC* theInstance);
+(void)setGeneralErrorViewProviderBlock:(UIView* (^)(UIView* superview, _HomeBaseVC* theInstance))_generalErrorViewProviderBlock
{
    generalErrorViewProviderBlock = _generalErrorViewProviderBlock;
}

-(UIView*)theLoadingView
{
    UIView* loadingView = [UIView new];
    loadingView.alpha = 0;
    loadingView.backgroundColor = _loadingViewBackgroundColor ? _loadingViewBackgroundColor : [UIColor whiteColor];
    [loadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view insertSubview:loadingView belowSubview:_visualEffectView];
    [loadingView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    return loadingView;
}

-(void)showPageLoadingAnimated:(BOOL)animated completion:(void(^)())completion
{
    if (!loadingView)
    {
        if (_hideVisualEffectViewOnLoading)
        _visualEffectView.alpha = 0;
        
        //        self.navigationController.navigationBar.alpha = 0;
        if (_hideNavBarOnLoading)
        [self.navigationController setNavigationBarHidden:YES];
        
        loadingView = [self theLoadingView];
        [self.view insertSubview:loadingView belowSubview:_visualEffectView];
        
        if (_putGradientWhenLoading)
        {
            GradientView* gradView = [GradientView new];
            gradView.colors = _loadingGradientColors ? _loadingGradientColors : @[rgba(0, 0, 0, .5), rgba(0, 0, 0, 0)];
            gradView.translatesAutoresizingMaskIntoConstraints = NO;
            [loadingView addSubview:gradView];
            [gradView sdc_alignSideEdgesWithSuperviewInset:0];
            [gradView sdc_alignTopEdgeWithSuperviewMargin:0];
            [gradView sdc_pinHeight:_loadingGradientHeight ? [_loadingGradientHeight floatValue] : 80];
        }
        
        if (_customLoadingViewProviderBlock)
        {
            loadingView.backgroundColor = [UIColor clearColor];
            _customLoadingViewProviderBlock(loadingView);
        }
        else if (loadingViewProviderBlock)
        {
            loadingView.backgroundColor = [UIColor clearColor];
            loadingViewProviderBlock(loadingView);
            
        }
        else
        
        {
            self.loadingIndicator = [[myLoadingView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
            if (_loadingViewColor)
            self.loadingIndicator.color = _loadingViewColor;
            [self.loadingIndicator startAnimating];
            [self.loadingIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
            [loadingView addSubview:self.loadingIndicator];
            [self.loadingIndicator sdc_centerInSuperviewWithOffset:[self loadingIndicatorOffset]];
            [self.loadingIndicator sdc_pinSize:CGSizeMake(37, 37)];
        }
    }
    
    if (animated)
    {
        //        loadingView.alpha = 0;
        
        if (_hideNavBarOnLoading)
        [self.navigationController setNavigationBarHidden:YES];
        [UIView animateWithDuration:kAnimationsDuration animations:^{
            loadingView.alpha = 1;
            
            if (_hideVisualEffectViewOnLoading)
            _visualEffectView.alpha = 0;
        } completion:^(BOOL finished) {
            if (completion)
            completion();
        }];
    }
    else
    {
        loadingView.alpha = 1;
        
        if (completion)
        completion();
    }
}

-(UIOffset)loadingIndicatorOffset
{
    return UIOffsetZero;
}

-(void)hidePageLoadingAnimated:(BOOL)animated completion:(void(^)())completion
{
    [self.navigationController setNavigationBarHidden:NO];
    [UIView animateWithDuration:animated ? kAnimationsDuration : 0 animations:^{
        loadingView.alpha = 0;
        _visualEffectView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [loadingView removeFromSuperview];
            loadingView = nil;
            if (completion)
            completion();
        }
    }];
}

-(void)showGeneralErrorAnimted:(BOOL)animated completion:(void(^)())completion
{
    if (!generalErrorView)
    {
        generalErrorView = [UIView new];
        generalErrorView.backgroundColor = [UIColor whiteColor];
        generalErrorView.translatesAutoresizingMaskIntoConstraints = NO;
        [loadingView addSubview:generalErrorView];
        [generalErrorView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
        
        if (generalErrorViewProviderBlock)
        {
            generalErrorViewProviderBlock(generalErrorView, self);
        }
        else
        {
            
            UIView* innerContent = [UIView new];
            innerContent.translatesAutoresizingMaskIntoConstraints = NO;
            [generalErrorView addSubview:innerContent];
            [innerContent sdc_alignSideEdgesWithSuperviewInset:0];
            [innerContent sdc_verticallyCenterInSuperview];
            
            MyShapeView* shapeView = [[MyShapeView alloc] initWithShapeDesc:k_iconExclam() andShapeTintColor:[UIColor lightGrayColor]];
            shapeView.translatesAutoresizingMaskIntoConstraints = NO;
            [innerContent addSubview:shapeView];
            [shapeView sdc_pinSize:CGSizeMake(70, 70)];
            [shapeView sdc_alignEdgesWithSuperview:UIRectEdgeTop];
            [shapeView sdc_horizontallyCenterInSuperview];
            
            UILabel* messageLabel = [UILabel new];
            messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
            messageLabel.text = _str(@"Error");
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
            messageLabel.textColor = [UIColor grayColor];
            [innerContent addSubview:messageLabel];
            [messageLabel sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:shapeView inset:10];
            [messageLabel sdc_horizontallyCenterInSuperview];
            
            _defineWeakSelf;
            
            MyShapeButton* retryButton = [[MyShapeButton alloc] initWithShapeDesc:k_iconRetry() andShapeTintColor:[UIColor grayColor] andButtonClick:^{
                [weakSelf reload];
            }];
            retryButton.shapeMargins = UIEdgeInsetsMake(12, 12, 12, 12);
            retryButton.translatesAutoresizingMaskIntoConstraints = NO;
            [innerContent addSubview:retryButton];
            [retryButton sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:messageLabel inset:10];
            [retryButton sdc_horizontallyCenterInSuperview];
            [retryButton sdc_pinSize:CGSizeMake(50, 50)];
            [retryButton sdc_alignEdgesWithSuperview:UIRectEdgeBottom];
            
        }
    }
    
    
    if (animated)
    {
        generalErrorView.alpha = 0;
        [UIView animateWithDuration:kAnimationsDuration animations:^{
            generalErrorView.alpha = 1;
        } completion:^(BOOL finished) {
            if (completion)
            completion();
        }];
    }
    else
    {
        if (completion)
        completion();
    }
}

-(void)hideGeneralErrorAnimated:(BOOL)animated completion:(void(^)())completion
{
    if (animated)
    {
        
        [UIView animateWithDuration:animated ? kAnimationsDuration : 0 animations:^{
            generalErrorView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished)
            {
                [generalErrorView removeFromSuperview];
                generalErrorView = nil;
                if (completion)
                completion();
            }
        }];
    }
    else
    {
        [generalErrorView removeFromSuperview];
        generalErrorView = nil;
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateNavBarBackDropView:NO];
}

-(void)updateNavBarBackDropView:(bool)animated
{
    if (animated)
    [self.view layoutIfNeeded];
    visualEffectViewHeightCon.constant = [self NavBarBackDropViewHeight];
    
    
    if (animated)
    [UIView animateWithDuration:kAnimationsDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.loadingIndicator stopAnimating];
    [self.loadingIndicator startAnimating];
    [self.view bringSubviewToFront:_visualEffectView];
    [self.view propagateViewWillAppearInSubviewsAnimated:animated];
}

-(CGFloat)NavBarBackDropViewHeight
{
    if (self.overriddenNavBarBackDropHeight)
    return [self.overriddenNavBarBackDropHeight floatValue];
    
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return _statusBarHeight + 44 - _rootVCPushDownValue;
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        return 44;
    }
    
    return 64;
}

-(void)reload
{
    NSAssert(false, @"you didn't override reload method [_homebasevc.m]");
}

-(void)_reloadPath:(NSString*)path callback:(void (^)(id json))callback andError:(void (^)(NSError * err))errorCallback
{
    _reloadDone = NO;
    
    if (!_noPageLoading)
    {
        [self hideGeneralErrorAnimated:NO completion:nil];
        [self showPageLoadingAnimated:NO completion:nil];
    }
    
    [[helper_connectivity serverGetWithPath:path completionHandler:^(long response_code, id obj) {
        
        if (response_code == 200)
        {
            if (!_noPageLoading)
            {
                if (!_manuallyHideLoadingViewOnSuccessfulReload)
                _mainThread(^{
                    [self hidePageLoadingAnimated:YES completion:nil];
                });
            }
            _reloadDone = YES;
            callback(obj);
        }
        else
        {
            if (errorCallback)
            {
                errorCallback(obj);
                
            }
            
            if (!errorCallback || (errorCallback && !_ifErrorCallBackDontShowErrorView))
            {
                if (!_noPageLoading)
                {
                    _mainThread(^{
                        [self showGeneralErrorAnimted:YES completion:nil];
                    });
                }
            }
        }
        
    }] resume];
}


//-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
////    NSLog(@"%@", NSStringFromCGSize(size));
//
//    [self updateNavBarBackDropView:YES];
//
//}

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

