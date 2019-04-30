//
//  LGSideMenuBorderView.m
//  LGSideMenuController
//
//
//  The MIT License (MIT)
//
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>
//  (https://github.com/Friend-LGA/LGSideMenuController)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "LGSideMenuBorderView.h"
#import "UIView+SDCAutoLayout.h"
#import "MyShadowView.h"

@interface LGSideMenuBorderView ()
@property (retain, nonatomic) MyShadowView* shadowView;
@end

@implementation LGSideMenuBorderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.userInteractionEnabled = NO;
        
        self.shadowView = [MyShadowView new];
        self.shadowView.translatesAutoresizingMaskIntoConstraints = NO;
        [super addSubview:self.shadowView];
        [self.shadowView sdc_alignEdgesWithSuperview:UIRectEdgeAll insets:UIEdgeInsetsMake(6, 6, -6, -6)];
    }
    return self;
}

-(void)setH_cornerRadius:(CGFloat)h_cornerRadius
{
    _h_cornerRadius = h_cornerRadius;
    [self setCornerRadius:h_cornerRadius];
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.shadowView.cornerRadius = cornerRadius;
}

-(void)setH_shadowColor:(UIColor *)h_shadowColor
{
    _h_shadowColor = h_shadowColor;
    self.shadowView.shadowColor = h_shadowColor;
}

-(void)setH_shadowOffset:(CGSize)h_shadowOffset
{
    _h_shadowOffset = h_shadowOffset;
    self.shadowView.shadowOffset = h_shadowOffset;
}

-(void)setH_shadowRadius:(CGFloat)h_shadowRadius
{
    _h_shadowRadius = h_shadowRadius;
    self.shadowView.shadowRadius = h_shadowRadius;
}

-(void)setH_shadowOpacity:(CGFloat)h_shadowOpacity
{
    _h_shadowOpacity = h_shadowOpacity;
    self.shadowView.shadowOpacity = h_shadowOpacity;
}

@end
