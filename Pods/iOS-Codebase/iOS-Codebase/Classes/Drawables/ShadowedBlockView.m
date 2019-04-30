//
//  ShadowedBlockView.m
//  mactehrannew
//
//  Created by hAmidReza on 6/29/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "ShadowedBlockView.h"
#import "Codebase_definitions.h"
#import "UIView+SDCAutoLayout.h"

@interface ShadowedBlockView ()
{
    NSLayoutConstraint* contentViewTop;
    NSLayoutConstraint* contentViewLeft;
    NSLayoutConstraint* contentViewRight;
    NSLayoutConstraint* contentViewBottom;
}

@property (retain, nonatomic) UIView* shadowView;

@end

@implementation ShadowedBlockView

-(void)initialize
{
    _contentView = [UIView new];
    _contentView.layer.cornerRadius = 3.0f;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.clipsToBounds = YES;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_contentView];
    contentViewTop = [_contentView sdc_alignTopEdgeWithSuperviewMargin:10];
    contentViewLeft = [_contentView sdc_alignLeftEdgeWithSuperviewMargin:20];
    contentViewRight = [_contentView sdc_alignRightEdgeWithSuperviewMargin:20];
    contentViewBottom = [_contentView sdc_alignBottomEdgeWithSuperviewMargin:10];
    //    [_contentView sdc_alignBottomEdgeWithSuperviewMargin:10];
    //    contentViewMaxHeight = [_contentView sdc_setMaximumHeight:500];
    
    _shadowView = [UIView new];
    _shadowView.backgroundColor = [UIColor whiteColor];
    _shadowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:_shadowView belowSubview:_contentView];
    [_shadowView sdc_alignEdges:UIRectEdgeAll withView:_contentView insets:UIEdgeInsetsMake(2, 2, -2, -2)];
    _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(3, 3);
    _shadowView.layer.cornerRadius = 3.0f;
    _shadowView.layer.shadowOpacity = .1;
    _shadowView.layer.shadowRadius = 4;
    _defineDeviceScale;
    _shadowView.layer.rasterizationScale = s;
    _shadowView.layer.shouldRasterize = YES;
}

-(void)setBorderColor:(UIColor *)borderColor
{
    self.contentView.layer.borderColor = borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    self.contentView.layer.borderWidth = borderWidth;
}

-(UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.contentView.layer.borderColor];
}

-(CGFloat)borderWidth
{
    return self.contentView.layer.borderWidth;
}

-(void)setContentViewMargins:(UIEdgeInsets)contentViewMargins
{
    contentViewTop.constant = contentViewMargins.top;
    contentViewLeft.constant = contentViewMargins.left;
    contentViewRight.constant = -contentViewMargins.right;
    contentViewBottom.constant = -contentViewMargins.bottom;
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    _contentView.layer.cornerRadius = cornerRadius;
    _shadowView.layer.cornerRadius = cornerRadius;
}

-(CGFloat)cornerRadius
{
    return _contentView.layer.cornerRadius;
}

-(void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowView.layer.shadowOffset = shadowOffset;
}

-(CGSize)shadowOffset
{
    return _shadowView.layer.shadowOffset;
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity
{
    _shadowView.layer.shadowOpacity = shadowOpacity;
}

-(CGFloat)shadowOpacity
{
    return _shadowView.layer.shadowOpacity;
}

-(void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowView.layer.shadowRadius = shadowRadius;
}

-(CGFloat)shadowRadius
{
    return _shadowView.layer.shadowRadius;
}

@end
