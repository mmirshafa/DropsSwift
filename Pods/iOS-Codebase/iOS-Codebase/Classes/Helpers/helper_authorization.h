//
//  helper_authorization.h
//  iOS-Codebase
//
//  Created by Hamidreza Vakilian on 8/11/1396 AP.
//

#import <Foundation/Foundation.h>

@interface helper_authorization : NSObject

+(void)camera_ask:(BOOL)askForAuthorization authorized:(void (^)())hasAccessBlock restricted:(void (^)())restrictedAccessBlock;

@end
