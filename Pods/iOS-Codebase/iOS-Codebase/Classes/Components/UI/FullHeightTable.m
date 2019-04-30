//
//  FullHeightTable.m
//  mactehrannew
//
//  Created by hAmidReza on 8/12/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "FullHeightTable.h"
#import "UIView+SDCAutoLayout.h"
#import "UIView+Extensions.h"

@interface FullHeightTable ()
{
    BOOL initialized;
    NSLayoutConstraint* maxHeightCon;
    
}

@property (retain, nonatomic) NSLayoutConstraint* heightCon;

@end

@implementation FullHeightTable

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    CGFloat h = self.contentSize.height;
//
//
//    NSLog(@"---> %f", h);
//
//    NSLayoutConstraint* possibleHeightCon = [self sdc_get_height];
//    if (!possibleHeightCon)
//        possibleHeightCon = [self sdc_pinHeight:h];
//    else if (fabs(possibleHeightCon.constant - h) > 0.001)
//    {
//        possibleHeightCon.constant = h;
//        [self setNeedsLayout];
//        UIView* finalView2Layout = [[self getNearestVC] view];
//
//        if (!finalView2Layout)
//            return;
//
//        [finalView2Layout  layoutIfNeeded];
//    }
//
//
//
//    self.scrollEnabled = NO;
//}

-(instancetype)init
{
    self = [super init];
    if (self)
        [self initialize];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self initialize];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self initialize];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
        [self initialize];
    return self;
}

-(void)initialize
{
    if (!initialized)
    {
        [super setScrollEnabled:NO];
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        _max_height = 10000;
        maxHeightCon = [self sdc_setMaximumHeight:self.max_height];
        initialized = YES;
    }
}

-(void)setScrollEnabled:(BOOL)scrollEnabled
{
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        CGFloat h = self.contentSize.height;
        
        //        __block NSLayoutConstraint* possibleHeightCon = [self sdc_get_height];
        if (!self.heightCon)
        {
            [UIView sdc_priority:990 block:^{
                self.heightCon = [self sdc_pinHeight:h];
            }];
        }
        else if (fabs(self.heightCon.constant - h) > 0.001)
        {
            self.heightCon.constant = h;
            
            if (h > self.max_height)
                [super setScrollEnabled:true];
            else
                [super setScrollEnabled:false];
        }
        
    }
}

-(void)setMax_height:(CGFloat)max_height
{
    _max_height = max_height;
    maxHeightCon.constant = max_height;
}

-(void)setContentInset:(UIEdgeInsets)contentInset
{
    
}

-(void)setScrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets
{
    
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentSize"];
}

//-(CGSize)intrinsicContentSize
//{
//    return self.contentSize;
//}

@end
