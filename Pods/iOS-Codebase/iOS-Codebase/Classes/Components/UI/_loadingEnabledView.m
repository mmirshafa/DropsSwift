//
//  _loadingEnabledView.m
//  mactehrannew
//
//  Created by hAmidReza on 5/28/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_loadingEnabledView.h"
#import "myLoadingView.h"
#import "Codebase.h"

@interface _loadingEnabledView ()
{
    CGRect loadingViewRectOnShow;
}

@property (retain, nonatomic) myLoadingView* loadingView;
@property (retain, nonatomic) UIView* loadingOverlay;
@property (retain, nonatomic, readwrite) UIView* contentView;

@end

@implementation _loadingEnabledView

-(void)initialize
{
    
    //    self.backgroundColor = [UIColor yellowColor];
    
    _contentView = [UIView new];
    //    _contentView.backgroundColor = [UIColor greenColor];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [super addSubview:_contentView];
    [_contentView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    
    _loadingOverlay = [UIView new];
    _loadingOverlay.alpha = 0;
    [self setLoadingBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _loadingOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    [super addSubview:_loadingOverlay];
    [_loadingOverlay sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    
    _loadingView = [[myLoadingView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _loadingView.alpha = 0;
    [super addSubview:_loadingView];
    
    _loadingSize = 20;
    
    _loadingView.frame = CGRectMake(0, 0, 20, 20);
    
    _maintainLoadingViewFrame = YES;
}

-(void)setLoadingSize:(CGFloat)loadingSize
{
    _loadingSize = loadingSize;
    _loadingView.frame = CGRectMake(_loadingView.frame.origin.x, _loadingView.frame.origin.y, _loadingSize, _loadingSize);
}

-(void)setLoadingViewColor:(UIColor *)loadingViewColor
{
    _loadingView.color = loadingViewColor;
}

-(UIColor *)loadingViewColor
{
    return _loadingView.color;
}

-(void)setLoadingBackgroundColor:(UIColor *)loadingBackgroundColor
{
    _loadingOverlay.backgroundColor = loadingBackgroundColor;
}

-(UIColor *)loadingBackgroundColor
{
    return _loadingOverlay.backgroundColor;
}

-(void)addSubview:(UIView *)view
{
    [_contentView addSubview:view];
}

//-(NSArray<UIView *> *)subviews
//{
//    return self.contentView.subviews;
//}
//
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_isLoading && _maintainLoadingViewFrame)
    {
        _loadingView.frame = CGRectMake((self.frame.size.width - _loadingSize) / 2.0f, loadingViewRectOnShow.origin.y, _loadingSize, _loadingSize);
    }
}

-(void)showLoading
{
    [self layoutIfNeeded];
    
    _loadingView.frame = CGRectMake((self.frame.size.width - _loadingSize) / 2.0f, (self.frame.size.height - _loadingSize) / 2.0f, _loadingSize, _loadingSize);
    
    loadingViewRectOnShow = _loadingView.frame;
    
    _isLoading = YES;
    [UIView animateWithDuration:.3 animations:^{
        
        if (_mode == _loadingEnabledViewModeHideContentViewCompletely)
        {
            _contentView.alpha = 0;
            _loadingView.alpha = 1.0f;
            [_loadingView startAnimating];
        }
        else if (_mode == _loadingEnabledViewModeOverlayLoading)
        {
            _loadingOverlay.alpha = _loadingOverlayAlpha;
            _loadingView.alpha = 1.0f;
            [_loadingView startAnimating];
        }
    }];
}

-(void)hideLoading
{
    [self hideLoadingCompletion:nil];
}

-(void)hideLoadingCompletion:(void(^)())completion
{
    [UIView animateWithDuration:.3 animations:^{
        _contentView.alpha = 1;
        _loadingOverlay.alpha = 0;
        _loadingView.alpha = 0.f;
    } completion:^(BOOL finished) {
        _isLoading = NO;
        [_loadingView stopAnimating];
        if (completion)
            completion();
    }];
}


@end
