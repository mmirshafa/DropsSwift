//
//  HorizontalLine.m
//  macTehran
//
//  Created by Hamidreza Vaklian on 1/29/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import "HorizontalLine.h"
#import "helper.h"
#import "Codebase_definitions.h"

@interface HorizontalLine()
{
    BOOL isInitialized;
}
@end

@implementation HorizontalLine

-(void)layoutSubviews
{
    if (!isInitialized)
    {
        for (NSLayoutConstraint* aCon in self.constraints) {
            if (aCon.firstItem == self && aCon.secondItem == nil && aCon.firstAttribute == NSLayoutAttributeHeight && aCon.secondAttribute == NSLayoutAttributeNotAnAttribute)
                aCon.constant = _1pixel;
        }
        isInitialized  = true;
    }
    
    [super layoutSubviews];
}

@end
