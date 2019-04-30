//
//  MATTextField.m
//  mactehrannew
//
//  Created by hAmidReza on 8/1/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "MATTextField.h"
#import "DottedHairLine.h"
#import "UIView+SDCAutoLayout.h"
#import "helper.h"
#import "Codebase_definitions.h"
#import "UIFont+Extensions.h"
#import "NSObject+DataObject.h"

@interface _MATTextField_TextView : UITextView <_MATTextField_FieldAndViewSharedProtocol>

@property (assign, nonatomic) BOOL pasteDisabled;

@end

@implementation _MATTextField_TextView

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.textContainerInset = UIEdgeInsetsZero;
        self.textContainer.lineFragmentPadding = 0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(MATTextField*_Nonnull)mainView
{
    return self.objectData;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (_pasteDisabled)
    {
        if (action == @selector(paste:))
            return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end

@interface _MATTextField_TextField : UITextField <_MATTextField_FieldAndViewSharedProtocol>

@property (assign, nonatomic) BOOL pasteDisabled;

@end

@implementation _MATTextField_TextField

-(CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width, size.height+2);
}

-(MATTextField*_Nonnull)mainView
{
    return self.objectData;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (_pasteDisabled)
    {
        if (action == @selector(paste:))
            return NO;
    }
    return [super canPerformAction:action withSender:sender];
}


@end

typedef enum : NSUInteger {
    ErrorTypeNone = 0,
    ErrorTypeExceededLength = 1 << 0,
    ErrorTypeValidation = 1 << 1,
    ErrorTypeRequiredField = 1 << 2,
} ErrorType;

@interface MATTextField () <UITextFieldDelegate, UITextViewDelegate>
{
    BOOL needsRefresh;
    BOOL needsRefreshTexts;
    BOOL titleLabelMinimized;
    id<_MATTextField_FieldAndViewSharedProtocol> theField;
    ErrorType error;
    BOOL hasValidatedAtLeastOnce;
    NSString* theText;
}

@property (retain, nonatomic) UIView* innerContent;
@property (retain, nonatomic) UILabel* titleLabel;
@property (retain, nonatomic) UILabel* helperLabel;
@property (retain, nonatomic) UILabel* errorLabel;
@property (retain, nonatomic) UILabel* counterLabel;
@property (retain, nonatomic) UILabel* placeholderLabel;
@property (retain, nonatomic) UIView* textFieldViewHolder;
@property (retain, nonatomic) _MATTextField_TextView* textView;
@property (retain, nonatomic) _MATTextField_TextField* textField;
@property (retain, nonatomic) UIView* divider;
@property (retain, nonatomic) DottedHairLine* disabledDivider;

@end

@implementation MATTextField

-(instancetype)initWithType:(MATTextFieldType)type
{
    self = [super _init];
    if (self)
    {
        _type = type;
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    [super initialize];
    
    //    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _innerContent = [UIView new];
    _innerContent.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_innerContent];
    [_innerContent sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    
    _textFieldViewHolder = [UIView new];
    _textFieldViewHolder.translatesAutoresizingMaskIntoConstraints = NO;
    [_innerContent addSubview:_textFieldViewHolder];
    [_textFieldViewHolder sdc_alignTopEdgeWithSuperviewMargin:0];
    [_textFieldViewHolder sdc_alignRightEdgeWithSuperviewMargin:0];
    [_textFieldViewHolder sdc_alignLeftEdgeWithSuperviewMargin:0];
    
    if (_type == MATTextFieldTypeTextField)
    {
        _textField = [_MATTextField_TextField new];
        
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.delegate = self;
        _textField.text = @"s";
        _textField.font = [UIFont systemFontOfSize:100];
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
        [_textFieldViewHolder addSubview:_textField];
        [_textField sdc_alignEdgesWithSuperview:UIRectEdgeAll];
        theField = _textField;
    }
    else if (_type == MATTextFieldTypeTextView)
    {
        _textView = [_MATTextField_TextView new];
        _textView.delegate = self;
        _textView.text = @"s";
        _textView.font = [UIFont systemFontOfSize:100];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        _textView.scrollEnabled = NO;
        [_textFieldViewHolder addSubview:_textView];
        [_textView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
        theField = _textView;
    }
    
    ((NSObject*)theField).objectData = self;
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"s";
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_innerContent addSubview:_titleLabel];
    [_titleLabel sdc_alignSideEdgesWithSuperviewInset:0];
    [_titleLabel sdc_alignVerticalCenterWithView:_textFieldViewHolder];
    
    _placeholderLabel = [UILabel new];
    _placeholderLabel.alpha = 0;
    _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_innerContent addSubview:_placeholderLabel];
    [_placeholderLabel sdc_alignSideEdgesWithSuperviewInset:0];
    [_placeholderLabel sdc_alignVerticalCenterWithView:_textFieldViewHolder];
    
    _disabledDivider = [DottedHairLine new];
    _disabledDivider.length1 = @(1);
    _disabledDivider.length2 = @(5);
    _disabledDivider.alpha = 0;
    _disabledDivider.translatesAutoresizingMaskIntoConstraints = NO;
    [_innerContent addSubview:_disabledDivider];
    [_disabledDivider sdc_pinHeight:0];
    [_disabledDivider sdc_alignSideEdgesWithSuperviewInset:0];
    [_disabledDivider sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:_textFieldViewHolder];
    
    _divider = [UIView new];
    _divider.translatesAutoresizingMaskIntoConstraints = NO;
    [_innerContent addSubview:_divider];
    [_divider sdc_pinHeight:1];
    [_divider sdc_alignSideEdgesWithSuperviewInset:0];
    [_divider sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:_textFieldViewHolder];
    
    _helperLabel = [UILabel new];
    _helperLabel.numberOfLines = 0;
    _helperLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_innerContent addSubview:_helperLabel];
    [_helperLabel sdc_alignSideEdgesWithSuperviewInset:0];
    [_helperLabel sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:_textFieldViewHolder inset:0];
    NSLayoutConstraint* con2 = [NSLayoutConstraint constraintWithItem:_helperLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:_innerContent attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [_innerContent addConstraint:con2];
    
    [UIView sdc_priority:999 block:^{
        [_helperLabel sdc_alignBottomEdgeWithSuperviewMargin:0];
    }];
    
    _counterLabel = [UILabel new];
    _counterLabel.alpha = 0;
    _counterLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_innerContent addSubview:_counterLabel];
    [_counterLabel sdc_alignSideEdgesWithSuperviewInset:0];
    [_counterLabel sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:_textFieldViewHolder inset:0];
    
    _errorLabel = [UILabel new];
    _errorLabel.numberOfLines = 0;
    _errorLabel.alpha = 0;
    _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_innerContent addSubview:_errorLabel];
    [_errorLabel sdc_alignSideEdgesWithSuperviewInset:0];
    [_errorLabel sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:_textFieldViewHolder inset:0];
    NSLayoutConstraint* con = [NSLayoutConstraint constraintWithItem:_errorLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:_innerContent attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [_innerContent addConstraint:con];
    
    [self setDefaults];
    [self setNeedsRefresh];
    
    UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(innerContentTap:)];
    [_innerContent addGestureRecognizer:tapGest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textField_didBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textField_didEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textField_didChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textField_didBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textField_didEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textField_didChange:) name:UITextViewTextDidChangeNotification object:nil];
    
}

