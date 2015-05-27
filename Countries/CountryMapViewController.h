//
//  MapViewController.h
//  Countries
//
//  Created by Michael Gazdich on 10/14/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CountryMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *countryMap;

// The data object dataForSelectedCountry is passsed down from the previous view controller
@property (nonatomic, strong) NSArray *dataForSelectedCountry;

@end

