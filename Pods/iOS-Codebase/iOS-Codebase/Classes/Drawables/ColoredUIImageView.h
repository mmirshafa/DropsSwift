//
//  ColoredUIImageView.h
//  macTehran
//
//  Created by Hamidreza Vaklian on 2/29/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface ColoredUIImageView : UIImageView

@property (retain, nonatomic) IBInspectable UIColor* color;

@end
