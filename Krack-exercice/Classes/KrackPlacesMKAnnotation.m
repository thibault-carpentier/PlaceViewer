//
//  KrackPlacesMKAnnotation.m
//  ParseStarterProject
//
//  Created by Thibault Carpentier on 5/17/14.
//
//


#import "KrackPlacesMKAnnotation.h"

@interface KrackPlacesMKAnnotation ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) CLLocationCoordinate2D location;

@end

@implementation KrackPlacesMKAnnotation

- (id) initWithName:(NSString *)name description:(NSString *)description type:(int)type andCoordinate:(CLLocationCoordinate2D)location {
    self = [super init];
    if (self) {
        self.name = name;
        self.description = description;
        _type = type;
        self.location = location;
    }
    return self;
}

- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    return self.description;
}


- (CLLocationCoordinate2D) coordinate {
    return self.location;
}

- (MKMapItem*)mapItem {
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:self.location addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
    mapItem.name = self.name;
    return mapItem;
}

@end
