//
//  MyTableViewPickerCell.m
//  oncost
//
//  Created by Hamidreza Vakilian on 3/22/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "MyTableViewPickerCell.h"
#import "MyTableViewPicker.h"
#import "UIView+Extensions.h"
#import "UIView+SDCAutoLayout.h"

@interface MyTableViewPickerCell ()

@property (retain, nonatomic) UILabel* theTitle;
@property (weak, nonatomic) NSMutableDictionary* dic;

@end

@implementation MyTableViewPickerCell

-(void)initialize
{
    [super initialize];
    self.theTitle = [UILabel new2];
    [self.theContentView addSubview:self.theTitle];
    [self.theTitle sdc_alignLeftEdgeWithSuperviewMargin:15];
    [self.theTitle sdc_verticallyCenterInSuperview];
}

-(void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.theTitle.font = titleFont;
}

-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.theTitle.textColor = titleColor;
}

-(void)selfTap:(id)sender
{
    [self.delegate MyTableViewPickerCompatibleCell:(MyTableViewPickerCompatibleCell*)self didTapWithDictionary:self.dic];
}

-(void)setTitle:(NSString*)title andDic:(NSMutableDictionary*)dic
{
    self.dic = dic;
    self.theTitle.text = title;
}

@end
