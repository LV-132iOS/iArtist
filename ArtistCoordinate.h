//
//  ArtistCoordinate.h
//  iArtist
//
//  Created by Barninets on 08.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapPin.h"

@interface ArtistCoordinate : NSObject {
    
    NSArray *ArtistCoordinate;
}

@property(retain, nonatomic) NSArray *ArtistCoordinate;

-(NSArray*)InitArtistCoordinate;


@end