-(void)innerContentTap:(id)sender
{
    [theField becomeFirstResponder];
}

-(void)setDefaults
{
    _font = [UIFont systemFontOfSize:16];
    
    _textAlignment = NSTextAlignmentLeft;
    _titleLabelActiveHeight = 15;
    _titleLabelSideMargins = 0;
    _textFieldTopMargin = 8;
    _textFieldBottomMargin = 8;
    _topPadding = 16.0f;
    _titleLabelNormalColor = _black(.42);
    
    _placeholderColor = _black(.54);
    
    //active color
    _titleLabelActiveColor = rgba(48, 125, 252, 1.000);
    _dividerActiveColor = rgba(48, 125, 252, 1.000);
    _primaryTintColor = rgba(48, 125, 252, 1.000);
    
    _dividerNormalColor = _black(.42);
    _dividerActiveHeight = 2.0f;
    _dividerNormalHeight = 1.0f;
    
    _helperLabelTopMargin = 16.0f;
    _helperLabelNormalColor = _black(.54);
    
    _errorColor = rgba(252, 31, 74, 1.000);
    
    _textFieldColor = rgba(33, 33, 33, 1.000);
    
    _errorText = _str(@"Error!");
    
    _maxLength = 100;
    
    _hidesHelperTextIfDisabled = false;
    
    _textViewMaxNumberOfLines = 2;
    
    _pasteDisabled = YES;
    theField.pasteDisabled = YES;
}

