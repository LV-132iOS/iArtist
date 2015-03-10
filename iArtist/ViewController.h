//
//  ViewController.h
//  iArtist
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import "AVManager.h"
#import "Sesion.h"
#import "ServerFetcher.h"
#import "SearchResultsViewController.h"

@interface ViewController : UIViewController <UISearchBarDelegate, UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate>

@property (strong) GPPSignIn* signIn;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (weak, nonatomic) IBOutlet iCarousel *styleCarousel;
@property (weak, nonatomic) IBOutlet iCarousel *colorCarousel;
@property (weak, nonatomic) IBOutlet iCarousel *materialCarousel;
@property (weak, nonatomic) IBOutlet iCarousel *sizeCarousel;
@property (weak, nonatomic) IBOutlet iCarousel *priceCarousel;
@property (weak, nonatomic) IBOutlet iCarousel *artistsCarousel;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) NSMutableArray *urls;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarButtonItem;
@property (nonatomic, strong) UIPopoverController *popoverSearchController;
@property (nonatomic, strong) SearchResultsViewController *tableController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *loginButton;
@property (strong, nonatomic) NSMutableDictionary       *searchDictionary;


@end

