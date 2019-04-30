//
//  MyShapeButtonLayer.m
//  Aiywa2
//
//  Created by hAmidReza on 2/12/17.
//  Copyright © 2017 nizek. All rights reserved.
//

#import "MyShapeButtonLayer.h"

@implementation MyShapeButtonLayer

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    if ([_buttonDelegate respondsToSelector:@selector(MyShapeButtonLayerShouldOverrideSetCornerRadius)])
    {
	if ([_buttonDelegate respondsToSelector:@selector(MyShapeButtonLayerSetCornerRadius:)] && [_buttonDelegate MyShapeButtonLayerShouldOverrideSetCornerRadius])
		[_buttonDelegate MyShapeButtonLayerSetCornerRadius:cornerRadius];
	else
		[super setCornerRadius:cornerRadius];
    }
    else
        [super setCornerRadius:cornerRadius];
}

@end
