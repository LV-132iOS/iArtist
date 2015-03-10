//
//  LocalArtistViewController.h
//  iArtist
//
//  Created by Barninets on 23.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPin.h"
#import "ArtistCoordinate.h"

@interface LocalArtistViewController : UIViewController

@property(weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) ArtistCoordinate *pinsArray;
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) IBOutlet UIPickerView *myPicker;

@end