-(void)textField_didBeginEditing:(NSNotification*)noti
{
    if (noti.object == theField)
    {
        [self gotoState:YES animated:YES];
    }
}

-(void)textField_didChange:(NSNotification*)noti
{
    if (noti.object == theField)
    {
        [self checkLengthIfNeeded];
        
        if (_validateContinuously)
        {
            [self validateIfNeeded];
        }
        [self gotoState:YES animated:YES];
    }
}

-(void)textField_didEndEditing:(NSNotification*)noti
{
    if (noti.object == theField)
    {
        _validateContinuously = YES;
        [self validateIfNeeded];
        [self gotoState:NO animated:YES];
    }
}

-(void)checkLengthIfNeeded
{
    if (_showsCounterLabel)
    {
        if (theField.text.length > _maxLength)
            //            error |= ErrorTypeExceededLength;
            _bitwise_set(error, ErrorTypeExceededLength);
        else
            //            error &= ~ErrorTypeExceededLength;
            _bitwise_unset(error, ErrorTypeExceededLength);
    }
}

-(void)validateIfNeeded
{
    if (_validateString)
    {
        if (!_validateString(theField.text))
            //            error |= ErrorTypeValidation;
            _bitwise_set(error, ErrorTypeValidation);
        else
            _bitwise_unset(error, ErrorTypeValidation);
        //            error &= ~ErrorTypeValidation;
    }
    else if (self.requirementType == MATTextFieldRequirementTypeRequired)
    {
        if (!_str_ok2(theField.text))
            _bitwise_set(error, ErrorTypeRequiredField);
        else
            _bitwise_unset(error, ErrorTypeRequiredField);
    }
    
    hasValidatedAtLeastOnce = YES;
}

