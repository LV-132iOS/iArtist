//
//  ArtistCoordinate.m
//  iArtist
//
//  Created by Barninets on 08.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ArtistCoordinate.h"

@interface ArtistCoordinate ()

@end

@implementation ArtistCoordinate

@synthesize ArtistCoordinate;

-(NSArray *)InitArtistCoordinate {
    
    MapPin *artist1 = [[MapPin alloc]init];
    artist1.title = @"Artist1";
    artist1.subtitle = @"Description of Artist1";
    artist1.coordinate = CLLocationCoordinate2DMake(49.835845, 23.979277);
    
    
    MapPin *artist2 = [[MapPin alloc]init];
    artist2.title = @"Artist2";
    artist2.subtitle = @"Description of Artist2";
    artist2.coordinate = CLLocationCoordinate2DMake(49.848022, 24.012579);
    
    
    MapPin *artist3 = [[MapPin alloc]init];
    artist3.title = @"Artist3";
    artist3.subtitle = @"Description of Artist3";
    artist3.coordinate = CLLocationCoordinate2DMake(49.816022, 24.022364);
    
    
    MapPin *artist4 = [MapPin new];
    artist4.title = @"Artist4";
    artist4.subtitle = @"Description of Artist4";
    artist4.coordinate = CLLocationCoordinate2DMake(49.833519, 24.073519);
    
    
    MapPin *artist5 = [MapPin new];
    artist5.title = @"Artist5";
    artist5.subtitle = @"Description of Artist5";
    artist5.coordinate = CLLocationCoordinate2DMake(49.850457, 24.052576);
    
    NSArray *array = [[NSArray alloc]initWithObjects:artist1,artist2,artist3,artist4,artist5,nil];
    self.ArtistCoordinate = array;
    
    return array;
}

@end
