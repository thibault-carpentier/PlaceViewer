//
//  PlacesQueryTableViewController.m
//  ParseStarterProject
//
//  Created by Thibault Carpentier on 5/13/14.
//
//

#import "PlacesQueryTableViewController.h"

@interface PlacesQueryTableViewController ()

@end

@implementation PlacesQueryTableViewController


- (id)init {
    self = [super init];
    if (self) {
        // The className to query on
        self.parseClassName = @"KrackPlaces";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
//        self.objectsPerPage = 25;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"KrackPlaces";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
//        self.objectsPerPage = 2;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // The className to query on
        self.parseClassName = @"KrackPlaces";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
//        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ParseTableViewController

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    // Order by name
    [query orderByAscending:@"Name"];
    
    // If a filter is set
    if (_filter != 0) {
        // Add the filter type to the request
        [query whereKey:@"placeType" equalTo:[NSNumber numberWithInt:_filter]];
    }
    // Adding the search filter to the request
    [query whereKey:@"Name" containsString:self.searchFilter];
    
    return query;
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    // If no error
    if (!error) {
        // if delegate has the method implemented
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(placesQueryTableViewController:didLoadObject:)]) {
            // Calling method in the delegate
            [self.delegate placesQueryTableViewController:self didLoadObject:self.objects];
        }
    }
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // drawing optimisation
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat result = 75.0f;
    return (result);
}

#pragma mark - TableViewDelegate

// Returning the image according to the placeType of a place
- (UIImage *)imageAssociatedWithType:(int)type {
    UIImage *result;
    
    switch (type) {
        case FirstType:
            result = [UIImage imageNamed:@"green_circle.png"];
            break;
        case SecondType:
            result = [UIImage imageNamed:@"red_circle.png"];
            break;
            
        default:
            result = [UIImage imageNamed:@"purple_circle.png"];
            break;
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"KrackPlaceCellID";
    
    // Getting the cell :
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    
    // Getting UI elements
    UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *descLabel = (UILabel*)[cell.contentView viewWithTag:2];
    UIImageView* typePlaceImageView = (UIImageView*)[cell.contentView viewWithTag:3];
   
    // Filling UI elements
    titleLabel.text = object[@"Name"];
    descLabel.text = object[@"Description"];
    typePlaceImageView.image = [self imageAssociatedWithType:[object[@"placeType"]integerValue]];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // If delegate implement the callback
    if (self.delegate && [self.delegate respondsToSelector:@selector(placesQueryTableViewController:didSelectItemWithLocation:)]) {
        
        // Getting the selected item data
        PFObject *selectedItem = [self.objects objectAtIndex:indexPath.row];
        // Getting his location
        PFGeoPoint* location = selectedItem[@"location"];
        
        // Calling delegate method with the location
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = location.latitude;
        coordinate.longitude = location.longitude;
        [self.delegate placesQueryTableViewController:self didSelectItemWithLocation:coordinate];
    }
}

@end
