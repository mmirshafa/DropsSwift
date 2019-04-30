//
//  _HomeBaseNavBar.m
//  Kababchi
//
//  Created by hAmidReza on 7/20/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "_HomeBaseNavBar.h"
#import "UIView+SDCAutoLayout.h"

@implementation _HomeBaseNavBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.shadowImage = [UIImage new];
        self.translucent = YES;
        self.tintColor = [UIColor whiteColor];
        
        //        self.titleTextAttributes = ;
        
        _leftButton = [[MyShapeButton alloc] initWithShapeDesc:nil andShapeTintColor:[UIColor whiteColor] andButtonClick:nil];
        _leftButton.shapeMargins = UIEdgeInsetsMake(11, 11, 11, 11);
        [self addSubview:_leftButton];
        
        _rightButton = [[MyShapeButton alloc] initWithShapeDesc:nil andShapeTintColor:[UIColor whiteColor] andButtonClick:nil];
        _rightButton.shapeMargins = UIEdgeInsetsMake(11, 11, 11, 11);
        [self addSubview:_rightButton];
        
        [self uniconf_restore];
    }
    return self;
}

//-(void)setTheTitleTextAttributes:(NSDictionary *)theTitleTextAttributes
//{
//    self.titleTextAttributes = theTitleTextAttributes;
//}
//
//-(NSDictionary *)theTitleTextAttributes
//{
//    return self.titleTextAttributes;
//}
-(void)setU_titleTextAttributes:(NSDictionary *)u_titleTextAttributes
{
    self.titleTextAttributes = u_titleTextAttributes;
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//
//
//}

-(NSDictionary *)u_titleTextAttributes
{
    return self.titleTextAttributes;
}
//-(void)setTheDelegate:(id<_HomeBaseNavBarDelegate>)theDelegate
//{
//    _theDelegate = theDelegate;
//    if ([_theDelegate respondsToSelector:@selector(HomeBaseNavBarTitleTextAttributes)])
//        self.titleTextAttributes = [_theDelegate HomeBaseNavBarTitleTextAttributes];
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    _rightButton.frame = CGRectMake(self.frame.size.width - 44, 0, 44, 44);
    
    
    // I dont remember why i did this but causes the _UINavigationBarContentView to come over the buttons and since it's userInteraction is enabled, the buttons won't work anymore! so I commented the following lines. ----> because it appears over the back button of the _homebasevc!
    
    if (!self.bringButtonsToFront)
    {
        [self sendSubviewToBack:_leftButton];
        [self sendSubviewToBack:_rightButton];
    }
    else
    {
        [self bringSubviewToFront:_leftButton];
        [self bringSubviewToFront:_rightButton];
    }
    
    // to remove empty margin on left and right for navigation items  (leftbarbuttonitem and the rightbarbuttonitem)
    for (UIView* view in [self subviews])
        view.layoutMargins = UIEdgeInsetsZero;
}

@end
