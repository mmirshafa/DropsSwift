//
//  pp.m
//  Kababchi
//
//  Created by hAmidReza on 6/6/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "UIView+UIAppearanceSupportedView.h"
#import "NSObject+Runtime.h"

@implementation  UIView (UIAppearanceSupportedView)

+(instancetype)_appearance
{
	static BOOL appearanceDirty = false;
	if (!appearanceDirty)
	{
		appearanceDirty = YES;
		dispatch_async(dispatch_get_main_queue(), ^{
			NSArray *windows = [UIApplication sharedApplication].windows;
			for (UIWindow *window in windows) {
				for (UIView *view in window.subviews) {
					[view removeFromSuperview];
					[window addSubview:view];
				}
			}
		});
	}
	return [self _appearance];
}

+(void)load
{
	[UIView swizzleClassMethod:@selector(appearance) withMethod:@selector(_appearance)];
	[super load];
}

@end
