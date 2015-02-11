//
//  ProfileViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ProfileViewController.h"
#import "SessionControl.h"

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
    //rewrite session
    SessionControl* control = [SessionControl sharedManager];
    [control reset];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
