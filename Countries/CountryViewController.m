//
//  ViewController.m
//  Countries
//
//  Created by Mike_Gazdich_rMBP on 10/1/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "CountryViewController.h"
#import "CountryCell.h"
#import "CountryMapViewController.h"
#import "CountryWebViewController.h"


@interface CountryViewController ()

@property (nonatomic, strong) NSString *websiteURL;
@property (nonatomic, strong) NSString *countryName;

@end


@implementation CountryViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    
    // Instantiate a static dictionary object and initialize it with the content of the Countries.plist
    // file, which resides on a server computer requiring network connection to access it.
    self.countriesDict = [[NSDictionary alloc] initWithContentsOfURL:
                          [NSURL URLWithString:@"http://manta.cs.vt.edu/iOS/Countries.plist"]];
    
    /*
     If the returned object reference of the newly created dictionary is nil, then the file on the server
     computer was not read in due to a problem, which may be (1) the iOS device has no network
     connection, (2) the file is misplaced, or (3) the server is down.
     */
    
    if (self.countriesDict == nil) {
        // Create and display an error message
        UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"Unable to Access File!"
                                                               message:@"Possible causes: (a) No network connection, (b) Accessed file is misplaced, or (c) Server computer is down."
                                                              delegate:nil
                                                     cancelButtonTitle:@"Okay"
                                                     otherButtonTitles:nil];
        [alertMessage show];
        return;
    }
    
    /*
     Send allKeys message to the dictionary object and obtain all of the keys (country codes) in an array.
     Send the sortedArrayUsingSelector: message to that array. It returns an array that lists the receiver’s
     elements in ascending order, as determined by the comparison method specified by a given selector.
     */
    self.countryCodes = [[self.countriesDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    [super viewDidLoad];   // Inform super
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table View Data Source Methods

// Although the default is 1; it is still good to include this method for clarity
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Asks the data source to return the number of rows in a given section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.countryCodes count];
}

// Asks the data source to return a cell to insert in a particular table view location
- (CountryCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];
    
    NSString *countryCode = [self.countryCodes objectAtIndex:rowNumber];
    NSArray *countryData = [self.countriesDict objectForKey:countryCode];
    
    CountryCell *cell = (CountryCell *)[tableView dequeueReusableCellWithIdentifier:@"CountryCellType"];
    
    
    cell.countryCodeLabel.text = countryCode;
    cell.flagImageView.image = [UIImage imageNamed:[countryData objectAtIndex:0]];
    cell.populationLabel.text = [countryData objectAtIndex:1];
    cell.capitalLabel.text = [countryData objectAtIndex:2];
    
    return cell;
}


#pragma mark - Table View Delegate Methods

//       Asks the table view delegate to return the height of a given row.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewRowHeight;
}


//       Informs the table view delegate that the table view is about to display a cell for a particular row.
//       Just before the cell is displayed, we change the color of the cell's background.

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //   We use the modulus operator % to find the remainder of the division of row number by 2.
    //   If the remainder is 0, it is an even number (use MintCream); otherwise, it is an odd number (use OldLace).
    
    if (indexPath.row % 2 == 0) {
        // Set even numbered row background color to MintCream, #F5FFFA  245,255,250
        cell.backgroundColor = MINT_CREAM;
    } else {
        // Set odd numbered row background color to OldLace, #FDF5E6   253,245,230
        cell.backgroundColor = OLD_LACE;
    }
}


// Informs the table view delegate that the specified row is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];
    NSString *countryCode = [self.countryCodes objectAtIndex:rowNumber];
    
    self.countryData = [self.countriesDict objectForKey:countryCode];
    
    // Perform the segue named CountryMapView
    [self performSegueWithIdentifier:@"CountryMapView" sender:self];
}


// Informs the table view delegate that the user tapped the detail accessory button
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];
    NSString *countryCode = [self.countryCodes objectAtIndex:rowNumber];
    
    self.countryData = [self.countriesDict objectForKey:countryCode];
    
    self.countryName = [self.countryData objectAtIndex:3];
    self.websiteURL = [self.countryData objectAtIndex:7];
    
    // Perform the segue named CountryWebView
    [self performSegueWithIdentifier:@"CountryWebView" sender:self];
}


#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"CountryMapView"]) {
        
        // Obtain the object reference of the destination view controller
        CountryMapViewController *countryMapViewController = [segue destinationViewController];
        
        // Pass the data object countryData to the downstream view controller CountryMapViewController
        countryMapViewController.dataForSelectedCountry = self.countryData;
        
    } else if ([[segue identifier] isEqualToString:@"CountryWebView"]) {
        
        // Obtain the object reference of the destination view controller
        CountryWebViewController *countryWebViewController = [segue destinationViewController];
        
        // Pass the data objects countryName and websiteURL to the downstream view controller CountryWebViewController
        countryWebViewController.countryName = self.countryName;
        countryWebViewController.websiteURL = self.websiteURL;
    }
}

@end
