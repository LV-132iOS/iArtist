//
//  LoginViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "LoginViewController.h"
#import "FacebookDelegate.h"
#import <GoogleOpenSource/GTLPlusConstants.h>
#import "GooglePlusDelegate.h"

@class GPPSignInButton;


@interface LoginViewController (){
    FacebookDelegate* FBdelegate;
    GooglePlusDelegate* GDelegate;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Facebook
    FBdelegate = [[FacebookDelegate alloc] init];
    self.loginView.delegate = FBdelegate;
    self.loginView.readPermissions = @[@"public_profile", @"email"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(CloseView:)
                                                 name:@"UserLoggedIn"
                                               object:nil];
    //
    
    //Twitter
    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        // play with Twitter session
        if (!error) {
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults boolForKey:@"loggedInWithTwitter"] == NO) {
                [defaults setBool:YES forKey:@"loggedInWithTwitter"];
                [defaults setBool:YES forKey:@"loggedIn"];
                [defaults synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:nil];
                NSLog(@"User logged in");
            }
            
            NSString* localString = [[NSString alloc] init];
            localString = session.userName;
            [defaults setObject:localString forKey:@"username"];
            localString = @"unavailable";
            [defaults setObject:localString forKey:@"useremail"];
            
            NSLog(@"signed in as %@", [session userName]);
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];

    [logInButton setFrame:CGRectMake(16.0f, 102.0f, 268.0f, 44.0f)];
    [self.view addSubview:logInButton];
    //
    
    //Google+
    GDelegate = [[GooglePlusDelegate alloc] init];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,
                     kGTLAuthScopePlusUserinfoEmail,
                     nil];
    signIn.delegate = GDelegate;
    signIn.attemptSSO = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.shouldFetchGooglePlusUser = YES; 
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CloseView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginWithInstagram:(id)sender {
}

- (IBAction)loginWithVkontakte:(id)sender {
}


@end
