//
//  PlacesQueryTableViewController.h
//  ParseStarterProject
//
//  Created by Thibault Carpentier on 5/13/14.
//
//

#import <Parse/Parse.h>
#import "ParseStarterProjectAppDelegate.h"

// Declaring delegate protocol
@protocol PlacesQueryTAbleViewControllerDelegate;

@interface PlacesQueryTableViewController : PFQueryTableViewController // Used to handle the requests

@property (nonatomic, assign) id<PlacesQueryTAbleViewControllerDelegate> delegate; // Custom delegate
@property (nonatomic, assign) KrackPlaceType filter; // Filter type on the request
@property (nonatomic, copy) NSString* searchFilter;

@end

// Delegate protocol
@protocol PlacesQueryTAbleViewControllerDelegate <NSObject>

// CallBack when objects are loaded into the view
- (void) placesQueryTableViewController:(PlacesQueryTableViewController*)viewController didLoadObject:(NSArray *)objects;

// CallBack when a place is selected
- (void) placesQueryTableViewController:(PlacesQueryTableViewController *)viewController didSelectItemWithLocation:(CLLocationCoordinate2D)location;

@end