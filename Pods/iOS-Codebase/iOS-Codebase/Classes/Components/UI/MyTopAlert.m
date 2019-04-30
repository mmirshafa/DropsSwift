//
//  MyTopAlert.m
//  mactehrannew
//
//  Created by hAmidReza on 6/5/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "MyTopAlert.h"
#import "Codebase.h"

#define correspondingTopAlertObjectKey @"MyTopAlert"

@interface MyTopAlert_smallCap : _viewBase
{
    CAShapeLayer* shape;
}

@property (retain, nonatomic) UIColor* color;
@end

@implementation MyTopAlert_smallCap

-(void)initialize
{
    shape = [CAShapeLayer new];
    [self.layer addSublayer:shape];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    UIBezierPath* path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMidY(self.bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds))];
    [path closePath];
    shape.path = path.CGPath;
}

-(void)setColor:(UIColor *)color
{
    shape.fillColor = color.CGColor;
}

-(UIColor *)color
{
    return [UIColor colorWithCGColor:shape.fillColor];
}

@end

#define kAppearanceAnimationDuration .4
#define kMyTopAlertDuration         5
#define kActionViewBottomMargin        20
#define kError_upperTirangleColor rgba(222, 94, 75, 1.000)
#define kError_lowerTirangleColor rgba(212, 90, 67, 1.000)
#define kWarning_upperTirangleColor rgba(253, 164, 46, 1.000)
#define  kWarning_lowerTirangleColor rgba(243, 156, 18, 1.000)


@interface MyTopAlert ()
{
    CAShapeLayer* upperTriangle;
    CAShapeLayer* lowerTriangle;
    
    NSTimer* dismissTimer;
}


@property (retain, nonatomic) UIView* contentView;
@property (retain, nonatomic) UIView* actionHolder;
@property (retain, nonatomic) MyTopAlert_smallCap* smallCap;

@property (weak, nonatomic) UIViewController* vcRef;

@property (retain, nonatomic) NSLayoutConstraint* heightCon;
@property (assign, nonatomic) MyTopAlertType type;
-(void)configureWithType:(MyTopAlertType)type title:(NSString*)title message:(NSString*)message andVC:(UIViewController*)vc;

@end

@implementation MyTopAlert

-(void)initialize
{
    self.clipsToBounds = YES;
    
    _alertDuration = kMyTopAlertDuration;
    _animationDuration = kAppearanceAnimationDuration;
    _alertBottomMargin = kActionViewBottomMargin;
    _error_upperTriangleColor = kError_upperTirangleColor;
    _error_lowerTriangleColor = kError_lowerTirangleColor;
    _warning_upperTriangleColor = kWarning_upperTirangleColor;
    _warning_lowerTriangleColor = kWarning_lowerTirangleColor;
    
    
    _heightCon = [self sdc_setMaximumHeight:0];
    
    _smallCap = [MyTopAlert_smallCap new];
    _smallCap.color = [UIColor greenColor];
    _smallCap.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_smallCap];
    [_smallCap sdc_pinCubicSize:20];
    [_smallCap sdc_alignHorizontalCenterWithView:self];
    [_smallCap sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:self inset:-20];
    
    _contentView = [UIView new];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_contentView];
    [_contentView sdc_alignEdgesWithSuperview:UIRectEdgeAll ^ UIRectEdgeBottom];
    [UIView sdc_priority:UILayoutPriorityDefaultLow block:^{
        [_contentView sdc_alignBottomEdgeWithSuperviewMargin:10];
    }];
    
    upperTriangle = [CAShapeLayer new];
    [_contentView.layer addSublayer:upperTriangle];
    
    lowerTriangle = [CAShapeLayer new];
    [_contentView.layer addSublayer:lowerTriangle];
    
    _icon = [[MyShapeButton alloc] initWithShapeDesc:nil andShapeTintColor:[UIColor whiteColor] andButtonClick:nil];
    _icon.setsCornerRadiusForShapeView = NO;
    _icon.layer.cornerRadius = 40.0f;
    _icon.shapeMargins = UIEdgeInsetsMake(25, 25, 25, 25);
    _icon.layer.borderColor = [UIColor whiteColor].CGColor;
    _icon.layer.borderWidth = 3;
    _icon.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_icon];
    [_icon sdc_pinCubicSize:80];
    [_icon sdc_alignTopEdgeWithSuperviewMargin:_statusBarHeight + 44.0f];
    [_icon sdc_horizontallyCenterInSuperview];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor whiteColor];
    //    _titleLabel.font = [UIFont fontWithName:@"IRANSansMobile-Bold" size:18];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_titleLabel];
    [_titleLabel sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:_icon inset:20];
    [_titleLabel sdc_horizontallyCenterInSuperview];
    
    _messageLabel = [UILabel new];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.numberOfLines = 0;
    //    _messageLabel.font = [UIFont fontWithName:@"IRANSansMobile-Light" size:14];
    _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_messageLabel];
    [_messageLabel sdc_alignSideEdgesWithSuperviewInset:40];
    [_messageLabel sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:_titleLabel inset:5];
    
    //    [_messageLabel sdc_alignBottomEdgeWithSuperviewMargin:25];
    
    _actionHolder = [UIView new];
    _actionHolder.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_actionHolder];
    [_actionHolder sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:_messageLabel inset:10];
    [_actionHolder sdc_horizontallyCenterInSuperview];
    [_actionHolder sdc_alignBottomEdgeWithSuperviewMargin:0];
}

