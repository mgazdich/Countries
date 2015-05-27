//
//  MasterViewController.h
//  Countries
//
//  Created by Mike_Gazdich_rMBP on 10/14/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

#define       kTableViewRowHeight  60;

// Alternate table view rows have a background color of MintCream or OldLace for clarity of display

// Define MintCream color: #F5FFFA  245,255,250
#define MINT_CREAM [UIColor colorWithRed:245.0f/255.0f green:255.0f/255.0f blue:250.0f/255.0f alpha:1.0f];

// Define OldLace color: #FDF5E6   253,245,230
#define OLD_LACE [UIColor colorWithRed:253.0f/255.0f green:245.0f/255.0f blue:230.0f/255.0f alpha:1.0f];


@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

/*
 The Countries.plist XML file represents a Dictionary data structure consisting of:
 Key = Country Code   Value = object reference of an Array containing the country data items
 */
@property (strong, nonatomic) NSDictionary *countriesDict;

@property (strong, nonatomic) NSArray *countryCodes;

@property (strong, nonatomic) NSArray *countryData;

@end
