//
//  ColoredUIImageView.m
//  macTehran
//
//  Created by Hamidreza Vaklian on 2/29/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import "ColoredUIImageView.h"
#import "helper.h"

@interface ColoredUIImageView ()
{
    BOOL isInitialized;
}

@end

@implementation ColoredUIImageView

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!isInitialized)
    {
        self.image = [helper filledImageFrom:self.image withColor:self.color];
        isInitialized = true;
    }
}

-(void)setColor:(UIColor *)color
{
	_color = color;
	isInitialized = NO;
	[self setNeedsLayout];
}

@end
