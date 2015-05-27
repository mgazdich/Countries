//
//  DetailViewController.m
//  Countries
//
//  Created by Mike_Gazdich_rMBP on 10/14/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property double latitude;
@property double longitude;
@property double span;
@property (nonatomic, strong) NSString *countryName;

// Private obj ref to a UIPopoverController object
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

// A private method
- (void)configureView;

@end


@implementation DetailViewController

#pragma mark - Managing the Data Object Passed

- (void)setDataForSelectedCountry:(NSArray *)newDataForSelectedCountry
{
    /*
     If the user taps the name of a country that is already selected, we will not redisplay
     the country map again unnecessarily for performance reasons. Therefore, the IF
     statement below configures the view only if a different country is selected.
     */
    
    // Here we must access the instance variable directly without using the getter method
    if (![_dataForSelectedCountry isEqualToArray:newDataForSelectedCountry] ) {
        
        // Here we must set the instance variable value directly without using the setter method
        _dataForSelectedCountry = newDataForSelectedCountry;
        
        [self configureView];
    }
    
    // If the popover list of country names is showing in the portrait orientation,
    // dismiss it since we will show the country's map on the whole screen.
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [self configureView];
    [super viewDidLoad];
}


- (void)configureView
{
    if (self.dataForSelectedCountry) {
        
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UISplitViewControllerDelegate Protocol Methods

/*
 When iPad rotates from landscape to portrait orientation, our app hides the master view controller
 displaying the list of topics for naval mines on the left side of the split view.
 When this happens, the button and popover controller need to be reactivated so that
 the user can select a topic from the popover menu displayed by tapping the button.
 */
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"Countries";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}


/*
 When iPad rotates from portrait to landscape orientation, our app shows its hidden master view controller
 displaying the list of topics for naval mines on the left side of the split view.
 When this happens, the button and popover controller are no longer needed and they are deactivated.
 The deactivation is done by setting the object references to nil.
 */
- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}



#pragma mark - MKMapViewDelegate Protocol Methods

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    // Show the animated activity indicator in the status bar while the map is being loaded
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    // Hide the activity indicator in the status bar since the map is loaded
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    // Hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Compose the error message
    NSString *errorMessage = [NSString stringWithFormat:
                              @"Problem Description: %@", error.localizedDescription];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to Load Map"
                                                        message:errorMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
    // Show the error message
    [alertView show];
}

@end