//
//  ViewController.m
//  iArtist
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ViewController.h"
#import "StyleCarouselDelegateAndDataSource.h"
#import "ColorCarouselDelegateAndDataSource.h"
#import "MaterialCarouselDelegateAndDataSource.h"
#import "SizeCarouselDelegateAndDataSource.h"
#import "PriceCarouselDelegateAndDataSource.h"
#import "ArtistsCarouselDelegateAndDataSource.h"
#import "iCaruselViewController.h"
#import "SessionControl.h"
#import "ServerFetcher.h"
#import "SDImageCache.h"
#import "Picture+Create.h"
#import "AppDelegate.h"
#import  "SearchResultsViewController.h"

@interface ViewController (){
    StyleCarouselDelegateAndDataSource* styleCarouselDAndDS;
    ColorCarouselDelegateAndDataSource* colorCarouselDAndDS;
    MaterialCarouselDelegateAndDataSource* materialCarouselDAndDS;
    SizeCarouselDelegateAndDataSource* sizeCarouselDAndDS;
    PriceCarouselDelegateAndDataSource* priceCarouselDAndDS;
    ArtistsCarouselDelegateAndDataSource* artistsCarouselDAndDS;
}

@end

@implementation ViewController 


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchPopover"];

    self.urls = [[NSMutableArray alloc]init];
    self.SearchBar.delegate = self;
    self.popoverSearchController.delegate = self;
    //allocating user defaults for the whole file
    //not sure if this needed
    _signIn = [GPPSignIn sharedInstance];
    //notification to perform segue to pictures (notif posted from carousels)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToPictures)
                                                 name:@"GoToPictures"
                                               object:nil];
    
    //Style Carousel
    styleCarouselDAndDS = [[StyleCarouselDelegateAndDataSource alloc] init];
    self.styleCarousel.delegate = styleCarouselDAndDS;
    self.styleCarousel.dataSource = styleCarouselDAndDS;
    self.styleCarousel.type = iCarouselTypeRotary;
    
    
    //Color Carousel
    colorCarouselDAndDS = [[ColorCarouselDelegateAndDataSource alloc] init];
    self.colorCarousel.delegate = colorCarouselDAndDS;
    self.colorCarousel.dataSource = colorCarouselDAndDS;
    self.colorCarousel.type = iCarouselTypeLinear;
    self.colorCarousel.bounces = YES;
    self.colorCarousel.scrollEnabled = YES;
    self.colorCarousel.centerItemWhenSelected = NO;
    self.colorCarousel.currentItemIndex = 2;
    
    
    //Material Carousel
    materialCarouselDAndDS = [[MaterialCarouselDelegateAndDataSource alloc] init];
    self.materialCarousel.delegate = materialCarouselDAndDS;
    self.materialCarousel.dataSource = materialCarouselDAndDS;
    self.materialCarousel.type = iCarouselTypeLinear;
    self.materialCarousel.bounces = YES;
    self.materialCarousel.scrollEnabled = YES;
    self.materialCarousel.centerItemWhenSelected = NO;
    self.materialCarousel.currentItemIndex = 2;
    
    
    //Size Carousel
    sizeCarouselDAndDS = [[SizeCarouselDelegateAndDataSource alloc] init];
    self.sizeCarousel.delegate = sizeCarouselDAndDS;
    self.sizeCarousel.dataSource = sizeCarouselDAndDS;
    self.sizeCarousel.type = iCarouselTypeLinear;
    self.sizeCarousel.bounces = NO;
    self.sizeCarousel.scrollEnabled = NO;
    self.sizeCarousel.centerItemWhenSelected = NO;
    self.sizeCarousel.contentOffset = CGSizeMake(-365.0f, 0.0f);
    
    
    //Price Carousel
    priceCarouselDAndDS = [[PriceCarouselDelegateAndDataSource alloc] init];
    self.priceCarousel.delegate = priceCarouselDAndDS;
    self.priceCarousel.dataSource = priceCarouselDAndDS;
    self.priceCarousel.type = iCarouselTypeLinear;
    self.priceCarousel.bounces = YES;
    self.priceCarousel.scrollEnabled = YES;
    self.priceCarousel.centerItemWhenSelected = NO;
    self.priceCarousel.currentItemIndex = 2;
    
    
    //Artists Carousel
    artistsCarouselDAndDS = [[ArtistsCarouselDelegateAndDataSource alloc] init];
    self.artistsCarousel.delegate = artistsCarouselDAndDS;
    self.artistsCarousel.dataSource = artistsCarouselDAndDS;
    self.artistsCarousel.type = iCarouselTypeLinear;
    self.artistsCarousel.bounces = YES;
    self.artistsCarousel.scrollEnabled = NO;
    self.artistsCarousel.centerItemWhenSelected = NO;
    self.artistsCarousel.currentItemIndex = 2;
    
    
    self.scroll.contentSize = CGSizeMake(1024, 1069);
    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.index = 0;
    dataManager.wallImage = [Wall new];
    dataManager.wallImage.wallPicture = [UIImage imageNamed:@"room1.jpg"];
    dataManager.wallImage.distanceToWall = @1;
    [dataManager wallArrayInit];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"firstRun"] ==nil )
    {
        [defaults setObject:[NSDate date] forKey:@"firstRun"];
        [defaults setBool:NO forKey:@"loggedIn"];
        [defaults setBool:NO forKey:@"loggedInWithFacebook"];
        [defaults setBool:NO forKey:@"loggedInWithTwitter"];
        [defaults setBool:NO forKey:@"loggedInWithGoogle"];
        [defaults setBool:NO forKey:@"loggedInWithVkontakte"];
        [defaults setBool:NO forKey:@"informationSent"];
        [defaults synchronize];
        [self performSegueWithIdentifier:@"FirstRunSegue" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)HelpButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"FirstRunSegue" sender:nil];
}


