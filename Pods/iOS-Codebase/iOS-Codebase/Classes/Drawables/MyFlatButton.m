//
//  MyBoredredFlatButton.m
//  mactehrannew
//
//  Created by hAmidReza on 5/29/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "MyFlatButton.h"
#import "UIView+SDCAutoLayout.h"
#import "Codebase_definitions.h"

@interface MyFlatButton ()

@property (retain, nonatomic) UILabel* theTitleLabel;

@end

@implementation MyFlatButton

-(void)setEnabled:(BOOL)enabled
{
    [self setEnabled:enabled animated:NO];
}

-(void)setEnabled:(BOOL)enabled animated:(BOOL)animated
{
    super.enabled = enabled;
    
    [UIView animateWithDuration:animated ? .3 : 0 animations:^{
        
        
        if (_num_ok1(_disabled_alpha))
            self.alpha = enabled ? 1.0 : [_disabled_alpha floatValue];
        else
            self.alpha = enabled ? 1.0 : .6;
    }];
    self.userInteractionEnabled = enabled;
}

//-(UILabel *)titleLabel
//{
//    NSAssert(false, @"MyFlatbutton: USE theTitleLabel instead of titleLabel");
//    return nil;
//}

-(void)initialize
{
    self.exclusiveTouch = YES;
    
    _theTitleLabel = [UILabel new];
    _theTitleLabel.textAlignment = NSTextAlignmentCenter;
    _theTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_theTitleLabel];
    [_theTitleLabel sdc_verticallyCenterInSuperview];
    [UIView sdc_priority:950 block:^{
        [_theTitleLabel sdc_alignSideEdgesWithSuperviewInset:20];
    }];
    
    self.layer.cornerRadius = 3;
    self.layer.borderColor = RGBAColor(140, 140, 140, 1).CGColor;
    self.layer.borderWidth = 1;
}

-(void)setTitleVerticalOffset:(CGFloat)titleVerticalOffset
{
    [_theTitleLabel sdc_get_verticalCenter].constant = titleVerticalOffset;
}

-(CGFloat)titleVerticalOffset
{
    return [_theTitleLabel sdc_get_verticalCenter].constant;
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _theTitleLabel.textColor = textColor;
}

-(void)setFont:(UIFont *)font
{
    _font = font;
    _theTitleLabel.font = font;
}

-(void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = [borderColor CGColor];
}

-(UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

-(CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

-(CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

-(void)setTitleSideMargins:(CGFloat)titleSideMargins
{
    _titleSideMargins = titleSideMargins;
    [_theTitleLabel sdc_get_leadingOrLeft].constant = titleSideMargins;
    [_theTitleLabel sdc_get_trailingOrRight].constant = -titleSideMargins;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    _theTitleLabel.text = title;
}
-(void)setButtonClick:(void (^)())buttonClick
{
    
    _buttonClick = buttonClick;
    if (buttonClick)
        [self addTarget:self action:@selector(selfTap:) forControlEvents:UIControlEventTouchUpInside];
    else
        [self removeTarget:self action:@selector(selfTap:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)selfTap:(id)sender
{
    _buttonClick();
}

@end
