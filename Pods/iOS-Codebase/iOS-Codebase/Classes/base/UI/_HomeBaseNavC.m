//
//  _HomeBaseNavC.m
//  Kababchi
//
//  Created by hAmidReza on 7/20/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "_HomeBaseNavC.h"
#import "_HomeBaseNavBar.h"
#import "Codebase_definitions.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "UIView+Extensions.h"

typedef NS_OPTIONS(NSUInteger, ObservationType) {
    ObservationTypeNone   = 0,
    ObservationTypePop    = 1 << 0,
    ObservationTypePush   = 1 << 1,
};

@interface _HomeBaseNavC () <UINavigationControllerDelegate>
{
    float lastProgress;
}

@property (retain, nonatomic) CADisplayLink* link;
@property (retain, nonatomic) UIView* targetContainerView;
@property (assign, nonatomic) ObservationType transitionType;

@end

@implementation _HomeBaseNavC

-(instancetype)init
{
    self = [super initWithNavigationBarClass:[_HomeBaseNavBar class] toolbarClass:[UIToolbar class]];
    if (self)
    {
        self.delegate = self;
    }
    return self;
}

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
	self = [super initWithNavigationBarClass:[_HomeBaseNavBar class] toolbarClass:[UIToolbar class]];
	if (self)
	{
		self.delegate = self;
		self.viewControllers = @[rootViewController];
	}
	return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**************************** UINavigationController Transitions Progress Monitor ****************************/

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if ([self shouldObserveTransition])
        [self observeVC:viewController type:ObservationTypePush animated:animated];
}

-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray* result = [super popToRootViewControllerAnimated:animated];
    if ([self shouldObserveTransition])
        [self observeVC:[result lastObject] type:ObservationTypePop animated:animated];
    return result;
}

-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray* result = [super popToViewController:viewController animated:animated];
    if ([self shouldObserveTransition])
        [self observeVC:[result lastObject] type:ObservationTypePop animated:animated];
    return result;
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController* vc = [super popViewControllerAnimated:animated];
    if ([self shouldObserveTransition])
        [self observeVC:vc type:ObservationTypePop animated:animated];
    return vc;
}
////////////////////////////////////////////////////////////////////////////////

-(void)observeVC:(UIViewController*)vc type:(ObservationType)type animated:(BOOL)animated
{
    if (!vc)
        return;
    
    if (animated)
    {
        _defineWeakSelf;
        [[vc.view rac_signalForSelector:@selector(didMoveToSuperview)] subscribeNext:^(RACTuple * _Nullable x) {
            UIView* possibleView = [vc.view getNearestParentViewByClass:@"_UIParallaxDimmingView"];
            if (possibleView)
            {
                weakSelf.targetContainerView = possibleView.superview;
            }
        }];
        
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    else
    {
        if (type == ObservationTypePop)
            [self animatedPopVCProgress:1.0f];
        else if (type == ObservationTypePush)
            [self animatedPushVCProgress:1.0f];
    }
    
    
    self.transitionType = type;
}

-(void)displayLinkTick:(id)sender
{
    CGPoint current_pos = self.targetContainerView.layer.presentationLayer.position;
    
    float progress = fabs((current_pos.x - _deviceWidth / 2.0f) / _deviceWidth);
    
    if (lastProgress != progress)
    {
        if (self.transitionType == ObservationTypePop)
            [self animatedPopVCProgress:progress];
        else if (self.transitionType == ObservationTypePush)
            [self animatedPushVCProgress:1.0f - progress];
        
        lastProgress = progress;
    }
}

-(void)animatedPopVCProgress:(float)progress
{
    
}

-(void)animatedPushVCProgress:(float)progress
{

}

-(BOOL)shouldObserveTransition
{
    return false;
}

//*********************************************************************************************

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self shouldObserveTransition])
    {
        id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
        
        [tc animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if (self.link)
            {
                [self.link invalidate];
                self.link = nil;
            }
        }];
    }
}
@end
