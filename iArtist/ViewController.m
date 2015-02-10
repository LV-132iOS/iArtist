//
//  ViewController.m
//  iArtist
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ViewController.h"
#import "PriceCarouselDelegateAndDataSource.h"
#import "SizeCarouselDelegateAndDataSource.h"
#import "StyleCarouselDelegateAndDataSource.h"
#import "AVPictureViewController.h"

@interface ViewController (){
    PriceCarouselDelegateAndDataSource* priceCarouselDAndDS;
    SizeCarouselDelegateAndDataSource* sizeCarouselDAndDS;
    StyleCarouselDelegateAndDataSource* styleCarouselDAndDS;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _signIn = [GPPSignIn sharedInstance];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"UserLoggedIn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"UserLoggedOut" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToPictures) name:@"GoToPictures" object:nil];
    
    //Price Carousel
    priceCarouselDAndDS = [[PriceCarouselDelegateAndDataSource alloc] init];
    self.priceCarousel.delegate = priceCarouselDAndDS;
    self.priceCarousel.dataSource = priceCarouselDAndDS;
    self.priceCarousel.type = iCarouselTypeLinear;
    self.priceCarousel.bounces = NO;
    self.priceCarousel.scrollEnabled = NO;
    self.priceCarousel.centerItemWhenSelected = NO;
    self.priceCarousel.currentItemIndex = 3;
    self.priceCarousel.contentOffset = CGSizeMake(40.0f, 0.0f);

    
    //Size Carousel
    sizeCarouselDAndDS = [[SizeCarouselDelegateAndDataSource alloc] init];
    self.sizeCarousel.delegate = sizeCarouselDAndDS;
    self.sizeCarousel.dataSource = sizeCarouselDAndDS;
    self.sizeCarousel.type = iCarouselTypeLinear;
    self.sizeCarousel.bounces = NO;
    self.sizeCarousel.scrollEnabled = NO;
    self.sizeCarousel.centerItemWhenSelected = NO;
    self.sizeCarousel.contentOffset = CGSizeMake(-365.0f, 0.0f);
    
    //Style Carousel
    styleCarouselDAndDS = [[StyleCarouselDelegateAndDataSource alloc] init];
    self.styleCarousel.delegate = styleCarouselDAndDS;
    self.styleCarousel.dataSource = styleCarouselDAndDS;
    self.styleCarousel.type = iCarouselTypeRotary;
    self.styleCarousel.pagingEnabled = YES;
    self.styleCarousel.centerItemWhenSelected = YES;

    
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

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"loggedIn"]) {
        self.loginButton.title = [NSString stringWithFormat:@"Profile"];
    } else{
        self.loginButton.title = [NSString stringWithFormat:@"Log-in/Register"];
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
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"loggedIn"]) {
        UIAlertView* locAlertView = [[UIAlertView alloc] initWithTitle:@"Unavailable to proceed"
                                                               message:@"Please, log-in or register first."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles: nil];
        [locAlertView show];
    } else{
        [self performSegueWithIdentifier:@"Liked" sender:nil];
    }
}

-(void)goToPictures{
    [self performSegueWithIdentifier:@"PictureView" sender:nil];
   
    

}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AVSession *session = [AVSession sessionInit];
    
    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.session = session;
    dataManager.index = 0;
    dataManager.wallImage = [UIImage imageNamed:@"room1.jpg"];
    
    if ([segue.identifier isEqualToString:@"PictureView"]) {
        ((AVPictureViewController *)segue.destinationViewController).session = session;
        //((AVPictureViewController *)segue.destinationViewController).intputPictureIndex = 0;
    }
    if ([segue.identifier isEqualToString:@"News"]) {
        ((AVNews *)segue.destinationViewController).session = session;
        
    }
    
    if ([segue.identifier isEqualToString:@"pushToLiked"]) {
        ((AVLikedViewController *)segue.destinationViewController).session = session;
        
    }
    if ([segue.identifier isEqualToString:@"MainToCart"]) {
        
        //((AVCartController *)segue.destinationViewController).session = session;
        
    }
}

@end



















