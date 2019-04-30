//
//  YesNoConfirmationDialog.m
//  Kababchi
//
//  Created by hAmidReza on 7/8/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "YesNoConfirmationDialog.h"
#import "MATButton.h"
#import "MyVerticalStackView.h"
#import "_loadingEnabledView.h"
#import "UIView+Extensions.h"
#import "UIView+SDCAutoLayout.h"
#import "Codebase_definitions.h"
#import "helper.h"
#import "MyVector.h"

@interface YesNoConfirmationDialog ()

@property (retain, nonatomic) MyVerticalStackView* stackView;
@property (retain, nonatomic) UILabel* titleLabel;
@property (retain, nonatomic) UILabel* msgLabel;
@property (retain, nonatomic) MATButton* cancelButton;
@property (retain, nonatomic) MATButton* submitButton;
@property (retain, nonatomic) UIView* footerView;
@property (retain, nonatomic) UIView* customHeaderHolder;

@end

@implementation YesNoConfirmationDialog

-(void)initialize
{
    [super initialize];
    
    _autoDismissDialog = YES;
    _u_statusBarStyle = UIStatusBarStyleLightContent;
    
    [self uniconf_restore];
    
    //    [self.contentView sdc_pinWidth:300];
    
    _stackView = [MyVerticalStackView new2];
    [self.contentView addSubview:_stackView];
    [_stackView sdc_alignEdgesWithSuperview:UIRectEdgeAll ^ UIRectEdgeBottom];
    
    //    _shapeView = [MyShapeView new];
    //    _shapeView.maintainAspectRatio = YES;
    //    _shapeView.translatesAutoresizingMaskIntoConstraints = NO;
    //    [_stackView addArrangedSubview:_shapeView margins:UIEdgeInsetsZero animated:NO fillMode:MyVerticalStackViewFillModeCenter initiallyHidden:YES];
    //    [_shapeView sdc_pinWidth:100];
    
    _customHeaderHolder = [UIView new];
    [_stackView addArrangedSubview:_customHeaderHolder margins:UIEdgeInsetsZero animated:NO fillMode:MyVerticalStackViewFillModeFill initiallyHidden:YES];
    
    _vector = [[MyVector alloc] initWithVector:nil];
    _vector.layer.shadowOpacity = .2;
    _vector.layer.shadowOffset = CGSizeMake(-4, 4);
    _vector.translatesAutoresizingMaskIntoConstraints = NO;
    [_stackView addArrangedSubview:_vector margins:UIEdgeInsetsZero animated:NO fillMode:MyVerticalStackViewFillModeCenter initiallyHidden:YES];
    [_vector sdc_pinWidth:100];
    
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = _u_titleFont;
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_stackView addArrangedSubview:_titleLabel margins:UIEdgeInsetsMake(30, 30, 0, 30) animated:NO fillMode:MyVerticalStackViewFillModeFill initiallyHidden:YES];
    
    _msgLabel = [UILabel new];
    _msgLabel.numberOfLines = 0;
    _msgLabel.font = _u_msgFont;
    _msgLabel.textColor = [UIColor darkGrayColor];
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_stackView addArrangedSubview:_msgLabel margins:UIEdgeInsetsMake(20, 30, 0, 30) animated:NO fillMode:MyVerticalStackViewFillModeFill initiallyHidden:YES];
    
    
    _footerView = [UIView new];
    //    _footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _footerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_footerView];
    [_footerView sdc_alignSideEdgesWithSuperviewInset:10];
    [_footerView sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:_stackView inset:20];
    [_footerView sdc_pinHeight:48];
    [_footerView sdc_alignBottomEdgeWithSuperviewMargin:10];
    
    _defineWeakSelf;
    
    _submitButton = [[MATButton alloc] initWithType:MATButtonTypeFlat];
    _submitButton.titleFont = self.u_buttonFonts;
    _submitButton.innerContentSideMargins = 0;
    _submitButton.innerContentTopPadding = 2;
    _submitButton.innerContentBottomPadding = 2;
    _submitButton.click = ^(MATButton * _Nonnull button) {
        if (weakSelf.callback)
            weakSelf.callback();
        if (weakSelf.autoDismissDialog)
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    _submitButton.title = _str(@"Continue");
    _submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_footerView addSubview:_submitButton];
    [_submitButton sdc_alignEdgesWithSuperview:UIRectEdgeTop | UIRectEdgeRight | UIRectEdgeBottom];
    //    [_submitButton sdc_pinWidth:90];
    //    [_submitButton sdc_setMinimumWidth:90];
    
    _cancelButton = [[MATButton alloc] initWithType:MATButtonTypeFlat];
    _cancelButton.titleFont = self.u_buttonFonts;
    _cancelButton.innerContentSideMargins = 0;
    _cancelButton.innerContentTopPadding = 2;
    _cancelButton.innerContentBottomPadding = 2;
    //    _cancelButton.backgroundColor = [UIColor yellowColor];
    _cancelButton.primaryColor = _black(.5);
    _cancelButton.click = ^(MATButton * _Nonnull button) {
        if (weakSelf.cancelCallback)
            weakSelf.cancelCallback();
        if (weakSelf.autoDismissDialog)
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    _cancelButton.title = _str(@"Cancel");
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_footerView addSubview:_cancelButton];
    [_cancelButton sdc_alignEdgesWithSuperview:UIRectEdgeTop | UIRectEdgeBottom];
    [_cancelButton sdc_alignEdge:UIRectEdgeRight withEdge:UIRectEdgeLeft ofView:_submitButton inset:0];
    //    [_cancelButton sdc_pinWidth:90];
    //    [_cancelButton sdc_setMinimumWidth:90];
    
    
}

