//
//  _MKAnnotationViewBase.h
//  Kababchi
//
//  Created by hAmidReza on 6/14/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface _MKAnnotationViewBase : MKAnnotationView

-(void)initialize;
+(NSString*)reuseIdentifier;

@end
