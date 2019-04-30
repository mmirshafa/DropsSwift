//
//  _tableViewSuperHeaderFooterBase.h
//  FieldBooker
//
//  Created by hAmidReza on 5/13/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _tableViewSuperHeaderFooterBase : UIView

-(void)initialize;
-(void)configAutoLayout;
-(void)configureWithDesc:(NSMutableDictionary*)dic;

@property (retain, nonatomic) UIView* contentView;

@property (copy, nonatomic) void (^onDidLayout) (_tableViewSuperHeaderFooterBase* header);
@property (copy, nonatomic) void (^onDidInitialLayout) (_tableViewSuperHeaderFooterBase* header);
@end
