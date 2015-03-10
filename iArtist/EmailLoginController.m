//
//  EmailLoginController.m
//  iArtist
//
//  Created by Vitalii Zamirko on 3/9/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "EmailLoginController.h"
#import "SNClient.h"

@implementation EmailLoginController
- (IBAction)loginButtonAction:(id)sender {
    
    if (
        (![self.emailField.text isEqualToString:@""]) &&
        (![self.passwordField.text isEqualToString:@""])
        ) {
        
                SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameEmail];
                SNSocialNetwork* network = [fabric getSocialNetwork];
                network.useremail = self.emailField.text;
                network.userid = self.passwordField.text;
                
                [network logInWithCompletionHandler:^{
                    [SNClient logInWithEmail:network WithCompletionHandler:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
                        network.isLoggedIn = YES;
                    }];
                }];
        
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Field/Fields must not be empty"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
