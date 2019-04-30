//
//  _loadingEnabledView.h
//  mactehrannew
//
//  Created by hAmidReza on 5/28/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_viewBase.h"

typedef enum : NSUInteger {
    _loadingEnabledViewModeHideContentViewCompletely,
    _loadingEnabledViewModeOverlayLoading,
} _loadingEnabledViewMode;

@interface _loadingEnabledView : _viewBase

@property (assign, nonatomic) _loadingEnabledViewMode mode;
@property (retain, nonatomic) UIColor* loadingViewColor; //defaults to white
@property (assign, nonatomic) CGFloat loadingSize; //defaults to 20
@property (assign, nonatomic) CGFloat chert; //defaults to 20

/**
 @brief We use this class to lazy load the the contents of this view. So we showLoading, then we load our stuff and make our view ready, then we call hideLoading. Sometimes in preparing the views, this view will grow, on the other side the loadingView is centered so before it hides it will re-position because the contents are changed. This property is true by default so on any change to the contents of this view during loading, the loadingView will remain in it's position. by setting this value to false it won't maintain it's position in such situation.
 */
@property (assign, nonatomic) BOOL maintainLoadingViewFrame; //defaults to YES
@property (assign, nonatomic, readonly) BOOL isLoading;


//_loadingEnabledViewModeOverlayLoading
@property (retain, nonatomic) UIColor* loadingBackgroundColor;
@property (assign, nonatomic) CGFloat loadingOverlayAlpha;



-(void)showLoading;
-(void)hideLoading;
-(void)hideLoadingCompletion:(void(^)(void))completion;

@property (retain, nonatomic, readonly) UIView* contentView;
@end
