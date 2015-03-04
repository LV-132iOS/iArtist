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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendInfo)
                                                 name:@"SendInfo"
                                               object:nil];
    
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
            
            if ([defaults boolForKey:@"informationSent"] == NO){
            NSString* localString = [[NSString alloc] init];
            localString = session.userName;
            [defaults setObject:localString forKey:@"username"];
            localString = @"unavailable";
            [defaults setObject:localString forKey:@"useremail"];
            localString = @"tw";
            localString = [localString stringByAppendingString:session.userID];
            [defaults setObject:localString forKey:@"id"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendInfo" object:nil];
            }
            
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
    signIn.shouldFetchGoogleUserID = YES;
    //
    
    //Vkontakte
    
    //
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CloseView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)loginWithVkontakte:(id)sender {
    NSArray* vkScope = @[ @"email"];
        [VKSdk authorize:vkScope revokeAccess:YES];
}

-(void)sendInfo{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* dataToPass = @{ @"_id" : [defaults objectForKey:@"id"],
                                  @"username" : [defaults objectForKey:@"username"],
                                  @"useremail": [defaults objectForKey:@"useremail"] };
    
    
    NSURL* url = [NSURL URLWithString:@"http://192.168.103.5/users/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];

    NSData* data = [NSJSONSerialization dataWithJSONObject:dataToPass options:0 error:nil];
    request.HTTPMethod = @"POST"; 
    
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; //4
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                              NSURLResponse *response,
                                                                                              NSError *error) {
        NSLog(@"%@",response);
        NSLog(@"%@", data);
        
    }];
    
    [dataTask resume];
    [defaults setBool:YES forKey:@"informationSent"];
}


@end
