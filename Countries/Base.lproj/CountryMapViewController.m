//
//  CountryMapViewController.m
//  Countries
//
//  Created by Mike_Gazdich_rMBP on 10/1/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "CountryMapViewController.h"

@interface CountryMapViewController ()

@property (nonatomic, strong) NSString *countryName;
@property double latitude;
@property double longitude;
@property double span;

@end


@implementation CountryMapViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    
    // Set the properties of the view before it is shown to the user using the data object passed
    
    self.countryName    = [self.dataForSelectedCountry objectAtIndex:3];
    self.latitude       = [[self.dataForSelectedCountry objectAtIndex:4] doubleValue];
    self.longitude      = [[self.dataForSelectedCountry objectAtIndex:5] doubleValue];
    self.span           = [[self.dataForSelectedCountry objectAtIndex:6] doubleValue];
    
    /*
     CLLocation usage requires the CoreLocation.framework to be linked to your project.
     Instantiate a geographical location object and initialize it with the country's
     geographical coordinates defined by Latitude and Longitude.
     */
    CLLocation *countryLocation = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    
    /*
     MKCoordinateRegion usage requires the MapKit.framework to be linked to your project.
     MKCoordinateRegion is a *data structure*, NOT a class, that defines which portion of the map to display.
     MKCoordinateRegionMakeWithDistance creates a new MKCoordinateRegion with the following parameters:
     
     centerCoordinate = countryLocation.coordinate
     The center point of the new coordinate region.
     
     latitudinalMeters = self.span
     The amount of north-to-south distance (measured in meters) to use for the span.
     
     longitudinalMeters = self.span
     The amount of east-to-west distance (measured in meters) to use for the span.
     */
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(countryLocation.coordinate, self.span, self.span);
    
    // Set the title of the navigation bar to the country name
    self.title = self.countryName;
    
    // Ask the map to display the country region defined above.
    [self.countryMap setRegion:region animated:YES];
    
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - MKMapViewDelegate Protocol Methods

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    // Starting to load the map. Show the animated activity indicator in the status bar
    // to indicate to the user that the map view object is busy loading the map.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    // Finished loading the map. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    // An error occurred during the map load. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Compose the error message
    NSString *errorMessage = [NSString stringWithFormat:@"Problem Description: %@", error.localizedDescription];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to Load Map"
                                                        message:errorMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
    
    // Show the error message
    [alertView show];
}

@end
