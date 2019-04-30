//
//  MKMapView+Extenstions.m
//  Kababchi
//
//  Created by hAmidReza on 6/15/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "MKMapView+Extenstions.h"

@implementation MKMapView (Extenstions)

-(void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate spanDelata:(CGFloat)span animated:(BOOL)animated
{
	MKCoordinateRegion region;
	region.span.latitudeDelta = span;
	region.span.longitudeDelta = span;
	region.center = centerCoordinate;
	[self setRegion:region animated:animated];
}

@end
