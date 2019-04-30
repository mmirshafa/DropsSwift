//
//  DFSharedService.h
//  df
//
//  Created by Hamidreza Vakilian on 1/9/1397 AP.
//  Copyright © 1397 Hamidreza Vakilian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySharedService : NSObject

-(void)initialize;

+(instancetype)instance;

/*! @abstract Use + instance instead */
-(instancetype)init NS_UNAVAILABLE;

/*! @abstract Use + instance instead */
+(instancetype)new NS_UNAVAILABLE;

@end
