//
//  LoginViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "LoginViewController.h"
#import <GoogleOpenSource/GTLPlusConstants.h>
#import "SNClient.h"




@class GPPSignInButton;


@interface LoginViewController (){
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.loginView.delegate = nil;
}

- (IBAction)loginWithVkontakte:(id)sender {
    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameVkontakte];
    SNSocialNetwork* network = [fabric getSocialNetwork];
    network.delegate.block = nil;
    [network logInWithCompletionHandler:^{
        [SNClient logInWithSocialNetwork:network WithCompletionHandler:^{
            [self CloseView:nil];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"Vkontakte" forKey:@"loggedInWith"];
            [defaults setObject:network.userid forKey:@"userid"];
            [defaults setObject:network.username forKey:@"username"];
            [defaults setObject:network.useremail forKey:@"useremail"];

        }];
    }];

}


- (IBAction)loginWithFacebook:(id)sender {
    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameFacebook];
    SNSocialNetwork* network = [fabric getSocialNetwork];
    network.delegate.block = nil;
    [network logInWithCompletionHandler:^{
        [SNClient logInWithSocialNetwork:network WithCompletionHandler:^{
            [self CloseView:nil];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"Facebook" forKey:@"loggedInWith"];
            [defaults setObject:network.userid forKey:@"userid"];
            [defaults setObject:network.username forKey:@"username"];
            [defaults setObject:network.useremail forKey:@"useremail"];
        }];
    }];
}

- (IBAction)loginWithTwitter:(id)sender {
    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameTwitter];
    SNSocialNetwork* network = [fabric getSocialNetwork];
    network.delegate.block = nil;
    [network logInWithCompletionHandler:^{
            [self CloseView:nil];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"Twitter" forKey:@"loggedInWith"];
            [defaults setObject:network.userid forKey:@"userid"];
            [defaults setObject:network.username forKey:@"username"];
            [defaults setObject:network.useremail forKey:@"useremail"];
    }];

}
- (IBAction)loginWithGooglePlus:(id)sender {
    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameGooglePlus];
    SNSocialNetwork* network = [fabric getSocialNetwork];
    network.delegate.block = nil;
    [network logInWithCompletionHandler:^{
        [self CloseView:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"GooglePlus" forKey:@"loggedInWith"];
        [defaults setObject:network.userid forKey:@"userid"];
        [defaults setObject:network.username forKey:@"username"];
        [defaults setObject:network.useremail forKey:@"useremail"];
    }];
}

@end
