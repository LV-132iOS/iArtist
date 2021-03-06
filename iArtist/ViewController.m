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
    //allocating user defaults for the whole file
    //not sure if this needed
    _signIn = [GPPSignIn sharedInstance];
    //notification for sending info to server
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendInfo:)
                                                 name:@"SendInfo"
                                               object:nil];
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
    [control refresh];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500000000), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"pushToLiked" sender:nil];
    });
}

-(void)goToPictures{
    //method used by notification to go to pictures
    [self performSegueWithIdentifier:@"PictureView" sender:nil];
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //preparing other view controllers with background images and so on
    Sesion *session = [Sesion sessionInit];
    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.session = session;
    dataManager.index = 0;
    dataManager.wallImage.wallPicture = [UIImage imageNamed:@"room1.jpg"];
    if ([segue.identifier isEqualToString:@"PictureView"]) {
        ((iCaruselViewController *)segue.destinationViewController).session = session;
    }
    if ([segue.identifier isEqualToString:@"News"]) {
        ((NewsViewController *)segue.destinationViewController).session = session;
        
    }
    if ([segue.identifier isEqualToString:@"pushToLiked"]) {
        ((LikedViewController *)segue.destinationViewController).session = session;
        
    }
}


-(void)sendInfo:(NSNotification*)notification {
    //here we need to send info to server
    //check if info is already sent. if no - then send. if yes - do nothing and log that out
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"informationSent"] == NO) {
        //creating dictionary for data to pass with dataTask
        NSLog(@"%@", [defaults objectForKey:@"id"]);
        NSLog(@"%@", [defaults objectForKey:@"username"]);
        NSLog(@"%@", [defaults objectForKey:@"useremail"]);
        NSDictionary* dataToPassDic = @{
                                        @"_id" : [defaults objectForKey:@"id"],
                                        @"username" : [defaults objectForKey:@"username"],
                                        @"useremail": [defaults objectForKey:@"useremail"],
                                        };
        //and convert dictionary to proper type
        NSData* dataToPass = [NSJSONSerialization dataWithJSONObject:dataToPassDic
                                                             options:0
                                                               error:nil];
        //current url for request
                NSURL* url = [NSURL URLWithString:@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/users/"];
        //NSURL* url = [NSURL URLWithString:@"http://192.168.103.5/users/"];
        //creating request to use it with dataTask
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        //preparing session and request
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
        request.HTTPMethod = @"POST";
        request.HTTPBody = dataToPass;
        //request.timeoutInterval = 20;
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //creating data task
        
        NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data,                                                                                                  NSURLResponse *response,                                                                                                  NSError *error) {
                                                        //logging received response
                                                        NSLog(@"%@",response);
                                                        
                                                        if (!error) {
                                                            NSString* locString = [NSString stringWithFormat:@"loggedInWith%@",
                                                                                   [notification.userInfo objectForKey:@"with"]];
                                                            [defaults setBool:YES forKey:@"loggedIn"];
                                                            [defaults setBool:YES forKey:locString];
                                                            [defaults setBool:YES forKey:@"informationSent"];
                                                            [defaults synchronize];
                                                            //when information succesfully sent it is needed
                                                            //need to close login view
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedCloseLoginView"
                                                                                                                object:nil];
                                                            //to change button name from login to profile
                                                            
                                                            //
                                                            
                                                        } else {
                                                            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed to send info"
                                                                                                            message:@"Please, re-login later"
                                                                                                           delegate:nil
                                                                                                  cancelButtonTitle:@"OK"
                                                                                                  otherButtonTitles:nil];
                                                            [alert show];
                                                        }
                                                        
                                                    }];
        //sending data task
        
        [dataTask resume];
        
    }
}

- (IBAction)goToProfile:(id)sender {
    SessionControl* control = [SessionControl sharedManager];
    [control refresh];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500000000), dispatch_get_main_queue(), ^{
         NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults boolForKey:@"loggedIn"]) {
            [self performSegueWithIdentifier:@"GoToProfile" sender:nil];
        } else{
            [self performSegueWithIdentifier:@"Login" sender:nil];
        }
    });
}

#pragma mark UISearchBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"started editing text");
    [UIView animateWithDuration:0.3 animations:^{
        [[self searchBar]setFrame:CGRectMake(self.searchBar.frame.origin.x - 100,
                                             self.searchBar.frame.origin.y,
                                             self.searchBar.frame.size.width + 100,
                                             self.searchBar.frame.size.height )];
        [self.searchBar layoutSubviews];
    }];
}
// called when text ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"finished editing text");
    [UIView animateWithDuration:0.3 animations:^{
        [[self searchBar]setFrame:CGRectMake(self.searchBar.frame.origin.x + 100,
                                             self.searchBar.frame.origin.y,
                                             self.searchBar.frame.size.width - 100,
                                             self.searchBar.frame.size.height )];
        [self.searchBar layoutSubviews];
    }];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"Text changed search");
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("312qweq", DISPATCH_QUEUE_SERIAL);
    
    
    
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"fetching json");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"getting json,");
    });
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Search button");
}

@end



















