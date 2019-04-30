//
//  emImageView.m
//  HVFancyEffects
//
//  Created by hAmidReza on 5/19/92.
//  Copyright (c) 1392 hAmidReza. All rights reserved.
//

#import "emImageShow.h"
#import "UIView+Extensions.h"
#import "UIView+SDCAutoLayout.h"
#import "Codebase_definitions.h"
//#import "emFunctions.h"
//#import "UIView+MTAnimation.h"
//#import <QuartzCore/QuartzCore.h>
//#import <ImageIO/ImageIO.h>
//#import <MobileCoreServices/MobileCoreServices.h>
//#import "FileManagement.h"
//#import "HyperImageView.h"

@interface emImageShow ()
{
    int image_index;
    NSMutableArray* arrayOfThumbnails;
    //    NSDictionary* imagesDictionary;
    
    NSMutableArray* lastCons;
    UIView *lastEnlargedItem;
    
    NSTimer *dispatchAwaker;
    
    UIImageView* panels[2];
    int panelIndex;
    
    BOOL canChooseThumbnail;
}

@end

@implementation emImageShow


-(instancetype)initWithImageArray:(NSArray<UIImage*>*)imageArray
{
    self = [super init];
    if (self)
    {
        _switchingInterval = 5.0f;
        _switchingDuration = 1.3f;
        _scaleMax = 1.1f;
        _scaleMin = 1.0f;
        _imageArray = imageArray;
        
        
        image_index = 0;
        
        panels[0] = [UIImageView new2];
        panels[0].contentMode = UIViewContentModeScaleAspectFill;
        panels[1] = [UIImageView new2];
        panels[1].contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:panels[1]];
        [self addSubview:panels[0]];
        
        [panels[0] sdc_pinSizeToSizeOfView:self offset:UIOffsetMake(left_margin*2, top_margin*2)];
        [panels[0] sdc_centerInSuperview];
        [panels[1] sdc_pinSizeToSizeOfView:self offset:UIOffsetMake(left_margin*2, top_margin*2)];
        [panels[1] sdc_centerInSuperview];;
        panelIndex = 0;
    }
    return self;
}

-(void)stop
{
    //    dispatch_suspend(theDispatchQueue);
}

-(void)beginSliding
{
    //    int width = (self.frame.size.width + 2 * left_margin);
    //    int height = (self.frame.size.height + 2 * top_margin);
    
    
    
    panels[panelIndex].image = self.imageArray[image_index];
    
    [self bringSubviewToFront:panels[panelIndex]];
    
    [self moveRandom:panels[panelIndex] andScale:1.0];
    
    
    [self layoutIfNeeded];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.switchingInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self transitToNextImage];
    });
}


-(void)transitToNextImage
{
    image_index = ++image_index % [self.imageArray count];
    
    [self switchToImageWithIndex:image_index];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.switchingInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self transitToNextImage];
    });
    
}

-(void)switchToImageWithIndex:(int)index
{
    UIImageView* currentPanel = panels[panelIndex%2];
    
    UIImageView* nextPanel =  panels[++panelIndex%2];
    nextPanel.image = self.imageArray[index];
    nextPanel.alpha = 1.0f;
    
    CGFloat scaleFrom = _map(arc4random_uniform(1000), 0, 999, _scaleMin, _scaleMax);
    CGFloat scaleTo = _map(arc4random_uniform(1000), 0, 999, _scaleMin, _scaleMax);
    
//    NSLog(@"%f %f", scaleFrom, scaleTo);
    
    
    nextPanel.transform = CGAffineTransformMakeScale(scaleFrom, scaleFrom);
    
    [UIView animateWithDuration:self.switchingDuration animations:^{
        currentPanel.alpha = 0;
    } completion:^(BOOL K){
        currentPanel.transform = CGAffineTransformIdentity;
        [currentPanel sdc_get_horizontalCenter].constant = 0;
        [currentPanel sdc_get_verticalCenter].constant = 0;
        //        currentPanel.frame = CGRectMake(-left_margin, -top_margin, self.frame.size.width + 2*left_margin, self.frame.size.height+2*top_margin);
        [self bringSubviewToFront:nextPanel];
    }];
    
    [self moveRandom:nextPanel andScale:scaleTo];
}


-(void)moveRandom:(UIView*)view andScale:(CGFloat)scaleTo
{
    float x_shift = (float) arc4random_uniform(top_margin) * pow(-1, arc4random_uniform(2));
    float y_shift = (float) arc4random_uniform(left_margin) * pow(-1, arc4random_uniform(2));
    
    x_shift = MIN(15 * (x_shift / fabsf(x_shift)) , fabsf(x_shift));
    y_shift = MIN(15 * (y_shift / fabsf(y_shift)) , fabsf(y_shift));
    
    
    [view sdc_get_horizontalCenter].constant = x_shift;
    [view sdc_get_verticalCenter].constant = y_shift;
    
    [UIView animateWithDuration:self.switchingInterval*1.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //        view.frame = CGRectMakeDiff(view, x_shift, y_shift, 0, 0);
        
        [self layoutIfNeeded];
        
        view.transform = CGAffineTransformMakeScale(scaleTo, scaleTo);
        
    } completion:^(BOOL k) {}];
}

@end
