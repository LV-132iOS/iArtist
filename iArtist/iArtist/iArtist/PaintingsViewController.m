//
//  PaintingsViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "PaintingsViewController.h"
#import "ArtCarouselDelegateAndDataSource.h"

@interface PaintingsViewController (){
    ArtCarouselDelegateAndDataSource* artCarouseldelegate;
}

@end

@implementation PaintingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToDetails) name:@"GoToDetails" object:nil];
    
    
    artCarouseldelegate = [[ArtCarouselDelegateAndDataSource alloc] init];
    self.artCarousel.delegate = artCarouseldelegate;
    self.artCarousel.dataSource = artCarouseldelegate;
    self.artCarousel.type = iCarouselTypeCylinder;
    self.artCarousel.pagingEnabled = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeViewAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goToDetails{
    [self performSegueWithIdentifier:@"DetailsOfPainting" sender:nil];
}


@end
