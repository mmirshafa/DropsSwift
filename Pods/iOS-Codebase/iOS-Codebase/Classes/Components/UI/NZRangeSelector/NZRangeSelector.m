//
//  NZRangeSelector.m
//  Gear-iOS
//
//  Created by Developer on 11/28/18.
//  Copyright © 2018 Nizek. All rights reserved.
//

#import "NZRangeSelector.h"
#import "NZRangeSelectorDefaultHandle.h"


#define sideMargin 20.0f

@interface NZRangeSelector ()
{
    BOOL isInitialized;
}

@property (retain, nonatomic) UIView* trackView;
@property (retain, nonatomic) UIView* rangeView;
@property (retain, nonatomic) NZRangeSelectorDefaultHandle* leftHandleInstance;
@property (retain, nonatomic) NZRangeSelectorDefaultHandle* rightHandleInstance;

@property (retain, nonatomic) Class leftHandleClass;
@property (retain, nonatomic) Class rightHandleClass;




@end

@implementation NZRangeSelector

-(instancetype)initWithLeftHandle:(Class)leftHandleClass andRightHandle:(Class)rightHandleClass
{
    self = [super init];
    if (self)
    {
        if (leftHandleClass)
            self.leftHandleClass = leftHandleClass;
        else
            self.leftHandleClass = NZRangeSelectorDefaultHandle.class;
        if (rightHandleClass)
            self.rightHandleClass = rightHandleClass;
        else
            self.rightHandleClass = NZRangeSelectorDefaultHandle.class;
        
        [self initialize];
    }
    return self;
}

-(void)setDefaults
{
    _trackColor = [UIColor colorWithRed:0.780 green:0.780 blue:0.801 alpha:1.000];
    _tintColor = [UIColor blackColor];
    _trackHeight = 4.0f;
}

-(void)initialize
{
    if (!isInitialized)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setDefaults];
        
        self.trackView = [UIView new];
        self.trackView.backgroundColor = self.trackColor;
        self.trackView.layer.cornerRadius = self.trackHeight / 2.0f;
        self.trackView.layer.masksToBounds = YES;
        [self addSubview:self.trackView];
        
        self.rangeView = [UIView new];
        self.rangeView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.rangeView];
        
        self.leftHandleInstance = [[self.leftHandleClass alloc] init];
        [self addSubview:self.leftHandleInstance];
        
        if ([self.leftHandleInstance respondsToSelector:@selector(NZRangeSelector:configureWithType:)])
            [self.leftHandleInstance NZRangeSelector:self configureWithType:NZRangeSelectorHandleLeft];
        
        UIPanGestureRecognizer* leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
        [self.leftHandleInstance addGestureRecognizer:leftPan];
        
        self.rightHandleInstance = [[self.rightHandleClass alloc] init];
        [self addSubview:self.rightHandleInstance];
        
        if ([self.rightHandleInstance respondsToSelector:@selector(NZRangeSelector:configureWithType:)])
            [self.rightHandleInstance NZRangeSelector:self configureWithType:NZRangeSelectorHandleRight];
        
        UIPanGestureRecognizer* rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
        [self.rightHandleInstance addGestureRecognizer:rightPan];
        
        
        isInitialized = YES;
    }
}

-(void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    self.rangeView.backgroundColor = tintColor;
    self.leftHandleInstance.tintColor = tintColor;
    self.rightHandleInstance.tintColor = tintColor;
}

- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged)
    {
        [self bringSubviewToFront:self.leftHandleInstance];
        
        CGPoint translation = [gesture translationInView:self];
        
        CGFloat trackRange = self.maxValue - self.minValue;
        
        CGFloat lPrim = (translation.x * trackRange) / CGRectGetWidth(self.frame);
        
        CGFloat finalL = self.leftValue + lPrim;
        
        finalL = MAX(MIN(finalL, self.rightValue - self.minDistance), self.minValue);
        
        if (finalL != self.leftValue)
        {
            self.leftValue = finalL;
            [gesture setTranslation:CGPointZero inView:self];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            
        }
        
        NZRangeSelectorEvent event = NZRangeSelectorEventChanged;
        if (gesture.state == UIGestureRecognizerStateBegan) {
            event = NZRangeSelectorEventBegan;
        }
        [self.leftHandleInstance NZRangeSelector:self event:event value:finalL];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled)
    {
        [self.leftHandleInstance NZRangeSelector:self event:NZRangeSelectorEventEnded value:self.leftValue];
    }
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged)
    {
        [self bringSubviewToFront:self.rightHandleInstance];
        
        CGPoint translation = [gesture translationInView:self];
        
        CGFloat trackRange = self.maxValue - self.minValue;
        
        CGFloat rPrim = (translation.x * trackRange) / CGRectGetWidth(self.frame);
        
        CGFloat finalR = self.rightValue + rPrim;
        
        finalR = MAX(MIN(finalR, self.maxValue), self.leftValue + self.minDistance);
        
        if (finalR != self.rightValue)
        {
            self.rightValue = finalR;
            [gesture setTranslation:CGPointZero inView:self];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        
        NZRangeSelectorEvent event = NZRangeSelectorEventChanged;
        if (gesture.state == UIGestureRecognizerStateBegan) {
            event = NZRangeSelectorEventBegan;
        }
        [self.rightHandleInstance NZRangeSelector:self event:event value:finalR];

    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled)
    {
        [self.rightHandleInstance NZRangeSelector:self event:NZRangeSelectorEventEnded value:self.rightValue];
    }
}

-(void)drawRect:(CGRect)rect
{
    
    self.trackView.frame = CGRectMake(sideMargin, (CGRectGetHeight(rect) - self.trackHeight) / 2.0f, CGRectGetWidth(rect) - 2*sideMargin, self.trackHeight);
    
    [self refreshLeftHandleAnimated:NO];
    
    [self refreshRightHandleAnimated:NO];
    
    [self refreshRangeViewAnimated:NO];
    
    
}

-(void)refreshRangeViewAnimated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? .3 : 0 animations:^{
        self.rangeView.frame = CGRectMake(CGRectGetMidX(self.leftHandleInstance.frame), CGRectGetMinY(self.trackView.frame), CGRectGetMinX(self.rightHandleInstance.frame) - CGRectGetMinX(self.leftHandleInstance.frame), CGRectGetHeight(self.trackView.frame));
    }];
    
}

-(void)refreshLeftHandleAnimated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? .3 : 0 animations:^{
        CGFloat leftHandleX = (CGRectGetWidth(self.trackView.frame) * self.leftValue) / MAX( self.maxValue - self.minValue, 1);//prevent division by zero
        leftHandleX = leftHandleX - 22;
        self.leftHandleInstance.frame = CGRectMake(leftHandleX + CGRectGetMinX(self.trackView.frame), CGRectGetMidY(self.trackView.frame) - 22.0f, 44.0f, 44.0f);
    }];
}

-(void)setLeftValue:(float)leftValue
{
    [self setLeftValue:leftValue animated:NO];
}

-(void)setLeftValue:(float)leftValue animated:(BOOL)animated
{
    _leftValue = leftValue;
    
    if (animated)
        [self refreshLeftHandleAnimated:YES];
    else
        [self refreshLeftHandleAnimated:NO];
    
    [self refreshRangeViewAnimated:animated];
}

-(void)refreshRightHandleAnimated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? .3 : 0 animations:^{
        CGFloat rightHandleX = (CGRectGetWidth(self.trackView.frame) * self.rightValue) / MAX( self.maxValue - self.minValue, 1);//prevent division by zero
        rightHandleX = rightHandleX - 22;
        self.rightHandleInstance.frame = CGRectMake(rightHandleX + CGRectGetMinX(self.trackView.frame), CGRectGetMidY(self.trackView.frame) - 22.0f, 44.0f, 44.0f);
    }];
}

-(void)setRightValue:(float)rightValue
{
    [self setRightValue:rightValue animated:NO];
}

-(void)setRightValue:(float)rightValue animated:(BOOL)animated
{
    _rightValue = rightValue;
    
    if (animated)
        [self refreshRightHandleAnimated:YES];
    else
        [self refreshRightHandleAnimated:NO];
    
    [self refreshRangeViewAnimated:animated];
}

-(void)setTrackColor:(UIColor *)trackColor
{
    _trackColor = trackColor;
    self.trackView.backgroundColor = trackColor;
}

-(void)setTrackHeight:(CGFloat)trackHeight
{
    _trackHeight = trackHeight;
    self.trackView.layer.cornerRadius = trackHeight / 2.0f;
    [self setNeedsDisplay];
}
@end