-(void)setIconTop:(CGFloat)iconTop
{
    _iconTop = iconTop;
    [_icon sdc_get_top].constant = iconTop;
}

-(void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    _titleLabel.font = titleFont;
}

-(void)setCaptionFont:(UIFont *)captionFont
{
    _captionFont = captionFont;
    _messageLabel.font = captionFont;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    UIBezierPath* path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(CGRectGetMinX(_contentView.bounds), CGRectGetMinY(_contentView.bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(_contentView.bounds), CGRectGetMinY(_contentView.bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(_contentView.bounds), CGRectGetMaxY(_contentView.bounds))];
    [path closePath];
    upperTriangle.path = path.CGPath;
    
    UIBezierPath* path2 = [UIBezierPath new];
    [path2 moveToPoint:CGPointMake(CGRectGetMaxX(_contentView.bounds), CGRectGetMinY(_contentView.bounds))];
    [path2 addLineToPoint:CGPointMake(CGRectGetMaxX(_contentView.bounds), CGRectGetMaxY(_contentView.bounds))];
    [path2 addLineToPoint:CGPointMake(CGRectGetMinX(_contentView.bounds), CGRectGetMaxY(_contentView.bounds))];
    [path2 closePath];
    lowerTriangle.path = path2.CGPath;
}

+(void)hideTopAlertForVC:(UIViewController*)vc animated:(BOOL)animated
{
    if ([vc dataObjectForKey:correspondingTopAlertObjectKey])
    {
        MyTopAlert* anotherAlert = [vc dataObjectForKey:correspondingTopAlertObjectKey];
        [anotherAlert hideAlertAnimated:animated];
        [vc setDataObject:nil forKey:correspondingTopAlertObjectKey];
    }
}

-(void)setError_lowerTriangleColor:(UIColor *)error_lowerTriangleColor
{
    
    _error_lowerTriangleColor = error_lowerTriangleColor;
    
    if (self.type == MyTopAlertTypeError)
    {
        lowerTriangle.fillColor = _error_lowerTriangleColor.CGColor;
        self.smallCap.color = _error_lowerTriangleColor;;
    }
}

-(void)setError_upperTriangleColor:(UIColor *)error_upperTriangleColor
{
    _error_upperTriangleColor = error_upperTriangleColor;
    
    if (self.type == MyTopAlertTypeError)
        upperTriangle.fillColor = _error_upperTriangleColor.CGColor;
}

-(void)setWarning_lowerTriangleColor:(UIColor *)warning_lowerTriangleColor
{
    _warning_lowerTriangleColor = warning_lowerTriangleColor;
    
    if (self.type == MyTopAlertTypeWarning)
    {
        lowerTriangle.fillColor = warning_lowerTriangleColor.CGColor;
        self.smallCap.color = warning_lowerTriangleColor;;
    }
}

-(void)setWarning_upperTriangleColor:(UIColor *)warning_upperTriangleColor
{
    _warning_upperTriangleColor = warning_upperTriangleColor;
    
    if (self.type == MyTopAlertTypeWarning)
        upperTriangle.fillColor = warning_upperTriangleColor.CGColor;
}

-(void)configureWithType:(MyTopAlertType)type title:(NSString*)title message:(NSString*)message andVC:(UIViewController*)vc andActionView:(UIView*)action
{
    BOOL configTimer = YES;
    
    if ([vc dataObjectForKey:correspondingTopAlertObjectKey])
    {
        MyTopAlert* anotherAlert = [vc dataObjectForKey:correspondingTopAlertObjectKey];
        [anotherAlert hideAlertAnimated:YES];
        [_vcRef setDataObject:nil forKey:correspondingTopAlertObjectKey];
    }
    
    [vc setDataObject:self forKey:correspondingTopAlertObjectKey];
    
    self.type = type;
    
    if (type == MyTopAlertTypeError)
    {
        upperTriangle.fillColor = _error_upperTriangleColor.CGColor;
        lowerTriangle.fillColor = _error_lowerTriangleColor.CGColor;
        _smallCap.color = _error_lowerTriangleColor;
        
        _titleLabel.text = title;
        _messageLabel.text = message;
        _vcRef = vc;
        if (action)
        {
            action.translatesAutoresizingMaskIntoConstraints = NO;
            [_actionHolder addSubview:action];
            [action sdc_alignEdgesWithSuperview:UIRectEdgeAll insets:UIEdgeInsetsMake(0, 0, -_alertBottomMargin, 0)];
            configTimer = NO;
        }
        
        _icon.shapeView.shapeDesc = __codebase_k_iconCrossHeavy();
    }
    else if (type == MyTopAlertTypeWarning)
    {
        upperTriangle.fillColor = _warning_upperTriangleColor.CGColor;
        lowerTriangle.fillColor = _warning_lowerTriangleColor.CGColor;
        _smallCap.color = _warning_lowerTriangleColor;
        
        _titleLabel.text = title;
        _messageLabel.text = message;
        _vcRef = vc;
        if (action)
        {
            action.translatesAutoresizingMaskIntoConstraints = NO;
            [_actionHolder addSubview:action];
            [action sdc_alignEdgesWithSuperview:UIRectEdgeAll insets:UIEdgeInsetsMake(0, 0, -_alertBottomMargin, 0)];
            configTimer = NO;
            
        }
        
        _icon.shapeView.shapeDesc = __codebase_k_iconWarning();
    }
    
    if (configTimer)
    {
        
        
        _mainThreadAsync(^{ //letting the appearance setter methods call before running this. especially for _alertDuration here.
            
            
            _mainThreadAfter(^{
                [self hideAlertAnimated:YES];
                [_vcRef setDataObject:nil forKey:correspondingTopAlertObjectKey];
            }, _alertDuration);
            
        });
        
    }
}

-(void)hideAlertAnimated:(BOOL)animated
{
    _heightCon.constant = 0;
    [UIView animateWithDuration:animated ? _animationDuration : 0 animations:^{
        [_vcRef.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)showAlertAnimated:(BOOL)animated
{
    self.heightCon.constant = 10000;
    [UIView animateWithDuration:animated ? _animationDuration : 0 animations:^{
        [_vcRef.view layoutIfNeeded];
    }];
}

+(void)presentAlertType:(MyTopAlertType)type title:(NSString*)title message:(NSString*)message onViewController:(UIViewController*)vc alignWithTopOfView:(UIView*)alignTopWithView
{
    [self presentAlertType:type title:title message:message onViewController:vc alignWithTopOfView:alignTopWithView actionView:nil];
}

+(void)presentAlertType:(MyTopAlertType)type title:(NSString*)title message:(NSString*)message onViewController:(UIViewController*)vc
{
    [self presentAlertType:type title:title message:message onViewController:vc actionView:nil];
}

+(void)presentAlertType:(MyTopAlertType)type title:(NSString*)title message:(NSString*)message onViewController:(UIViewController*)vc optionsBlock:(void (^)(MyTopAlert* topAlert))topAlertBlock
{
    [self presentAlertType:type title:title message:message onViewController:vc alignWithTopOfView:nil actionView:nil optionsBlock:topAlertBlock];
}

+(void)presentAlertType:(MyTopAlertType)type title:(NSString*)title message:(NSString*)message onViewController:(UIViewController*)vc actionView:(UIView *)actionView
{
    [self presentAlertType:type title:title message:message onViewController:vc alignWithTopOfView:nil actionView:actionView optionsBlock:nil];
}

+(void)presentAlertType:(MyTopAlertType)type title:(NSString*)title message:(NSString*)message onViewController:(UIViewController*)vc alignWithTopOfView:(UIView*)alignTopWithView actionView:(UIView *)actionView
{
    [self presentAlertType:type title:title message:message onViewController:vc alignWithTopOfView:alignTopWithView actionView:actionView optionsBlock:nil];
}

+(void)presentAlertType:(MyTopAlertType)type title:(NSString*)title message:(NSString*)message onViewController:(UIViewController*)vc alignWithTopOfView:(UIView*)alignTopWithView actionView:(UIView *)actionView optionsBlock:(void (^)(MyTopAlert* topAlert))topAlertBlock
{
    hapticNotiError;
    MyTopAlert* myTopAlert = [MyTopAlert new];
    [myTopAlert configureWithType:type title:title message:message andVC:vc andActionView:actionView];
    if (topAlertBlock)
        topAlertBlock(myTopAlert);
    myTopAlert.translatesAutoresizingMaskIntoConstraints = NO;
    if ([vc.view respondsToSelector:@selector(_addSubview:)])
        [vc.view performSelector:@selector(_addSubview:) withObject:myTopAlert];
    else
        [vc.view addSubview:myTopAlert];
    [myTopAlert sdc_alignSideEdgesWithSuperviewInset:0];
    if (!alignTopWithView)
        [myTopAlert sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeTop ofView:vc.view];
    else
        [myTopAlert sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeTop ofView:alignTopWithView];
    [vc.view layoutIfNeeded];
    [myTopAlert showAlertAnimated:YES];
}

@end
