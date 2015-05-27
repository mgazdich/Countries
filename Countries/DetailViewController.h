//
//  DetailViewController.h
//  Countries
//
//  Created by Mike_Gazdich_rMBP on 10/14/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *countryMap;

// The data object dataForSelectedCountry is passsed down from the previous view controller
@property (nonatomic, strong) NSArray *dataForSelectedCountry;

@end