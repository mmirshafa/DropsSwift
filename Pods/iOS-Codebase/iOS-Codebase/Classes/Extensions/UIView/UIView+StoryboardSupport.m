//
//  UIView+StoryboardSupport.m
//  Palette
//
//  Created by Ali Soume`e on 5/1/1396 AP.
//  Copyright © 1396 Ali-Soume. All rights reserved.
//

#import "UIView+StoryboardSupport.h"

@implementation UIView (StoryboardSupport)



@dynamic borderColor,borderWidth,cornerRadius;
@dynamic shadowColor, shadowOffset, shadowRadius, shadowOpacity;

- (void)setBorderColor: (UIColor *)borderColor {
    [self.layer setBorderColor:borderColor.CGColor];
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}


- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self.layer setCornerRadius:cornerRadius];
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}


- (void)setBorderWidth: (CGFloat)borderWidth {
    [self.layer setBorderWidth:borderWidth];
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}


- (void)setShadowColor:(UIColor *)shadowColor {
    [self.layer setShadowColor:shadowColor.CGColor];
}

- (UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}


- (void)setShadowOffset:(CGSize)shadowOffset {
    [self.layer setShadowOffset:shadowOffset];
}

- (CGSize)shadowOffset {
    return self.layer.shadowOffset;
}


- (void)setShadowRadius:(CGFloat)shadowRadius {
    [self.layer setShadowRadius:shadowRadius];
}

- (CGFloat)shadowRadius {
    return self.layer.shadowRadius;
}


- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    [self.layer setShadowOpacity:shadowOpacity];
}

- (CGFloat)shadowOpacity {
    return self.layer.shadowOpacity;
}




@end
