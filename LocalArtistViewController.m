//
//  LocalArtistViewController.m
//  iArtist
//
//  Created by Barninets on 23.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "LocalArtistViewController.h"

@interface LocalArtistViewController () <MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation LocalArtistViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.myPicker.delegate = self;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(49.839775, 24.039701), 30000, 30000);
    [self.mapView setRegion:region animated:YES];

    
    self.pinsArray = [ArtistCoordinate new];
    self.array = [[NSArray alloc]initWithArray:[self.pinsArray InitArtistCoordinate]];
    
    
    for (MapPin *annotation in self.array)  {
        
        [self.mapView addAnnotation:annotation];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)SetMap:(id)sender {
    switch (((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            self.mapView.mapType = MKMapTypeStandard;
            break;
    }
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.array count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    MapPin *Annotation = [self.array objectAtIndex:row];
    NSString *title = Annotation.title;
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    MapPin *Annotation = [self.array objectAtIndex:row];
    [self.mapView addAnnotation:Annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (Annotation.coordinate, 4000, 4000);
    [self.mapView setRegion:region animated:YES];
    
}

- (IBAction)backReturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
