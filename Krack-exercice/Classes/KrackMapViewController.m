//
//  KrackMapViewController.m
//  ParseStarterProject
//
//  Created by Thibault Carpentier on 5/12/14.
//
//

#import "KrackMapViewController.h"
#import "PlacesQueryTableViewController.h"
#import "KrackPlacesMKAnnotation.h"

@interface KrackMapViewController ()
@end

@implementation KrackMapViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        ;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Loading the tableView from the storyboard
    placestableViewController = [[UIStoryboard storyboardWithName:@"Krack-exercice" bundle:nil] instantiateViewControllerWithIdentifier:@"TableViewTest"];
    // Setting the delegate
    placestableViewController.delegate = self;
    
    // Setting clearBackgroundColor to let the tableview show the map when scrolling
    placesTableView.backgroundColor = [UIColor clearColor];
    
    // Creating a searchBar
     searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 40.0f)];
    [searchBar setShowsCancelButton:YES];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    // Adding the viewcontroller and the view to the mapView
    [self addChildViewController:placestableViewController];
    placesTableView = placestableViewController.tableView;
    [self.view insertSubview:placestableViewController.view aboveSubview:placesMapView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Setting default area of the map
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 33.790802;
    zoomLocation.longitude= -118.13548200000002;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1.5*METERS_PER_MILE, 1.5*METERS_PER_MILE);
    [placesMapView setRegion:viewRegion animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    // Controlling the loggin
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        [[logInViewController logInView] setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"krack-header.png"]]];
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        [[signUpViewController signUpView] setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"krack-header.png"]]];
        
        // Assign sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)enableInset {
    [UIView animateWithDuration:.25 animations:^{
        // Setting the tableView to overlay the map view
        CGFloat offSet = [placestableViewController tableView:placestableViewController.tableView heightForRowAtIndexPath:nil] - 30.0f;
        UIEdgeInsets inset = placesTableView.contentInset;
        inset.top = placesMapView.frame.size.height - offSet;
        
        // Updating the tableView position.
        placesTableView.contentInset = inset;
        placesTableView.contentOffset = CGPointMake(0.0f, -(placesMapView.frame.size.height - offSet));
        placesTableView.scrollIndicatorInsets = inset;
        
        placesMapView.hidden = NO;
    }];
}

- (void)disableInset {
    [UIView animateWithDuration:.25 animations:^{
        CGFloat offset = self.navigationController.navigationBar.frame.size.height  + [UIApplication sharedApplication].statusBarFrame.size.height;
        UIEdgeInsets inset = placesTableView.contentInset;
        inset.top = offset;
        
        placesTableView.contentInset = inset;
        placesTableView.contentOffset = CGPointMake(0.0f, -offset);
        placesTableView.scrollIndicatorInsets = inset;
        
        // Hidding the map while in search
        placesMapView.hidden = YES;
    }];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // if not in search
    if (![searchBar isFirstResponder]) {
        [self enableInset];
    }
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Limit to at least 1 character
    return (username && password && username.length && password.length);
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    // hidding the loginView
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    // Hidding the signupView
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - PlacesQueryTAbleViewControllerDelegate

// Called by the delegate when used selected a place
- (void) placesQueryTableViewController:(PlacesQueryTableViewController *)viewController didSelectItemWithLocation:(CLLocationCoordinate2D)location {
    
    // Scrolling the tableview to let the map be shown
    [placestableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    // Updating the zooming area of the map to the selected item location
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 1.5*METERS_PER_MILE, 1.5*METERS_PER_MILE);
    [placesMapView setRegion:viewRegion animated:YES];
}

// Called by the delegate when objects are loaded
- (void) placesQueryTableViewController:(PlacesQueryTableViewController *)viewController didLoadObject:(NSArray *)objects {
    
    // Removing eventual previous pins on the map
    [self removeAllPinsButUserLocation];
    
    // Creating pin for each objects in the table
    for (PFObject *object in objects) {
        NSString *name = object[@"Name"];
        NSString *description = object[@"Description"];
        int type = [object[@"placeType"] integerValue];
        PFGeoPoint* location = object[@"location"];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = location.latitude;
        coordinate.longitude = location.longitude;
        
        // Creating Annotation View
        KrackPlacesMKAnnotation *annotation = [[KrackPlacesMKAnnotation alloc] initWithName:name description:description type:type andCoordinate:coordinate];
        
        // Adding pin to the map
        [placesMapView addAnnotation:annotation];
    }
}

#pragma mark - MKMapViewDelegate

// Remove all the pin on the map But the user location
- (void)removeAllPinsButUserLocation
{
    id userLocation = [placesMapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[placesMapView annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    [placesMapView removeAnnotations:pins];
}

// Return the pin color according the to place type
- (MKPinAnnotationColor) getColorFromPlaceType:(int)placeType {
    MKPinAnnotationColor result;
    
    switch (placeType) {
        case FirstType:
            result = MKPinAnnotationColorGreen;
            break;
        case SecondType:
            result = MKPinAnnotationColorRed;
            break;
        default:
            result = MKPinAnnotationColorPurple;
            break;
    }
    return result;
}

// Creating the view for annotations
- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[KrackPlacesMKAnnotation class]]) {
        MKPinAnnotationView *annotationView =[[MKPinAnnotationView alloc]
                                      initWithAnnotation:annotation reuseIdentifier:@"pin"];
        KrackPlacesMKAnnotation* krackAnnotation = (KrackPlacesMKAnnotation*)annotation;
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
        annotationView.pinColor = [self getColorFromPlaceType:krackAnnotation.type];
        return annotationView;
    }
    return nil;
}

#pragma mark - UIBarButtonItem 

// Filter button method
- (IBAction)filterButtonPressed:(id)sender {
    
    // Creating a popup with the filters
    UIActionSheet* filterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a filter" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
        @"All"
        , @"Green"
        , @"Red"
        , @"Purple"
    , nil];
    
    filterActionSheet.tag = 1;
    [filterActionSheet showInView:self.view];
}

// Logout the user
- (IBAction)logoutButtonPressed:(id)sender {
    [PFUser logOut];
    // used to refresh the page to show the login window again
    [self viewDidAppear:YES];
}

#pragma mark - UIActionSheetDelegate

// Filter actionsheet handler
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // If not cancel
    if (buttonIndex != 4) {
        // Setting the filter on the delegate
        placestableViewController.filter = buttonIndex;
        
        // Reloading objects with updated request
        [placestableViewController loadObjects];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
// updating the place filter and updating search
    placestableViewController.searchFilter = searchText;
    [placestableViewController loadObjects];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self disableInset];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self enableInset];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
    [searchBar resignFirstResponder];
}

@end