-(BOOL)resignFirstResponder
{
    [theField resignFirstResponder];
    return [super resignFirstResponder];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)gotoState:(BOOL)active animated:(BOOL)animated
{
    _isActive = active;
    
    [self layoutIfNeeded];
    [UIView animateWithDuration:animated ? .3 : 0 animations:^{
        [self refreshUI];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setNeedsRefresh
{
    if (needsRefresh == NO)
    {
        needsRefresh = YES;
        _mainThreadAsync(^{
            [self refreshUI];
            needsRefresh = NO;
        });
    }
}

-(void)setNeedsLabelTextsRefresh
{
    if (needsRefreshTexts == NO)
    {
        needsRefreshTexts = YES;
        _mainThreadAsync(^{
            [self refreshLabelTexts];
            [self refreshUI];
            needsRefreshTexts = NO;
        });
    }
}

-(void)forceValidate
{
    _validateContinuously = YES;
    [self setNeedsRefresh];
}

-(void)__refreshTextAlignments
{
    _titleLabel.textAlignment = _textAlignment;
    theField.textAlignment = _textAlignment;
    _placeholderLabel.textAlignment = _textAlignment;
    _helperLabel.textAlignment = _textAlignment;
    _errorLabel.textAlignment = _textAlignment;
    
    if (_textAlignment == NSTextAlignmentLeft)
        _counterLabel.textAlignment = NSTextAlignmentRight;
    else if (_textAlignment == NSTextAlignmentRight)
        _counterLabel.textAlignment = NSTextAlignmentLeft;
    else //center or something else?
        _counterLabel.hidden = YES;
}

-(void)__refreshFonts
{
    _titleLabel.font = _font;
    theField.font = _font;
    _helperLabel.font = [_font sameFontScaledSize:.75];
    _errorLabel.font = _helperLabel.font;
    _counterLabel.font = _helperLabel.font;
    _placeholderLabel.font = _font;
}

-(void)__refreshConstraints
{
    [_textFieldViewHolder sdc_get_top].constant = _topPadding + _titleLabelActiveHeight + _textFieldTopMargin;
    [_titleLabel sdc_get_leadingOrLeft].constant = _titleLabelSideMargins;
    [_titleLabel sdc_get_trailingOrRight].constant = -_titleLabelSideMargins;
    [_helperLabel sdc_get_top].constant = _helperLabelTopMargin;
    [_errorLabel sdc_get_top].constant = _helperLabelTopMargin;
    [_counterLabel sdc_get_top].constant = _helperLabelTopMargin;
    
    [_disabledDivider sdc_get_top].constant = _textFieldBottomMargin;
    [_divider sdc_get_top].constant = _textFieldBottomMargin;
    [_disabledDivider sdc_get_height].constant = _dividerNormalHeight;
    
    if (_isActive)
        [_divider sdc_get_height].constant = _dividerActiveHeight;
    else
    {
        if (error == ErrorTypeNone)
            [_divider sdc_get_height].constant = _dividerNormalHeight;
        else
            [_divider sdc_get_height].constant = _dividerActiveHeight;
    }
}

-(void)__refreshColors
{
    _placeholderLabel.textColor = _placeholderColor;
    theField.textColor = _disabled ? _black(.42) : _textFieldColor;
    _disabledDivider.color = _dividerNormalColor;
    _errorLabel.textColor = _errorColor;
    _helperLabel.textColor = _helperLabelNormalColor;
    _counterLabel.textColor = _helperLabelNormalColor;
}

-(void)__handleDisabled
{
    if (_disabled)
    {
        _disabledDivider.alpha = 1;
        _divider.alpha = 0;
    }
    else
    {
        _disabledDivider.alpha = 0;
        _divider.alpha = 1.0;
    }
}

-(void)refreshUI
{
    
    [self layoutIfNeeded];
    
    [self __refreshTextAlignments];
    
    [self __handleDisabled];
    
    if (!_isActive && !_str_ok2(theField.text) && !_customViewAsValue)
    {
        [self maximizeTitleIfNeeded];
    }
    
    if (_str_ok2(theField.text) || _customViewAsValue)
    {
        [self minimizeTitleIfNeeded];
    }
    //    else
    //    {
    //        [self maximizeTitleIfNeeded];
    //    }
    
    if (_customViewAsValue)
    {
        _customViewAsValue.alpha = 1;
        theField.alpha = 0;
    }
    else
    {
        _customViewAsValue.alpha = 0;
        theField.alpha = 1;
    }
    
    [self __refreshFonts];
    
    [self __refreshColors];
    
    [self __refreshConstraints];
    
    if (_showsCounterLabel)
    {
        if (_str_ok2(theField.text))
        {
            _counterLabel.alpha = 1;
            
            if (_counterString)
                _counterLabel.text = _counterString(theField.text.length, _maxLength);
            else
                _counterLabel.text = _strfmt(@"%lu/%lu", theField.text.length, _maxLength);
        }
        else //hide counter if there's no input text
        {
            _counterLabel.alpha = 0;
        }
    }
    
    if (error == ErrorTypeNone)
    {
        _errorLabel.alpha = 0;
        _helperLabel.alpha = 1;
    }
    else
    {
        if (_bitwise_check(error, ErrorTypeValidation)  || _bitwise_check(error, ErrorTypeRequiredField))
        {
            NSString* errorText = [self __getErrorText];
            if (_str_ok2(errorText))
            {
                _errorLabel.text = errorText;
                _errorLabel.alpha = 1;
                _helperLabel.alpha = 0;
            }
            else
            {
                _errorLabel.alpha = 0;
                _helperLabel.alpha = 1;
                _helperLabel.textColor = _errorColor;
            }
        }
        
        
        else if (_bitwise_check(error, ErrorTypeExceededLength))
        {
            _helperLabel.alpha = 1;
            _counterLabel.textColor = _errorColor;
        }
        else
        {
            _errorLabel.alpha = 0;
            _helperLabel.alpha = 1;
        }
    }
    
    if (_isActive)
    {
        
        if (error == ErrorTypeNone)
        {
            _divider.backgroundColor = _dividerActiveColor;
            _titleLabel.textColor = _titleLabelActiveColor;
        }
        else
        {
            _titleLabel.textColor = _errorColor;
            _divider.backgroundColor = _errorColor;
        }
        
        if (!_str_ok2(theField.text))
        {
            _placeholderLabel.alpha = 1.0f;
            [self minimizeTitleIfNeeded];
        }
        else
        {
            _placeholderLabel.alpha = 0;
        }
        
    }
    else
    {
        if (error == ErrorTypeNone)
        {
            _divider.backgroundColor = _dividerNormalColor;
            _titleLabel.textColor = _titleLabelNormalColor;
        }
        else
        {
            _titleLabel.textColor = _errorColor;
            _divider.backgroundColor = _errorColor;
        }
        
        _placeholderLabel.alpha = 0.0f;
        
        
    }
    
}

-(void)maximizeTitleIfNeeded
{
    if (titleLabelMinimized)
    {
        [_titleLabel sdc_get_top].active = NO;
        NSLayoutConstraint* possibleVerticalCon = [_titleLabel sdc_get_verticalCenter];
        if (!possibleVerticalCon)
            [_titleLabel sdc_alignVerticalCenterWithView:_textFieldViewHolder];
        _titleLabel.transform = CGAffineTransformIdentity;
        titleLabelMinimized = NO;
    }
}

-(void)minimizeTitleIfNeeded
{
    if (!titleLabelMinimized)
    {
        
        [_titleLabel sdc_get_verticalCenter].active = NO;
        NSLayoutConstraint* possibleTopCon = [_titleLabel sdc_get_top];
        if (!possibleTopCon)
            [_titleLabel sdc_alignTopEdgeWithSuperviewMargin:_topPadding];
        
        CGRect titleLabelOldFrame = _titleLabel.frame;
        
        CGFloat trans = _titleLabelActiveHeight / titleLabelOldFrame.size.height;
        
        CGAffineTransform t = CGAffineTransformMakeScale(trans, trans);
        if (_textAlignment == NSTextAlignmentRight)
            t = CGAffineTransformTranslate(t, titleLabelOldFrame.size.width * (1-trans) / 2.0f * (1/trans), -titleLabelOldFrame.size.height * (1-trans) / 2.0f * (1/trans));
        else if (_textAlignment == NSTextAlignmentLeft)
            t = CGAffineTransformTranslate(t, -titleLabelOldFrame.size.width * (1-trans) / 2.0f * (1/trans), -titleLabelOldFrame.size.height * (1-trans) / 2.0f * (1/trans));
        else if (_textAlignment == NSTextAlignmentCenter)
            t = CGAffineTransformTranslate(t, 0, -titleLabelOldFrame.size.height * (1-trans) / 2.0f * (1/trans));
        
        _titleLabel.transform = t;
        titleLabelMinimized = YES;
    }
}

-(NSString*)__getErrorText
{
    if (_errorForString)
        return _errorForString(theField.text);
    else
        return _errorText;
}

#pragma mark Getters & Setters

-(void)setFont:(UIFont *)font
{
    _font = font;
    [self setNeedsRefresh];
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    [self setNeedsRefresh];
}

-(void)setTitleLabelActiveHeight:(CGFloat)titleLabelActiveHeight
{
    _titleLabelActiveHeight = titleLabelActiveHeight;
    [self setNeedsRefresh];
}

-(void)setTitleLabelSideMargins:(CGFloat)titleLabelSideMargins
{
    _titleLabelSideMargins = titleLabelSideMargins;
    [self setNeedsRefresh];
}
-(void)setTextFieldTopMargin:(CGFloat)textFieldTopMargin
{
    _textFieldTopMargin = textFieldTopMargin;
    [self setNeedsRefresh];
}

-(void)setTitleLabelNormalColor:(UIColor *)titleLabelNormalColor
{
    _titleLabelNormalColor = titleLabelNormalColor;
    [self setNeedsRefresh];
}

-(void)setTitleLabelActiveColor:(UIColor *)titleLabelActiveColor
{
    _titleLabelActiveColor = titleLabelActiveColor;
    [self setNeedsRefresh];
}

-(void)setTopPadding:(CGFloat)topPadding
{
    _topPadding = topPadding;
    [self setNeedsRefresh];
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsRefresh];
}

-(void)setTextFieldBottomMargin:(CGFloat)textFieldBottomMargin
{
    _textFieldBottomMargin = textFieldBottomMargin;
    [self setNeedsRefresh];
}

-(void)setDividerActiveColor:(UIColor *)dividerActiveColor
{
    _dividerActiveColor = dividerActiveColor;
    [self setNeedsRefresh];
}

-(void)setDividerNormalColor:(UIColor *)dividerNormalColor
{
    _dividerNormalColor = dividerNormalColor;
    [self setNeedsRefresh];
}

-(void)setDividerActiveHeight:(CGFloat)dividerActiveHeight
{
    _dividerActiveHeight = dividerActiveHeight;
    [self setNeedsRefresh];
}

-(void)setDividerNormalHeight:(CGFloat)dividerNormalHeight
{
    _dividerNormalHeight = dividerNormalHeight;
    [self setNeedsRefresh];
}

-(void)setHelperLabelTopMargin:(CGFloat)helperLabelTopMargin
{
    _helperLabelTopMargin = helperLabelTopMargin;
    [self setNeedsRefresh];
}

-(void)setHelperLabelNormalColor:(UIColor *)helperLabelNormalColor
{
    _helperLabelNormalColor = helperLabelNormalColor;
    [self setNeedsRefresh];
}

-(void)setErrorColor:(UIColor *)errorColor
{
    _errorColor = errorColor;
    [self setNeedsRefresh];
}

-(void)setTextFieldColor:(UIColor *)textFieldColor
{
    _textFieldColor = textFieldColor;
    [self setNeedsRefresh];
}

-(void)setPrimaryTintColor:(UIColor *)primaryTintColor
{
    _primaryTintColor = primaryTintColor;
    _titleLabelActiveColor = primaryTintColor;
    _dividerActiveColor = primaryTintColor;
    theField.tintColor = primaryTintColor;
    [self setNeedsRefresh];
}

-(void)setRequirementType:(MATTextFieldRequirementType)requirementType
{
    _requirementType = requirementType;
    [self setNeedsRefresh];
}

-(void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    [self setNeedsLabelTextsRefresh];
}

-(void)setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText = placeholderText;
    [self setNeedsLabelTextsRefresh];
}

-(void)setHelperText:(NSString *)helperText
{
    _helperText = _str_safe2(helperText);
    [self setNeedsLabelTextsRefresh];
}

-(void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;
    _textField.enabled = !disabled;
    _textView.editable = !disabled;
    [self setNeedsLabelTextsRefresh];
    [self setNeedsRefresh];
}

-(void)setErrorText:(NSString *)errorText
{
    _errorText = errorText;
    [self setNeedsLabelTextsRefresh];
}

-(void)setShowsCounterLabel:(BOOL)showsCounterLabel
{
    _showsCounterLabel = showsCounterLabel;
    [self setNeedsRefresh];
}

-(void)setMaxLength:(NSUInteger)maxLength
{
    _maxLength = maxLength;
    [self setNeedsRefresh];
}

-(void)setHidesHelperTextIfDisabled:(BOOL)hidesHelperTextIfDisabled
{
    _hidesHelperTextIfDisabled = hidesHelperTextIfDisabled;
    [self setNeedsLabelTextsRefresh];
}

-(textFieldOrView)theField
{
    return theField;
}

-(void)setTextViewMaxNumberOfLines:(NSUInteger)textViewMaxNumberOfLines
{
    _textViewMaxNumberOfLines = textViewMaxNumberOfLines;
    
    _textView.textContainer.maximumNumberOfLines = _textViewMaxNumberOfLines;
    _textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    //    [_textView.layoutManager textContainerChangedGeometry:_textView.textContainer];
}


-(void)setPasteDisabled:(BOOL)pasteDisabled
{
    _pasteDisabled = pasteDisabled;
    theField.pasteDisabled = pasteDisabled;
}

#pragma mark methods
-(void)setTitle:(NSString*)title placeholder:(NSString*)placeholder helperText:(NSString*)helper value:(NSString*)value errorText:(NSString*)errorString
{
    //    _mainThreadAsync(^{
    
    //    return;
    _titleText = title;
    _placeholderText = placeholder;
    _helperText = _str_safe2(helper);
    _errorText = errorString;
    theText = _str_safe(value);
    [self setNeedsLabelTextsRefresh];
    [self setNeedsRefresh];
    //    });
}


-(BOOL)becomeFirstResponder
{
    return [theField becomeFirstResponder];
}

-(void)refreshLabelTexts
{
    if (_requirementType == MATTextFieldRequirementTypeNone || _disabled == YES)
        _titleLabel.text = _titleText;
    else if (_requirementType == MATTextFieldRequirementTypeRequired)
        _titleLabel.text = _strfmt(@"%@ %@", _titleText, _str(@"*"));
    else if (_requirementType == MATTextFieldRequirementTypeOptional)
        _titleLabel.text = _strfmt(@"%@ %@", _titleText, _str(@"(Optional)"));
    _placeholderLabel.text = _placeholderText;
    if (_hidesHelperTextIfDisabled)
        _helperLabel.text = _str_safe2(_disabled ? nil : _helperText);
    else
        _helperLabel.text = _str_safe2(_helperText);
    _errorLabel.text = _errorText;
    theField.text = theText;
}

-(void)setText:(NSString *)text
{
    theText = _str_safe(text);
    theField.text = theText;
    //    _mainThreadAsync(^{
    [self setNeedsLabelTextsRefresh];
    [self setNeedsRefresh];
    //    });
}

-(NSString *)text
{
    return theField.text;
}

-(BOOL)isValid
{
    if (_disabled)
        return true;
    
    if (!hasValidatedAtLeastOnce || true) // why  !hasValidatedAtLeastOnce    !?????
    {
        [self checkLengthIfNeeded];
        [self validateIfNeeded];
    }
    
    if (error == ErrorTypeNone)
        return true;
    
    return false;
}

-(void)setCustomViewAsValue:(UIView *)customViewAsValue
{
    [self setCustomViewAsValue:customViewAsValue animated:NO];
}

-(void)setCustomViewAsValue:(UIView *)customViewAsValue animated:(BOOL)animated
{
    if (!customViewAsValue)
        return;
    
    _customViewAsValue = customViewAsValue;
    customViewAsValue.translatesAutoresizingMaskIntoConstraints = NO;
    [_textFieldViewHolder addSubview:customViewAsValue];
    [customViewAsValue sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    _customViewAsValue.alpha = 0;
    //    [self setNeedsRefresh];
    
    [self gotoState:NO animated:animated];
}

#pragma mark UITextFieldDelegate & UITextViewDelegate


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(textFieldOrViewDidBeginEditing:)])
        [_delegate textFieldOrViewDidBeginEditing:(textFieldOrView)textField];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(textFieldOrViewDidBeginEditing:)])
        [_delegate textFieldOrViewDidBeginEditing:(textFieldOrView)textView];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self setNeedsRefresh];
    
    if (_textFieldOrViewShouldChangeCharactersInRange)
        return _textFieldOrViewShouldChangeCharactersInRange(theField, range, string);
    else if ([_delegate respondsToSelector:@selector(textFieldOrView:shouldChangeCharactersInRange:replacementString:)])
        return [_delegate textFieldOrView:(textFieldOrView)textField shouldChangeCharactersInRange:range replacementString:string];
    else if (_num_ok1(_maxTextLength))
    {
        NSUInteger oldLength = [theField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        return newLength <= [_maxTextLength unsignedIntegerValue];
    }
    else
        return YES;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (_disableNextLineOnTextView)
    {
        if([text isEqualToString:@"\n"]) {
            [self handleReturnOnField];
            return NO;
        }
    }
    
    [self setNeedsRefresh];
    
    if (_textFieldOrViewShouldChangeCharactersInRange)
        return _textFieldOrViewShouldChangeCharactersInRange(theField, range, text);
    else if ([_delegate respondsToSelector:@selector(textFieldOrView:shouldChangeCharactersInRange:replacementString:)])
        return [_delegate textFieldOrView:(textFieldOrView)textView shouldChangeCharactersInRange:range replacementString:text];
    else if (_num_ok1(_maxTextLength))
    {
        NSUInteger oldLength = [theField.text length];
        NSUInteger replacementLength = [text length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        return newLength <= [_maxTextLength unsignedIntegerValue];
    }
    else
        return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_shouldBeginEditing)
        return _shouldBeginEditing((textFieldOrView)textView);
    else if ([_delegate respondsToSelector:@selector(textFieldOrViewShouldBeginEditing:)])
        return [_delegate textFieldOrViewShouldBeginEditing:(textFieldOrView)textView];
    else
        return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL result = YES;
    if (_shouldBeginEditing)
        result = _shouldBeginEditing((textFieldOrView)textField);
    else if ([_delegate respondsToSelector:@selector(textFieldOrViewShouldBeginEditing:)])
        result = [_delegate textFieldOrViewShouldBeginEditing:(textFieldOrView)textField];
    
    if (result)
    {
        if (_nextFieldToFocus)
        {
            if (_nextFieldToFocus())
                textField.returnKeyType = UIReturnKeyNext;
            else
                textField.returnKeyType = UIReturnKeyDone;
        }
        else if ([_delegate respondsToSelector:@selector(textFieldOrViewNextViewToFocus:)])
        {
            UIView* nextView = [_delegate textFieldOrViewNextViewToFocus:(textFieldOrView)textField];
            if (nextView)
                textField.returnKeyType = UIReturnKeyNext;
            else
                textField.returnKeyType = UIReturnKeyDone;
        }
        
    }
    
    return result;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self handleReturnOnField];
}

