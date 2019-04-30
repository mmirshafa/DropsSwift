//
//  MATTextField.h
//  mactehrannew
//
//  Created by hAmidReza on 8/1/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_viewBase.h"

@class MATTextField;

typedef enum : NSUInteger {
    MATTextFieldRequirementTypeNone,
    MATTextFieldRequirementTypeRequired,
    MATTextFieldRequirementTypeOptional,
} MATTextFieldRequirementType;

typedef enum : NSUInteger {
    MATTextFieldTypeTextField,
    MATTextFieldTypeTextView,
} MATTextFieldType;

@protocol _MATTextField_FieldAndViewSharedProtocol <NSObject>

-(MATTextField*_Nonnull)mainView;
-(BOOL)resignFirstResponder;
-(BOOL)becomeFirstResponder;

@property (nullable, readwrite, strong) UIView *inputAccessoryView;
@property(nullable,nonatomic,strong) UIFont *font;
@property(nullable,nonatomic,strong) UIColor *textColor;
@property(nonatomic) NSTextAlignment textAlignment;
@property(null_resettable,nonatomic,copy) NSString *text;
@property(null_resettable, nonatomic, strong) UIColor *tintColor;
@property(nonatomic) CGFloat alpha;
@property (assign, nonatomic) BOOL pasteDisabled;
@property(nonatomic) UIKeyboardType keyboardType;
@property (nullable, readwrite, strong) UIView *inputView;
@end

typedef _Nonnull id <_MATTextField_FieldAndViewSharedProtocol> textFieldOrView;

@protocol MATTextFieldDelegate <NSObject>

- (void)lastFieldFinished:(textFieldOrView)textFieldOrView;
- (UIView* _Nonnull)textFieldOrViewNextViewToFocus:(textFieldOrView)textFieldOrView;
- (void)textFieldOrViewDidChange:(textFieldOrView)textFieldOrView;
- (BOOL)textFieldOrViewShouldReturn:(textFieldOrView)textFieldOrView;
- (BOOL)textFieldOrViewShouldBeginEditing:(textFieldOrView)textFieldOrView;
- (void)textFieldOrViewDidBeginEditing:(textFieldOrView)textFieldOrView;
- (BOOL)textFieldOrView:(textFieldOrView)textFieldOrView shouldChangeCharactersInRange:(NSRange)range replacementString:(nullable NSString*)string;
@end

@interface MATTextField : _viewBase

/**
 creates a new instance of the MATTextField. you can call new on this class in that case it will create an object with type: MATTextFieldTypeTextField
 
 @param type either MATTextFieldTypeTextField or MATTextFieldTypeTextView.
 @return the instance
 */
-(instancetype)initWithType:(MATTextFieldType)type;


/**
 an easier way than implementing the delegate. this in in higher priority than delegate. so if you set this block, the delegate won't be called for this textfield.
 */
@property (nonatomic, copy, nullable) BOOL (^textFieldOrViewShouldChangeCharactersInRange)(textFieldOrView textFieldOrView, NSRange range, NSString* _Nullable replacementString);

/**
 an easier way than implementing the delegate. this in in higher priority than delegate. so if you set this block, the delegate won't be called for this textfield.
 */
@property (nonatomic, copy, nullable) void (^textFieldOrViewDidChange)(textFieldOrView textFieldOrView);

/**
 ensures the value of the textfield / textview is a vaild one. if the component is disabled it will return true regardlessly.
 */
@property (assign, nonatomic, readonly) BOOL isValid;

/**
 default: nil. takes care of the maximum number of characters inserted into the textfieldorview. if you define the shouldChangeCharactersInRange block or delegate it won't work anymore.
 */
@property (assign, nonatomic) NSNumber* _Nullable maxTextLength;

/**
 default: NSTextAlignmentLeft
 */
@property (assign, nonatomic) NSTextAlignment textAlignment;

