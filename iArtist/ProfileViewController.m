//
//  ProfileViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ProfileViewController.h"
#import "SessionControl.h"
#import "AppDelegate.h"
#import "SDImageCache.h"

@interface ProfileViewController () {
    NSUserDefaults* defaults;
}

@end

@implementation ProfileViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    SessionControl* control = [SessionControl sharedManager];
    [control refresh];
    [super viewWillAppear:animated];
    
    defaults = [NSUserDefaults standardUserDefaults];
    self.nameLabel.text = [defaults objectForKey:@"username"];
    self.emailLabel.text = [[defaults objectForKey:@"useremail"] stringByRemovingPercentEncoding];
    self.loggedinLabel.text = [control currentSocialNetwork];
    

    if ([control checkInternetConnection]) {
        if (![[control currentSocialNetwork] isEqualToString:@"none"]) {
            if(!([[control checkSession:[control currentSocialNetwork]] isEqualToString:@"yes"])) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sesion error"
                                                                message:@"Please, re-login"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK :("
                                                      otherButtonTitles:nil];
                [alert show];
                [self performLogoutWith:[control currentSocialNetwork]];
            }
        }
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonAction:(id)sender {
    //logout clears access token and user info
    if ([defaults boolForKey:@"loggedInWithFacebook"]) {
        FBSession* session = [FBSession activeSession];
        [session closeAndClearTokenInformation];
        session = nil;
        [self performLogoutWith:@"Facebook"];
    }
    if ([defaults boolForKey:@"loggedInWithTwitter"]) {
        [[Twitter sharedInstance] logOut];
        [self performLogoutWith:@"Twitter"];
    }
    if ([defaults boolForKey:@"loggedInWithGoogle"]){
        [[GPPSignIn sharedInstance] signOut];
        [self performLogoutWith:@"Google"];
    }
    if ([defaults boolForKey:@"loggedInWithVkontakte"]){
        [VKSdk forceLogout];
        [self performLogoutWith:@"Vkontakte"];
    }
}

-(void)performLogoutWith:(NSString*)socialNetwork {
    //rewrite user defaults
    [defaults setBool:NO forKey:@"loggedIn"];
    [defaults setBool:NO forKey:[NSString stringWithFormat:@"loggedInWith%@", socialNetwork]];
    [defaults setObject:@"null" forKey:@"id"];
    [defaults setObject:@"null" forKey:@"username"];
    [defaults setObject:@"null" forKey:@"useremail"];
    [defaults setBool:NO forKey:@"informationSent"];
    [defaults synchronize];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *CDPicturerequest = [[NSFetchRequest alloc]initWithEntityName:@"Picture"];
    CDPicturerequest.predicate = nil;
    NSArray *Pictureresults = [context executeFetchRequest:CDPicturerequest error:NULL];
    for (NSManagedObject * picture in Pictureresults) {
        [context deleteObject:picture];
    }
    NSError *saveError = nil;
    NSFetchRequest *CDArtistrequest = [[NSFetchRequest alloc]initWithEntityName:@"Artist"];
    CDArtistrequest.predicate = nil;
    NSArray *Artistresults = [context executeFetchRequest:CDArtistrequest error:NULL];
    for (NSManagedObject * artist in Artistresults) {
        [context deleteObject:artist];
    }
    [context save:&saveError];
    [[SDImageCache sharedImageCache]clearDisk];

    //rewrite session
    SessionControl* control = [SessionControl sharedManager];
    [control reset];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)DeleteAccount:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
message:@"You will not be able to recover your account info" delegate:self
cancelButtonTitle:@"No"
otherButtonTitles:@"Yes", nil];
    [alert show];
}

#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        //current url for request
        //NSURL* url = [NSURL URLWithString:[@"http://192.168.103.5/" stringByAppendingString:[defaults objectForKey:@"id"]] ];
        NSURL* url = [NSURL URLWithString:[@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/" stringByAppendingString:[defaults objectForKey:@"id"]] ];
        //creating request to use it with dataTask
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        //preparing session and request
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
        request.HTTPMethod = @"DELETE";
        NSFetchRequest *CDPicturerequest = [[NSFetchRequest alloc]initWithEntityName:@"Picture"];
        CDPicturerequest.predicate = nil;
        NSArray *Pictureresults = [context executeFetchRequest:CDPicturerequest error:NULL];
        for (NSManagedObject * picture in Pictureresults) {
            [context deleteObject:picture];
        }
        NSError *saveError = nil;
        NSFetchRequest *CDArtistrequest = [[NSFetchRequest alloc]initWithEntityName:@"Artist"];
        CDArtistrequest.predicate = nil;
        NSArray *Artistresults = [context executeFetchRequest:CDArtistrequest error:NULL];
        for (NSManagedObject * artist in Artistresults) {
            [context deleteObject:artist];
        }
        [context save:&saveError];
        [[SDImageCache sharedImageCache]clearDisk];
        
        //request.timeoutInterval = 20;
        //creating data task
        
        NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data,                                                                                                  NSURLResponse *response,                                                                                                  NSError *error) {
                                                        //logging received response
                                                        NSLog(@"%@",response);
                                                        [self logoutButtonAction:nil];
                                                        
                                                        
                                                    }];
        //sending data task
        
        [dataTask resume];

    }
}

@end
