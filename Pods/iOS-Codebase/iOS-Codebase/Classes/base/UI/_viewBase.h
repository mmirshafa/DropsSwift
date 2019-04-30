//
//  _viewBase.h
//  mactehrannew
//
//  Created by hAmidReza on 5/1/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _viewBase : UIView

-(instancetype)_init;
-(void)initialize;
-(void)configureWithDictionary:(NSMutableDictionary*)dic;

@end
