//
//  _HomeBaseVC.h
//  mactehrannew
//
//  Created by hAmidReza on 4/30/17.
//  Copyright © 2017 archibits. All rights reserved.
// salam chetori

#import <UIKit/UIKit.h>

@class MyShapeButton;

@interface _HomeBaseVC : UIViewController <UIAppearance, UIAppearanceContainer>

@property (retain, nonatomic) UIVisualEffectView* visualEffectView;
-(void)updateNavBarBackDropView:(bool)animated;
-(CGFloat)NavBarBackDropViewHeight;
-(void)initialize;
//-(void)startPageLoading;
//-(void)stopPageLoading;
-(void)_reloadPath:(NSString*)path callback:(void (^)(id json))callback andError:(void (^)(NSError * err))errorCallback;
//-(void)showGeneralErrorWithMessage:(NSString*)msg;
//-(void)dismissErrors;
-(void)reload;
-(BOOL)reserveSpaceForLeftNavBarItem;



@property (assign, nonatomic) bool manuallyHideLoadingViewOnSuccessfulReload;
@property (assign, nonatomic) bool noPageLoading;
@property (assign, nonatomic) bool reloadDone;
@property (copy, nonatomic) void (^backButtonTouchCallBack)(void);

@property (retain, nonatomic) NSArray* overriddenBackButtonShapeDesc;

-(UIView*)theLoadingView;

/**
 puts a dark gradient on top, so the navigation items will be visible even during the page loading. default: false.
 */
@property (assign, nonatomic) bool putGradientWhenLoading;

/**
 used if putGradientWhenLoading = true. the gradient height; default: 80
 */
@property (retain, nonatomic) NSNumber* loadingGradientHeight;


/**
 used if putGradientWhenLoading = true. array of uicolors for gradient view on page loading. (from top to bottom). default: @[rgba(0, 0, 0, .5), rgba(0, 0, 0, 0)];
 */
@property (retain, nonatomic) NSArray* loadingGradientColors;


/**
 default: false.
 */
@property (assign, nonatomic) bool hideNavBarOnLoading;

/**
 default: true. it will hide the top header visual effect view during the page loading.
 */
@property (assign, nonatomic) bool hideVisualEffectViewOnLoading;

/**
 when the page loading is shown, sets this backgroundcolor for it. default: white
 */
@property (retain, nonatomic) UIColor* loadingViewBackgroundColor;


/**
 default false;
 */
@property (assign, nonatomic) BOOL forceShowBackButton;

@property (retain, nonatomic) NSNumber* overriddenReserveSpaceForRightNavBarItem;
@property (retain, nonatomic) NSNumber* overriddenReserveSpaceForLeftNavBarItem;

@property (retain, nonatomic) NSNumber* overriddenNavBarBackDropHeight;

/**
 default: NO;
 if true, then if you provide error callback to _reloadpath, the default behavior which shows the general error view won't execute; by default it will both report the error to your callback and also displays the error view;
 */
@property (assign, nonatomic) BOOL ifErrorCallBackDontShowErrorView;
/**
 override this method if you want other visual effects.
 default: [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]
 
 @return the desired visual effect e.g. [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]
 */
-(UIVisualEffect*)effectForVisualEffectView;

/**
 the color of the loading indicator. default: white
 */
@property (retain, nonatomic) UIColor* loadingViewColor;

-(void)hidePageLoadingAnimated:(BOOL)animated completion:(void(^)())completion;
-(void)showPageLoadingAnimated:(BOOL)animated completion:(void(^)())completion;


/**
 custom loading provider per instance
 */
@property (copy, nonatomic) UIView* (^customLoadingViewProviderBlock)(UIView* superview);

+(void)setLoadingViewProviderBlock:(UIView* (^)(UIView* superview))loadingViewProviderBlock;
+(void)setGeneralErrorViewProviderBlock:(UIView* (^)(UIView* superview, _HomeBaseVC* theInstance))_generalErrorViewProviderBlock;
-(void)showGeneralErrorAnimted:(BOOL)animated completion:(void(^)())completion;

-(void)customizeBackButton:(MyShapeButton*)button;

-(void)backButtonTouch;
-(NSArray*)backButtonShapeDesc;
-(UIEdgeInsets)backButtonShapeMargins;

-(CGFloat)navBarLeftItemLeftMargin;

-(BOOL)reserveSpaceForRightNavBarItem;
-(CGFloat)navBarRightItemRightMargin;
-(void)rightBarButtonTouch;
-(void)customizeRightBarButton:(MyShapeButton*)button;
-(BOOL)hasRightBarButton;
-(UIOffset)loadingIndicatorOffset;
@end

