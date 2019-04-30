//
//  UIView+xsnapshot.h
//  Prediscore
//
//  Created by hAmidReza on 11/4/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CALayer (xsnapshot)

-(UIImage*)imageSnapshot;

@end

@interface UIView (xsnapshot)

-(UIImageView*)xsnapshotAfterScreenUpdates:(BOOL)after;
-(UIImage*)imageSnapshot;

@end

