//
//  LoginViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "LoginViewController.h"
#import "FacebookDelegate.h"

@interface LoginViewController (){
    FacebookDelegate* FBdelegate;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FBdelegate = [[FacebookDelegate alloc] init];
    self.loginView.delegate = FBdelegate;
    self.loginView.readPermissions = @[@"public_profile"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(CloseView:)
                                                 name:@"UserLoggedIn"
                                               object:nil];
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

- (IBAction)loginWithTwitter:(id)sender {
}

- (IBAction)loginWithGoogle:(id)sender {
}

@end
