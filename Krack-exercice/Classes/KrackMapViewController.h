//
//  KrackMapViewController.h
//  ParseStarterProject
//
//  Created by Thibault Carpentier on 5/12/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "PlacesQueryTableViewController.h"

@interface KrackMapViewController : UIViewController
<  PFLogInViewControllerDelegate // Used to control login
, PFSignUpViewControllerDelegate // Used to control signup
, MKMapViewDelegate // Used to control Map
, PlacesQueryTAbleViewControllerDelegate //Used to interact with the TableView (Delegate to update the map)
, UIActionSheetDelegate // Used for filters
, UISearchBarDelegate // Search bar
> {
    
    PlacesQueryTableViewController* placestableViewController; // Instance to update filter and reload data
    __weak IBOutlet MKMapView *placesMapView; // The mapView
    UITableView *placesTableView; // Used to controll the tableView
    UISearchBar *searchBar; // Text filter on places
}

@end
