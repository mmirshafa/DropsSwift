//
//  NSURLSessionTask+retry.h
//  Prediscore
//
//  Created by hAmidReza on 10/19/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSessionTask (retryTask)

-(NSURLSessionTask*)retryTask;

@end
