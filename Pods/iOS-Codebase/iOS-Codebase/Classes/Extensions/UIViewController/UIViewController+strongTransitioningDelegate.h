//
//  UIViewController+stringTransitioningDelegate.h
//  mactehrannew
//
//  Created by hAmidReza on 6/3/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (strongTransitioningDelegate)

@property (retain, nonatomic) id<UIViewControllerTransitioningDelegate> strongTransitioningDelegate;

@end
