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
    NSUserDefaults* defaults;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    //notification to close this view controller (used by social networks delegates)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(CloseView:)
                                                 name:@"NeedCloseLoginView"
                                               object:nil];
    
    //setting Twitter
    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        // play with Twitter session
        if (!error) {
            //write user info to user defaults
            NSString*  localString = @"unavailable";
            [defaults setObject:session.userName forKey:@"username"];
            [defaults setObject:localString forKey:@"useremail"];
            //creating unique user id and write it to user defaults
            localString = @"tw";
            localString = [localString stringByAppendingString:session.userID];
            [defaults setObject:localString forKey:@"id"];
            [defaults synchronize];
            //if logged in successfully - then send info to server
            NSDictionary* info = @{ @"with": @"Twitter" };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendInfo" object:nil userInfo:info];
        } else {
            //something went wrong with twitter log in, log error and do nothing
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
    [logInButton setFrame:CGRectMake(16.0f, 102.0f, 268.0f, 44.0f)];
    [self.view addSubview:logInButton];
    
    //setting Google+
    GDelegate = [[GooglePlusDelegate alloc] init];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,
                     kGTLAuthScopePlusUserinfoEmail,
                     nil];
    signIn.attemptSSO = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserID = YES;
    signIn.delegate = GDelegate;
    //vkontakte button doesnt need such setting
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CloseView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //setting Facebook
    FBdelegate = [[FacebookDelegate alloc] init];
    self.loginView.delegate = FBdelegate;
    self.loginView.readPermissions = @[@"public_profile", @"email"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.loginView.delegate = nil;
}

- (IBAction)loginWithVkontakte:(id)sender {
    //first it will try to open vk app. If fails then will open safari
    NSArray* vkScope = @[ @"email"];
    [VKSdk authorize:vkScope  revokeAccess:YES forceOAuth:NO inApp:NO];
}

@end
