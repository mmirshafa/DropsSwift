//
//  MyLocationPicker.m
//  Kababchi
//
//  Created by hAmidReza on 7/20/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "MyLocationPicker.h"
#import "_HomeBaseNavBar.h"
#import "MKMapView+Extenstions.h"
#import "Codebase_definitions.h"
#import "helper.h"
#import "MyShapeView.h"
#import "UIView+SDCAutoLayout.h"
#import "MyLocationManager.h"

@interface MyLocationPicker () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    BOOL initialZoomAnimationDone;
}

@property (retain, nonatomic) MyShapeButton *currentLocationButton;
@property (retain, nonatomic) MKMapView *mapView;
@property (retain, nonatomic) MyLocationPickerIndicatorView* myLocationPickerIndicatorView;
@property (retain, nonatomic) MyLocationPickerSubmitButton* myLocationPickerSubmitButton;
@property (retain, nonatomic) MyLocationManager* myLocationManager;
@property (assign, nonatomic) CLLocationCoordinate2D currentLoc;

@end

@implementation MyLocationPicker

-(void)initialize
{
    [super initialize];
    
    self.forceShowBackButton = true;
    
    self.dismissVCAfterChooseLocation = true;
    
    self.locationButtonTopMargin = _statusBarHeight+44+20;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.hideVisualEffectViewOnLoading = NO;
    
    self.title = _str(@"select_location");
    
    //    _HomeBaseNavBar* navBar = (_HomeBaseNavBar*)self.navigationController.navigationBar;
    //    navBar.leftButton.shapeView.shapeDesc = [self overriddenBackButtonShapeDesc];
    //    navBar.leftButton.shapeMargins = UIEdgeInsetsMake(15, 15, 15, 15);
    //    [navBar.leftButton setButtonClick:^{
    //        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    //    }];
    
    _mapView = [MKMapView new];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_mapView];
    [_mapView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    
    _defineWeakSelf;
    
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
    {
        _myLocationManager = [MyLocationManager new];
        _myLocationManager.locationCallback = ^(CLLocationCoordinate2D cordinate) {
            
            weakSelf.currentLoc = cordinate;
            [weakSelf zoomToCurrentUserLocation];
            
            
        };
        [_myLocationManager updateLocation];
    }
    
    _myLocationPickerIndicatorView = [MyLocationPickerIndicatorView new];
    _myLocationPickerIndicatorView.userInteractionEnabled = NO;
    _myLocationPickerIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_myLocationPickerIndicatorView];
    [_myLocationPickerIndicatorView sdc_centerInSuperviewWithOffset:UIOffsetMake(0, 0)];
    
    _myLocationPickerSubmitButton = [MyLocationPickerSubmitButton new];
    _myLocationPickerSubmitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_myLocationPickerSubmitButton];
    [_myLocationPickerSubmitButton sdc_alignSideEdgesWithSuperviewInset:25];
    [_myLocationPickerSubmitButton sdc_pinHeight:46];
    [_myLocationPickerSubmitButton sdc_alignBottomEdgeWithSuperviewMargin:25];
    [_myLocationPickerSubmitButton addTarget:self action:@selector(sumbitButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _currentLocationButton = [[MyShapeButton alloc] initWithShapeDesc:__codebase_k_iconLocationSible() andShapeTintColor:rgba(66, 133, 244, 1.000) andButtonClick:^{
        [weakSelf zoomToCurrentUserLocation];
    }];
    _currentLocationButton.setsCornerRadiusForShapeView = NO;
    _currentLocationButton.shapeMargins = UIEdgeInsetsMake(13, 13, 13, 13);
    _currentLocationButton.layer.cornerRadius = 25;
    _currentLocationButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _currentLocationButton.layer.shadowOpacity = .3;
    _currentLocationButton.layer.shadowOffset = CGSizeMake(3, 3);
    
    _currentLocationButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_currentLocationButton];
    [_currentLocationButton sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeTop ofView:_mapView inset:self.locationButtonTopMargin];
    [_currentLocationButton sdc_alignLeftEdgeWithSuperviewMargin:20];
    [_currentLocationButton sdc_pinCubicSize:50];
    
    
    
    [self showPageLoadingAnimated:YES completion:nil];
    
    _spanDelta = .03;
    _disableRotation = true;
    _mapView.rotateEnabled = !_disableRotation;
}

-(void)setLocationButtonTopMargin:(CGFloat)locationButtonTopMargin
{
    _locationButtonTopMargin = locationButtonTopMargin;
    [_currentLocationButton sdc_get_top].constant = locationButtonTopMargin;
}



-(void)zoomToCurrentUserLocation
{
    if ([CLLocationManager locationServicesEnabled])
    {
        
        if (_currentLoc.latitude == 0 && _currentLoc.longitude == 0)
        {
            CLLocationCoordinate2D cor = self.mapView.userLocation.coordinate;
            if (cor.latitude != 0 || cor.longitude != 0)
                [self.mapView setCenterCoordinate:cor spanDelata:_spanDelta animated:YES];
            else
                [self.mapView setCenterCoordinate:_defaultLocation.coordinate spanDelata:_spanDelta animated:YES];
        }
        else
            [self.mapView setCenterCoordinate:_currentLoc spanDelata:_spanDelta animated:YES];
        
    }
}

-(void)sumbitButtonTouch:(id)sender
{
    if (_callback)
    {
        _callback(_location(_mapView.centerCoordinate));
    }
    
    if (self.dismissVCAfterChooseLocation)
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//-(void)setLocation:(CLLocation *)location
//{
////    [_mapView setCenterCoordinate:location.coordinate spanDelata:.02 animated:NO];
//}
#pragma mark MKMapViewDelegate
-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    
    [self hidePageLoadingAnimated:YES completion:nil];
    
    //    [MyLocationManager get]
    
    if (!initialZoomAnimationDone)
    {
        if (_location)
            [_mapView setCenterCoordinate:_location.coordinate spanDelata:_spanDelta animated:NO];
        else
            _mainThreadAfter(^{
                [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    CLLocationCoordinate2D loc = _mapView.userLocation.coordinate;
                    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse && [CLLocationManager authorizationStatus] !=  kCLAuthorizationStatusAuthorizedAlways && _defaultLocation)
                    {
                        loc = _defaultLocation.coordinate;
                        _currentLoc = _defaultLocation.coordinate;
                    }
                    
                    [_mapView setCenterCoordinate:loc spanDelata:_spanDelta animated:YES];
                } completion:nil];
            }, .1);
        initialZoomAnimationDone = YES;
    }
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [_myLocationPickerIndicatorView lift];
    _myLocationPickerSubmitButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3 animations:^{
        _myLocationPickerSubmitButton.alpha = .4;
    }];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [_myLocationPickerIndicatorView drop];
    _myLocationPickerSubmitButton.userInteractionEnabled = YES;
    [UIView animateWithDuration:.3 animations:^{
        _myLocationPickerSubmitButton.alpha = 1;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDisableRotation:(BOOL)disableRotation
{
    _disableRotation = disableRotation;
    _mapView.rotateEnabled = !disableRotation;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

