//
//  UIFont+Extensions.m
//  Pods
//
//  Created by hAmidReza on 8/2/17.
//
//

#import "UIFont+Extensions.h"

@implementation UIFont (Extensions)

-(UIFont*)sameFontScaledSize:(CGFloat)ratio
{
	UIFont* font = [UIFont fontWithName:self.fontName size:ratio*self.pointSize];
	return font;
}

@end
