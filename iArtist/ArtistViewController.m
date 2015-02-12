//
//  ArtistViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ArtistViewController.h"

@interface ArtistViewController ()

@end

@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set imageOfArtist
    self.imageOfArtist.image = self.img;
    self.nameOfArtist.text = self.name;
    self.descriptionOfArtist.text = self.descr;
    self.Folowers.text = self.followers;
    self.tosale.text = self.tosell;
    self.locationOfArtist.text = self.location;
    self.imageOfArtist.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.imageOfArtist.layer.cornerRadius = 100;
    self.imageOfArtist.layer.borderWidth = 2.0;
    self.imageOfArtist.layer.masksToBounds = YES;
    self.imageOfArtist.layer.borderColor = [[UIColor blackColor] CGColor];
    
    //set description

  

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeViewAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