-(void)setCustomHeader:(UIView *)customHeader
{
    _customHeader = customHeader;
    if (_customHeader)
    {
        _customHeader.translatesAutoresizingMaskIntoConstraints = NO;
        [_customHeaderHolder addSubview:_customHeader];
        [_customHeader sdc_alignEdgesWithSuperview:UIRectEdgeAll];
        [_stackView showArrangedSubview:_customHeaderHolder animated:NO];
    }
    else
    {
        [_customHeaderHolder sdc_removeAllSubViews];
        [_stackView hideArrangedSubview:_customHeaderHolder animated:NO];
    }
}

-(void)setVector_desc:(NSDictionary *)vector_desc
{
    _vector_desc = vector_desc;
    _vector.vector = vector_desc;
    if (vector_desc)
    {
        [_stackView showArrangedSubview:_vector animated:NO];
    }
    else
        [_stackView hideArrangedSubview:_vector animated:NO];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return _u_statusBarStyle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureWithTitle:(NSString*)title message:(NSString*)msg submit:(NSString*)submit cancel:(NSString*)cancel
{
    if (_str_ok2(title))
    {
        _titleLabel.text = title;
        [_stackView showArrangedSubview:_titleLabel animated:NO];
    }
    else
    {
        [_stackView hideArrangedSubview:_titleLabel animated:NO];
    }
    
    if (_str_ok2(msg))
    {
        _msgLabel.text = msg;
        [_stackView showArrangedSubview:_msgLabel animated:NO];
    }
    else
    {
        [_stackView hideArrangedSubview:_msgLabel animated:NO];
    }
    
    
    
    //    {
    if (_str_ok2(submit))
    {
        _submitButton.title = submit;
        _submitButton.alpha = 1;
    }
    else
    {   _submitButton.title = @"";
        _submitButton.alpha = 0;
    }
    
    if (_str_ok2(cancel))
    {
        _cancelButton.title = cancel;
        _submitButton.alpha = 1;
    }
    else
    {
        _cancelButton.title  = @"";
        _cancelButton.alpha = 0;
    }
    
    
    
}

-(void)setU_titleFont:(UIFont *)u_titleFont
{
    _u_titleFont = u_titleFont;
    _titleLabel.font = _u_titleFont;
}

-(void)setU_msgFont:(UIFont *)u_msgFont
{
    _u_msgFont = u_msgFont;
    _msgLabel.font = _u_msgFont;
}

-(void)setU_buttonFonts:(UIFont *)u_buttonFonts
{
    _u_buttonFonts = u_buttonFonts;
    _submitButton.titleFont = self.u_buttonFonts;
    _cancelButton.titleFont = self.u_buttonFonts;
}

-(void)setU_submitButtonTextColor:(UIColor *)u_submitButtonTextColor
{
    _u_submitButtonTextColor = u_submitButtonTextColor;
    _submitButton.titleColor = _u_submitButtonTextColor;
}

//-(void)setTitleFont:(UIFont *)titleFont
//{
//    _titleFont = titleFont;
//    _titleLabel.font = _titleFont;
//}
//
//-(void)setMsgFont:(UIFont *)msgFont
//{
//    _msgFont = msgFont;
//    _msgLabel.font = _msgFont;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
