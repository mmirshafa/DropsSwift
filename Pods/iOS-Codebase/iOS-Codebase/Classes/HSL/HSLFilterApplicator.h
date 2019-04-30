//
//  FilterApplicator.h
//  macTehran
//
//  Created by Hamidreza Vaklian on 1/20/16.
//  Copyright © 2016 Hamidreza Vaklian. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "HSLColorizeFilterInverse.h"
#import "HSLColorizeFilter.h"

@interface HSLFilterApplicator : NSObject

+(void)HSLFilterImage:(UIImage*)image fromColor:(UIColor*)source_color toColor:(UIColor*)destination_color callback:(void (^)(UIImage* filteredImage))completionHandler;
+(UIImage*)HSLFilterImage:(UIImage*)image fromColor:(UIColor*)source_color toColor:(UIColor*)destination_color;

@end