- (IBAction)loginButtonAction:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"loggedIn"]) {
        [self performSegueWithIdentifier:@"Profile" sender:nil];
    } else{
        [self performSegueWithIdentifier:@"Login" sender:nil];
    }
}

- (IBAction)myNewsButtonAction:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"loggedIn"]) {
        UIAlertView* locAlertView = [[UIAlertView alloc] initWithTitle:@"Unavailable to proceed"
                                                               message:@"Please, log-in or register first."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles: nil];
        [locAlertView show];
    } else{
        [self performSegueWithIdentifier:@"NewsFeed" sender:nil];
    }
}

- (IBAction)likedButtonAction:(id)sender {
    SessionControl* control = [SessionControl sharedManager];
    [control refreshWithCompletionHandler:^{
        [self performSegueWithIdentifier:@"pushToLiked" sender:nil];
    }];
}

-(void)goToPictures{
    //method used by notification to go to pictures
    [self performSegueWithIdentifier:@"PictureView" sender:nil];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //preparing other view controllers with background images and so on
    Sesion *session = [Sesion sessionInit];
    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.session = session;
    dataManager.index = 0;
    dataManager.wallImage.wallPicture = [UIImage imageNamed:@"room1.jpg"];
    if ([segue.identifier isEqualToString:@"PictureView"]) {
        //((iCaruselViewController *)segue.destinationViewController).session = session;
    }
    if ([segue.identifier isEqualToString:@"News"]) {
        ((NewsViewController *)segue.destinationViewController).session = session;
        
    }
    if ([segue.identifier isEqualToString:@"pushToLiked"]) {
        ((LikedViewController *)segue.destinationViewController).session = session;
        
    }
}



- (IBAction)goToProfile:(id)sender {
    SessionControl* control = [SessionControl sharedManager];
    [control refreshWithCompletionHandler:^{
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults boolForKey:@"loggedIn"]) {
            [self performSegueWithIdentifier:@"GoToProfile" sender:nil];
        } else{
            [self performSegueWithIdentifier:@"Login" sender:nil];
        }
    }];
}

#pragma mark UISearchBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"started editing text");
    [UIView animateWithDuration:0.3 animations:^{
        [[self SearchBar]setFrame:CGRectMake(self.SearchBar.frame.origin.x - 100,
                                             self.SearchBar.frame.origin.y,
                                             self.SearchBar.frame.size.width + 100,
                                             self.SearchBar.frame.size.height )];
        [self.SearchBar layoutSubviews];
    }];
}
// called when text ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"finished editing text");
    [UIView animateWithDuration:0.3 animations:^{
        [[self SearchBar]setFrame:CGRectMake(self.SearchBar.frame.origin.x + 100,
                                             self.SearchBar.frame.origin.y,
                                             self.SearchBar.frame.size.width - 100,
                                             self.SearchBar.frame.size.height )];
        [self.SearchBar layoutSubviews];
        self.popoverSearchController = nil;
    }];
}




- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"Text changed search");
    if (!self.popoverSearchController) {
        self.popoverSearchController = [[UIPopoverController alloc] initWithContentViewController:self.tableController];
         [self.popoverSearchController presentPopoverFromBarButtonItem:self.searchBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    [self.tableController setValue:searchText forKey:@"searchString"];
    
    
    

   // dispatch_group_t group = dispatch_group_create();
   //dispatch_queue_t queue = dispatch_queue_create("312qweq", DISPATCH_QUEUE_SERIAL);
//
//    dispatch_group_async(group, queue, ^{
//       NSLog(@"fetching json");
//    });
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"getting json,");
//    });
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Search button");
}

@end



















