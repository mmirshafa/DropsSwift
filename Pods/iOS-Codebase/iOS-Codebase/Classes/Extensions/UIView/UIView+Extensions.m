//
//  UIView+Extensions.m
//  Kababchi
//
//  Created by hAmidReza on 7/3/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "UIView+Extensions.h"
#import "NSObject+DataObject.h"
#import "VCAppearanceRelatedProtocol.h"

@implementation UIView (Extensions)

-(id)getNearestVC
{
    UIView* nextView = self;
    while (![nextView.nextResponder isKindOfClass:[UIViewController class]] && nextView != nil)
    {
        nextView = nextView.superview;
    }
    
    return nextView.nextResponder;
}

-(id)getNearestVCByClass:(NSString*)class_str
{
    UIView* nextView = self;
    while (![nextView.nextResponder isKindOfClass:NSClassFromString(class_str)] && nextView != nil)
    {
        nextView = nextView.superview;
    }
    
    return nextView.nextResponder;
}

+(instancetype)new2
{
    UIView* result = [self new];
    result.translatesAutoresizingMaskIntoConstraints = NO;
    return result;
}

-(id)getNearestParentViewByClass:(NSString*)class_str
{
    UIView* parent = self;
    while (![parent isKindOfClass:NSClassFromString(class_str)] && parent != nil)
        parent = parent.superview;
    
    return parent;
}

- (UIView *)findFirstResponder
{
    if ([self isFirstResponder])
        return self;
    
    for (UIView * subView in self.subviews)
    {
        UIView * fr = [subView findFirstResponder];
        if (fr != nil)
            return fr;
    }
    
    return nil;
}

-(void)setRatioBasedRoundCorner:(CGFloat)ratioBasedRoundCorner
{
    [self setDataObject:@(ratioBasedRoundCorner) forKey:@"_ratioBasedRoundCorner"];
    if (ratioBasedRoundCorner > 0)
    {
        [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
    }
    else if (ratioBasedRoundCorner <= 0)
    {
        [self removeObserver:self forKeyPath:@"bounds"];
    }
    
    [self __updateRoundCorner];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"])
    {
        [self __updateRoundCorner];
    }
}

-(void)__updateRoundCorner
{
    CGFloat ratio = [self ratioBasedRoundCorner];
    self.layer.cornerRadius = ratio * self.bounds.size.width;
}

-(CGFloat)ratioBasedRoundCorner
{
    return [[self dataObjectForKey:@"_ratioBasedRoundCorner"] floatValue];
}

-(void)propagateViewWillAppearInSubviewsAnimated:(BOOL)animated
{
    for (NSObject<VCAppearanceRelatedProtocol>* aView in self.subviews) {
        if ([aView respondsToSelector:@selector(viewWillAppear:)])
            [aView viewWillAppear:animated];
        [aView propagateViewWillAppearInSubviewsAnimated:animated];
    }
}

@end
