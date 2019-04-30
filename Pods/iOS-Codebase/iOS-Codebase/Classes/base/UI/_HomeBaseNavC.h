//
//  _HomeBaseNavC.h
//  Kababchi
//
//  Created by hAmidReza on 7/20/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _HomeBaseNavC : UINavigationController

-(void)animatedPopVCProgress:(float)progress;
-(void)animatedPushVCProgress:(float)progress;
-(BOOL)shouldObserveTransition;

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
