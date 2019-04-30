//
//  NSObject+deepMutableCopy.h
//  Prediscore
//
//  Created by Hamidreza Vaklian on 6/4/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (deepMutableCopy)

//this function only supports items of kinds: (nsstring, nsnumber, nsarray and nsdictionary) even nsnull won't work and it returns nil for the whole json.
-(id)deepMutableCopy;

@end
