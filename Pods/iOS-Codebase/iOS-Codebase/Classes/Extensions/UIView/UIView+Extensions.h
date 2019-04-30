//
//  UIView+Extensions.h
//  Kababchi
//
//  Created by hAmidReza on 7/3/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extensions)

@property (assign, nonatomic) CGFloat ratioBasedRoundCorner; //with respect to width

-(id)getNearestVC;
-(id)getNearestVCByClass:(NSString*)class_str;
-(id)getNearestParentViewByClass:(NSString*)class_str;
-(UIView *)findFirstResponder;


/**
 initializes the view with setting translatesAutoresizingMaskIntoConstraints to false
 
 @return the new instance
 */
+(instancetype)new2;
-(void)propagateViewWillAppearInSubviewsAnimated:(BOOL)animated;
@end
