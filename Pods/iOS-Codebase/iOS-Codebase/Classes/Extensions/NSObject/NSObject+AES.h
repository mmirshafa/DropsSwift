//
//  NSObject+AES.h
//  Prediscore
//
//  Created by Hamidreza Vaklian on 5/24/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AES)

-(NSData *)AES256EncryptWithKey:(NSString *)key;
-(NSData *)AES256DecryptWithKey:(NSString *)key;

@end
