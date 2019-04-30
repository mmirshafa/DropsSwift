//
//  myLoadingView.h
//  macTehranLoadingTest
//
//  Created by Hamidreza Vaklian on 4/14/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myLoadingView : UIView


/**
 default 1.0f
 */
@property (assign, nonatomic) IBInspectable CGFloat durationFactor;
@property (assign, nonatomic) IBInspectable UIColor* color;
@property (assign, nonatomic) BOOL onlyOneCircle;
-(void)startAnimating;
-(void)stopAnimating;

@end

