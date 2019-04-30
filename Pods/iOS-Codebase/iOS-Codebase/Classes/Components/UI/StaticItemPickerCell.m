//
//  StaticItemPickerCell.m
//  mactehrannew
//
//  Created by Hamidreza Vakilian on 8/3/1396 AP.
//  Copyright © 1396 archibits. All rights reserved.
//

#import "StaticItemPickerCell.h"
#import "MyBouncyButton.h"
#import "UIView+Extensions.h"
#import "UIView+SDCAutoLayout.h"
#import "helper.h"
#import "Codebase_definitions.h"

@interface StaticItemPickerCell ()

@property (weak, nonatomic) NSDictionary* dic;
@property (retain, nonatomic) UIView* hairline;
@property (retain, nonatomic) UILabel* titleLabel;
@property (retain, nonatomic) MyBouncyButton* chooseButton;

@end

@implementation StaticItemPickerCell

-(void)setDefaults
{
    _u_titleLabelFont = [UIFont fontWithName:@"Helvetica-Neue" size:14];
}

-(void)initialize
{
    [super initialize];
    
    [self setDefaults];
    
    [self uniconf_restore];
    
    _titleLabel = [UILabel new2];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.font = _u_titleLabelFont;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel sdc_alignLeftEdgeWithSuperviewMargin:20];
    [_titleLabel sdc_verticallyCenterInSuperview];
    [_titleLabel sdc_alignRightEdgeWithSuperviewMargin:20];
    
    _chooseButton = [[MyBouncyButton alloc] initWithShapeDesc:k_iconNull() andShapeTintColor:_u_chooseButtonShapeTintColor andButtonClick:^(BOOL on) {
        NSLog(@"here");
    }];
    _chooseButton.userInteractionEnabled = NO;
    _chooseButton.borderColor1 = [UIColor clearColor];
//    _defineWeakSelf;
    //    _chooseButton.canChangeToMode = ^BOOL(BOOL on) {
    //        if (on)
    //        {
    //        if ([weakSelf.delegate respondsToSelector:@selector(InviteCell:didWantToBeSelectedWithDictionary:)])
    //            [weakSelf.delegate InviteCell:weakSelf didWantToBeSelectedWithDictionary:weakSelf.dic];
    //            return NO;
    //        }
    //        else
    //        {
    //            weakSelf.dic[@"selected"] = nil;
    //            return YES;
    //        }
    //    };
    
    _chooseButton.setsCornerRadiusForShapeView = NO;
    _chooseButton.setsBackgroundColorForShapeView = NO;
    _chooseButton.u_onstate_transform_ratio = 1.1;
    _chooseButton.u_offstate_transform_ratio = .9;
    _chooseButton.cornerRadius = 17;
    _chooseButton.borderWidth = 1;
    _chooseButton.borderColor2 = _u_chooseButtonBorderColor2;
    _chooseButton.icon2 = _u_chooseButtonIcon2;
    _chooseButton.shapeTintColor2 = [UIColor whiteColor];
    _chooseButton.backgroundColor2 = _u_chooseButtonBackgroundColor2;
    _chooseButton.shapeMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    //    _checkButton.userInteractionEnabled = NO;
    _chooseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_chooseButton];
    [_chooseButton sdc_alignRightEdgeWithSuperviewMargin:10];
    [_chooseButton sdc_pinCubicSize:34];
    [_chooseButton sdc_verticallyCenterInSuperview];
    
    _hairline = [helper horizontalHairlineWithColor:rgba(0, 0, 0, .10)];
    [self.contentView addSubview:_hairline];
    [_hairline sdc_alignBottomEdgeWithSuperviewMargin:0];
    [_hairline sdc_alignRightEdgeWithSuperviewMargin:0];
    [_hairline sdc_alignLeftEdgeWithSuperviewMargin:20];
}

-(void)setChosenAnimated:(BOOL)chosen
{
//    if (chosen)
    [_chooseButton setOn:chosen animated:YES];
}

-(void)configureWithDictionary:(NSDictionary *)dic
{
    _dic = dic;
    _titleLabel.text = dic[@"title"];
    
    [_chooseButton setOn:_bool_true(dic[@"_selected"]) animated:NO];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
