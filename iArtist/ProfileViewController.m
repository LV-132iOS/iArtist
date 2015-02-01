//
//  ProfileViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.nameLabel.text = (NSString*) [defaults objectForKey:@"username"];
    self.emailLabel.text = (NSString*) [defaults objectForKey:@"useremail"];
    if ([defaults boolForKey:@"loggedInWithFacebook"]) {
        self.loggedinLabel.text = @"Facebook";
        self.changePasswordButton.hidden = YES;
        
        FBSession* session = [FBSession activeSession];

        [session refreshPermissionsWithCompletionHandler:^(FBSession *session, NSError *error) {
            if (error) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Facebook log-in error"
                                                                    message:@"Please, try to log-in again"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                [alertView show];
                [session closeAndClearTokenInformation];
                [defaults setBool:NO forKey:@"loggedIn"];
                [defaults setBool:NO forKey:@"loggedInWithFacebook"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedOut" object:nil];
                [session closeAndClearTokenInformation];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else{
                NSLog(@"Everything is OK with FB session");
            }
        }];
        
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cartButtonAction:(id)sender {
    //open cart view modal
}

- (IBAction)logoutButtonAction:(id)sender {
    //logout means sending info about logout to server,
    //deleteing info at local DB and
    //sending notification to programme
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];    
    if ([defaults boolForKey:@"loggedInWithFacebook"]) {
        FBSession* session = [FBSession activeSession];
        [session closeAndClearTokenInformation];
        [defaults setBool:NO forKey:@"loggedIn"];
        [defaults setBool:NO forKey:@"loggedInWithFacebook"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedOut" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if ([defaults boolForKey:@"loggedIn"]){
        [defaults setBool:NO forKey:@"loggedIn"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedOut" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
