//
//  UIView+StoryboardSupport.h
//  Palette
//
//  Created by Ali Soume`e on 5/1/1396 AP.
//  Copyright © 1396 Ali-Soume. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (StoryboardSupport)


@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;


@end
