//
//  KrackPlacesMKAnnotation.h
//  ParseStarterProject
//
//  Created by Thibault Carpentier on 5/17/14.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

// Custom MKAnnotations for KrackMapViewController
@interface KrackPlacesMKAnnotation : NSObject <MKAnnotation>

-(id)initWithName:(NSString *)name description:(NSString *)description type:(int)type andCoordinate:(CLLocationCoordinate2D)location;
- (MKMapItem *)mapItem;

@property (nonatomic, assign) int type;

@end
