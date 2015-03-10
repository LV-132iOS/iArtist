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
#import "SNClient.h"

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
    [super viewWillAppear:animated];
    SessionControl* control = [SessionControl sharedManager];
    [control refreshWithCompletionHandler:^{
    //    SNSocialNetwork* network = [[SNClient getFabricWithName:[control currentSocialNetwork]] getSocialNetwork];
        defaults = [NSUserDefaults standardUserDefaults];
        self.nameLabel.text = [defaults objectForKey:@"username"];
        self.emailLabel.text = [[defaults objectForKey:@"useremail"] stringByRemovingPercentEncoding];
        self.loggedinLabel.text = [defaults objectForKey:@"loggedInWith"];
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonAction:(id)sender {
    NSString* locString = self.loggedinLabel.text;
    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:locString];
    SNSocialNetwork* network = [fabric getSocialNetwork];
    [network logOutWithCompletionHandler:^{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loggedIn"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
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
         SessionControl* control = [SessionControl sharedManager];
        SNSocialNetwork* network = [[SNClient getFabricWithName:[control currentSocialNetwork]] getSocialNetwork];
        [network deleteAccountWithCompletionHandler:^{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loggedIn"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];

    }
}

@end