/**
 titleLabel text. default: NaN
 */
@property (retain, nonatomic) UIFont* font;

/**
 the control is in active state;
 */
@property (assign, nonatomic, readonly) BOOL isActive;

/**
 default: rgba(48, 125, 252, 1.000)
 */
@property (retain, nonatomic) UIColor* titleLabelActiveColor UI_APPEARANCE_SELECTOR;

/**
 default: rgba(109, 109, 109, 1.000)
 */
@property (retain, nonatomic) UIColor* titleLabelNormalColor UI_APPEARANCE_SELECTOR;

/**
 defaults to 20.0f;
 */
@property (assign, nonatomic) CGFloat titleLabelActiveHeight UI_APPEARANCE_SELECTOR;


/**
 default: rgba(48, 125, 252, 1.000)
 */
@property (retain, nonatomic) UIColor* dividerActiveColor UI_APPEARANCE_SELECTOR;

/**
 default: rgba(109, 109, 109, 1.000)
 */
@property (retain, nonatomic) UIColor* dividerNormalColor UI_APPEARANCE_SELECTOR;

/**
 defaults to 2;
 */
@property (assign, nonatomic) CGFloat dividerActiveHeight UI_APPEARANCE_SELECTOR;

/**
 defaults to 1;
 */
@property (assign, nonatomic) CGFloat dividerNormalHeight UI_APPEARANCE_SELECTOR;




/**
 default: 16.0f
 */
@property (assign, nonatomic) CGFloat topPadding UI_APPEARANCE_SELECTOR;

/**
 top margin to titleLabelactive state view. default: 8
 */
@property (assign, nonatomic) CGFloat textFieldTopMargin UI_APPEARANCE_SELECTOR;

/**
 bottom margin to divider. default: 8
 */
@property (assign, nonatomic) CGFloat textFieldBottomMargin UI_APPEARANCE_SELECTOR;


/**
 default: rgba(139, 139, 139, 1.000)
 */
@property (retain, nonatomic) UIColor* placeholderColor;

/**
 default 0
 */
@property (assign, nonatomic) CGFloat titleLabelSideMargins UI_APPEARANCE_SELECTOR;


/**
 top margin to bottom of textfield. default: 16
 */
@property (assign, nonatomic) CGFloat helperLabelTopMargin UI_APPEARANCE_SELECTOR;

/**
 default: rgba(139, 139, 139, 1.000)
 */
@property (retain, nonatomic) UIColor* _Nullable helperLabelNormalColor UI_APPEARANCE_SELECTOR;


/**
 textcolor for textfield. default: rgba(33, 33, 33, 1.000)
 */
@property (retain, nonatomic) UIColor* _Nullable textFieldColor UI_APPEARANCE_SELECTOR;


/**
 sets the text for elements
 
 @param title text for the titleLabel which on focus will move on to the top of the textfield
 @param placeholder placeholder appears on textfield when its empty while focused
 @param helper the helper text which appears under textfield
 @param value the text for textfield
 */
-(void)setTitle:(nullable NSString*)title placeholder:(nullable NSString*)placeholder helperText:(nullable NSString*)helper value:(nullable NSString*)value errorText:(nullable NSString*)errorString;

/**
 it will set both titleLabelActiveColor & dividerActiveColor. default: rgba(48, 125, 252, 1.000)
 */
@property (retain, nonatomic) UIColor* _Nullable primaryTintColor UI_APPEARANCE_SELECTOR;



/**
 default: MATTextFieldRequirementTypeNone
 */
@property (assign, nonatomic) MATTextFieldRequirementType requirementType;



/**
 text for titlelabel. default: nil
 */
@property (retain, nonatomic) NSString* _Nullable titleText;


/**
 text for placeholder. default: nil
 */
@property (retain, nonatomic) NSString* _Nullable placeholderText;



/**
 text for helper. default: nil
 */