-(BOOL)handleReturnOnField
{
    if (_nextFieldToFocus)
    {
        [_nextFieldToFocus() becomeFirstResponder];
        [self resignFirstResponder];
        return YES;
    }
    else if ([_delegate respondsToSelector:@selector(textFieldOrViewNextViewToFocus:)])
    {
        UIView* nextView = [_delegate textFieldOrViewNextViewToFocus:theField];
        if (nextView)
        {
            [nextView becomeFirstResponder];
            [self resignFirstResponder];
            return YES;
        }
        else
        {
            if ([_delegate respondsToSelector:@selector(lastFieldFinished:)])
                [_delegate lastFieldFinished:theField];
        }
        
    }
    else if ([_delegate respondsToSelector:@selector(lastFieldFinished:)])
        [_delegate lastFieldFinished:theField];
    
    if ([_delegate respondsToSelector:@selector(textFieldOrViewShouldReturn:)]) {
        return [_delegate textFieldOrViewShouldReturn:theField];
    }
    
    return YES;
}

-(void)textFieldDidChange:(UITextField*)textField
{
    if (_textFieldOrViewDidChange)
        _textFieldOrViewDidChange(theField);
    else if ([_delegate respondsToSelector:@selector(textFieldOrViewDidChange:)])
        [_delegate textFieldOrViewDidChange:theField];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (_textFieldOrViewDidChange)
        _textFieldOrViewDidChange(theField);
    else if ([_delegate respondsToSelector:@selector(textFieldOrViewDidChange:)])
        [_delegate textFieldOrViewDidChange:theField];
}

-(void)setKeyboardType:(UIKeyboardType)keyboardType
{
    theField.keyboardType = keyboardType;
    if (keyboardType == UIKeyboardTypePhonePad)
    {
        UIToolbar *accessoryView = [[UIToolbar alloc]
                                    initWithFrame:CGRectMake(0, 0, _deviceWidth, 0.1 * _deviceWidth)];
        UIBarButtonItem *done = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                 target:self
                                 action:@selector(selectDoneButton:)];
        accessoryView.items = @[done];
        
        theField.inputAccessoryView = accessoryView;
    }
    else
        theField.inputAccessoryView = nil;
}

-(void)selectDoneButton:(id)obj
{
    [theField resignFirstResponder];
}

-(UIKeyboardType)keyboardType
{
    return theField.keyboardType;
}

-(void)setSecureTextEntry:(BOOL)secureTextEntry
{
    self.textField.secureTextEntry = secureTextEntry;
}

-(BOOL)secureTextEntry
{
    return self.textField.secureTextEntry;
}

@end

