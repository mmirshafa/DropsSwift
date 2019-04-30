//
//  UIViewController+MyAppearance.h
//  appearance_Test
//
//  Created by hAmidReza on 8/31/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol uniconf <NSObject>
@optional
-(void)uniconf_restore;
@end

@interface NSObject (uniconf)
+(instancetype)uniconf;
@end
