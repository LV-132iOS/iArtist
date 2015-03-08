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
#import "SNClient.h"




@class GPPSignInButton;


@interface LoginViewController (){
    dispatch_semaphore_t semaphore;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loggedInChanged)
                                                     name:@"isLoggedInChanged"
                                                   object:nil];
        semaphore = dispatch_semaphore_create(0);
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loggedInChanged {
    dispatch_semaphore_signal(semaphore);
    
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
    [network logIn];
    
    dispatch_queue_t q = dispatch_queue_create("lbl", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(q, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [SNClient logInWithSocialNetwork:network];
        NSLog(@"done");
        [self CloseView:nil];
    });
    

}
- (IBAction)loginWithFacebook:(id)sender {
    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameFacebook];
    SNSocialNetwork* network = [fabric getSocialNetwork];
    [network logIn];
    
    dispatch_queue_t q = dispatch_queue_create("lbl", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(q, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [SNClient logInWithSocialNetwork:network];
        NSLog(@"done");
        [self CloseView:nil];
    });
}

@end
