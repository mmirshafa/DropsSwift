//
//  MyLocationManager.h
//  Prediscore
//
//  Created by Hamidreza Vaklian on 6/1/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MyLocationManager : NSObject

@property (copy, nonatomic) void (^locationCallback)(CLLocationCoordinate2D cordinate);
@property (copy, nonatomic) void (^errorCallback)(NSDictionary*err);

-(void)updateLocation;

@end