@property (retain, nonatomic) NSString* _Nullable helperText;


/**
 switches to control to disabled state.
 */
@property (assign, nonatomic) BOOL disabled;


/**
 type of the MATTextField. default: MATTextFieldTypeTextField
 */
@property (assign, nonatomic, readonly) MATTextFieldType type;


/**
 a block to validate the string. return true and false.
 */
@property (copy, nonatomic) BOOL (^ _Nullable validateString)(NSString* _Nullable value);


/**
 if you have different errors for different values use this block. otherwise the error label's text will be equal to errorText.
 */
@property (copy, nonatomic) NSString* (^_Nullable errorForString)(NSString* _Nullable value);

/**
 used in validation. default: rgba(252, 31, 74, 1.000)
 */
@property (retain, nonatomic) UIColor* _Nullable errorColor;

/**
 used in validation. default: _str(@"Error!")
 */
@property (retain, nonatomic) NSString* _Nullable errorText;


/**
 counts the characters and validates the max number of characters entered. See: maxLength. default: false
 */
@property (assign, nonatomic) BOOL showsCounterLabel;

/**
 default: 100. it won't be considered if showsCounterLabel == false;
 */
@property (assign, nonatomic) NSUInteger maxLength;

/**
 if you want a custom string generation for counter label use this block. works only if showsCounterLabel == false;
 */
@property (copy, nonatomic) NSString* (^counterString)(NSUInteger length, NSUInteger maxLength);


/**
 delegate for the textview/textfield.
 */
@property (weak, nonatomic) _Nullable id <MATTextFieldDelegate> delegate;

/**
 text to set for textfield/textview
 */
@property (retain, nonatomic) NSString* _Nullable text;

/**
 default: false
 */
@property (assign, nonatomic) BOOL hidesHelperTextIfDisabled;


/**
 a faster way than textFieldOrViewShouldBeginEditing
 */
@property (copy, nonatomic) BOOL (^ _Nullable shouldBeginEditing)(textFieldOrView fieldOrView);

/**
 a faster way than textFieldOrViewShouldReturn for focusing on the next field.
 */
@property (copy, nonatomic)  UIView* _Nonnull (^ _Nullable nextFieldToFocus)(void);


/**
 returns the underlying textview / textfield.
 */
@property (retain, nonatomic, readonly) textFieldOrView theField;

/**
 default: 2, maximum number of lines to show when in textview mode. [NOTE] works correctly if disableNextLineOnTextView==true. otherwise inputting return on the last line will have a strange behavior.
 */
@property (assign, nonatomic) NSUInteger textViewMaxNumberOfLines;

/**
 Sometimes you want to display a custom view instead of the normal textview or textfield. by setting the view it will be overdrawn on the textfields. the height and width of the view will be assigned by this class.
 */
@property (retain, nonatomic)  UIView* _Nullable customViewAsValue;


/**
 stes the customViewAsValue animated.
 
 @param customViewAsValue the view to display
 @param animated if you want it with animation
 */
-(void)setCustomViewAsValue:(UIView *_Nullable)customViewAsValue animated:(BOOL)animated;

/**
 default: false. if you set this value to true and user touches return on a textview it will move to the next field.
 */
@property (assign, nonatomic) BOOL disableNextLineOnTextView;

/**
 default: true. disables the paste functionality on field.
 */
@property (assign, nonatomic) BOOL pasteDisabled;



/**
 default: NaN. sets the keyboard type for the field.
 */
@property(nonatomic) UIKeyboardType keyboardType;


/**
 only applies if the type is MATTextFieldTypeTextField
 */
@property (assign, nonatomic) BOOL secureTextEntry;

/**
 default: false. after first unfocus event, mattextfield will call validatestring. if you need a continuous validation of strings set this to true.
 */
@property (assign, nonatomic) BOOL validateContinuously;

-(void)forceValidate;
-(void)validateIfNeeded;
@end
