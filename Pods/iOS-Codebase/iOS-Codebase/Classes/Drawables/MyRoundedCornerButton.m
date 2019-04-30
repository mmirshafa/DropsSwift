//
//  DFRoundedCornerButton.m
//  deepfinity
//
//  Created by Hamidreza Vakilian on 10/15/1396 AP.
//  Copyright © 1396 nizek. All rights reserved.
//

#import "MyRoundedCornerButton.h"
#import "MyVector.h"
#import "MyShapeView.h"
#import "UIView+Extensions.h"
#import "UIView+SDCAutoLayout.h"
#import "UIColor+Extensions.h"

@interface MyRoundedCornerButton ()

@property (retain, nonatomic) UIView* innerContent;
@property (retain, nonatomic) UILabel* titleLabel;
@property (retain, nonatomic) MyVector* vector;
@property (retain, nonatomic) MyShapeView* shapeView;

@end

@implementation MyRoundedCornerButton

-(void)initialize
{
    [super initialize];
    
    _fullRoundCorner = true;
    
    _innerContent = [UIView new2];
    _innerContent.userInteractionEnabled = NO;
    [self addSubview:_innerContent];
    [_innerContent sdc_centerInSuperview];
    
    _titleLabel = [UILabel new2];
    _titleLabel.textColor = [UIColor darkGrayColor];
//    _titleLabel.font = [UIFont fontWithName:@"Whitney-Medium" size:14];
    [_innerContent addSubview:_titleLabel];
    [_titleLabel sdc_alignEdgesWithSuperview:UIRectEdgeAll];
}

-(void)setFont:(UIFont *)font
{
    _font = font;
    self.titleLabel.font = font;
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _titleLabel.textColor = textColor;
}

-(void)setIconVectorDesc:(NSDictionary *)iconVectorDesc
{
    _iconVectorDesc = iconVectorDesc;
    
    [self.shapeView removeFromSuperview];
    
    if (iconVectorDesc == nil && _vector)
    {
        [_vector removeFromSuperview];
        [_titleLabel sdc_alignLeftEdgeWithSuperviewMargin:0];
        return;
    }
    
    if (!_vector)
    {
        _vector = [MyVector new2];
        [_innerContent addSubview:_vector];
        [_titleLabel sdc_get_leadingOrLeft].active = NO;
        [_vector sdc_alignLeftEdgeWithSuperviewMargin:0];
        [_vector sdc_pinHeight:20];
        [_vector sdc_verticallyCenterInSuperview];
        [_titleLabel sdc_alignEdge:UIRectEdgeLeft withEdge:UIRectEdgeRight ofView:_vector inset:10];
    }
    
    _vector.vector = _iconVectorDesc;
}

-(void)setIconShapeDesc:(NSArray *)iconShapeDesc
{
    [self setIconShapeDesc:iconShapeDesc tintColor:[UIColor whiteColor]];
}

-(void)setIconShapeDesc:(NSArray *)iconShapeDesc tintColor:(UIColor*)color
{
    _iconShapeDesc = iconShapeDesc;
    
    [_vector removeFromSuperview];
    
    if (iconShapeDesc == nil && self.shapeView)
    {
        [self.shapeView removeFromSuperview];
        [_titleLabel sdc_alignLeftEdgeWithSuperviewMargin:0];
        return;
    }
    
    if (!self.shapeView)
    {
        [_vector removeFromSuperview];
        self.shapeView = [[MyShapeView alloc] initWithShapeDesc:_iconShapeDesc andShapeTintColor:color];
        self.shapeView.maintainAspectRatio = YES;
        self.shapeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.innerContent addSubview:self.shapeView];
        [self.titleLabel sdc_get_leadingOrLeft].active = NO;
        [self.shapeView sdc_alignLeftEdgeWithSuperviewMargin:0];
//        [self.shapeView sdc_pinCubicSize:20];
        [self.shapeView sdc_pinHeight:20];
        [self.shapeView sdc_verticallyCenterInSuperview];
        [_titleLabel sdc_alignEdge:UIRectEdgeLeft withEdge:UIRectEdgeRight ofView:self.shapeView inset:10];
    }
    
    self.shapeView.shapeDesc = iconShapeDesc;
}


-(void)setTitle:(NSString *)title
{
    if(title != nil){
        _titleLabel.text = title;
    }else{
        [_titleLabel removeFromSuperview];
        [self.shapeView sdc_get_leadingOrLeft].active = false;
        [self.shapeView sdc_horizontallyCenterInSuperview];
        
        [_vector sdc_get_leadingOrLeft].active = false;
        [_vector sdc_horizontallyCenterInSuperview];
    }
}

-(void)layoutSubviews
{
    if (_fullRoundCorner)
    {
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.0f;
    
    }
    else
    {
        self.layer.cornerRadius = self.roundCorner;
    }
    self.layer.masksToBounds = YES;
}

-(void)setRoundCorner:(CGFloat)roundCorner
{
    _roundCorner = roundCorner;
    self.layer.cornerRadius = roundCorner;
}

//-(void)setBackgroundColor:(UIColor *)backgroundColor
//{
//    [super setBackgroundColor:backgroundColor];
//    [[UIColor whiteColor] colorWithAlphaComponent:.5];
//}

-(void)unhighlightSuccessful:(id)sender event:(UIEvent *)event
{
    [UIView animateWithDuration:.3 animations:^{
    self.backgroundColor = [self.backgroundColor sameColorDiffLightness:.2];
    }];
    
    _safe_call_simple_block(_tapCallback);
}

-(void)unhighlightCancelled:(id)sender event:(UIEvent *)event
{
    [UIView animateWithDuration:.3 animations:^{
    self.backgroundColor = [self.backgroundColor sameColorDiffLightness:.2];
    }];
}

-(void)highlight:(id)sender event:(UIEvent *)event
{
    [UIView animateWithDuration:.3 animations:^{
        
    
    self.backgroundColor = [self.backgroundColor sameColorDiffLightness:-.2];
    }];
}



@end
