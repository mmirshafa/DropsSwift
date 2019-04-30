//
//  NSString+base64.h
//  PrediScoreApp
//
//  Created by hAmidReza on 3/28/15.
//  Copyright (c) 2015 pxlmind.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (base64)

-(NSString*)base64Encode;
-(NSString*)base64Decode;
-(NSData*)base64Decode2;

@end
