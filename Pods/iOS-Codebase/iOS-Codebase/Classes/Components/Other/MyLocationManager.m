//
//  MyLocationManager.m
//  Prediscore
//
//  Created by Hamidreza Vaklian on 6/1/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import "MyLocationManager.h"
#import "helper.h"
//#import "UIViewController+PPTopMostController.h"

#import <PPTopMostController/UIViewController+PPTopMostController.h>

@interface MyLocationManager () <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    bool delegateWaitingForUpdate;
}
@end

@implementation MyLocationManager

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    [self configLocationManager];
}

-(void)configLocationManager
{
		_mainThread(^{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager requestWhenInUseAuthorization];
				});
}

-(void)updateLocation
{

		
	
    delegateWaitingForUpdate = YES;
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways)
        [locationManager requestWhenInUseAuthorization];
    else
        [locationManager startUpdatingLocation];

}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus: %d", status);
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
        [locationManager startUpdatingLocation];
    else if (status == kCLAuthorizationStatusDenied)
    {
		[self presentEnableLocationServicesDialog];
    }
}

-(void)presentEnableLocationServicesDialog
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Enable Location Services" message:@"Open Settings\nTap Location\nSelect 'While Using the App'" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* openSettingsAction = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openSettings];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (_errorCallback)
			_errorCallback(@{@"msg": @"Not authorized;"});
    }];
    
    [alertController addAction:openSettingsAction];
    [alertController addAction:cancelAction];
    
    [[UIViewController topMostController] presentViewController:alertController animated:YES completion:nil];
}

- (void)openSettings
{
    if (UIApplicationOpenSettingsURLString) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"failed %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (delegateWaitingForUpdate)
    {
		[locationManager stopUpdatingLocation];
		delegateWaitingForUpdate = NO;
	if (_locationCallback)
		_locationCallback(newLocation.coordinate);
	
    

    }
}


@end
