//
//  _cbBasedUIControl.h
//  oncost
//
//  Created by Hamidreza Vakilian on 3/11/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _cbBasedUIControl : UIControl

@property (copy, nonatomic) void (^highlight)(id sender, UIEvent* event);
@property (copy, nonatomic) void (^unhighlightSuccessful)(id sender, UIEvent* event);
@property (copy, nonatomic) void (^unhighlightCancelled)(id sender, UIEvent* event);
@end
