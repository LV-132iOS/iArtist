//
//  MapPin.h
//  iArtist
//
//  Created by Barninets on 08.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject <MKAnnotation> {
    
    
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
