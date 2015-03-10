//
//  EmailRegisterController.m
//  iArtist
//
//  Created by Vitalii Zamirko on 3/9/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "EmailRegisterController.h"
#import "SNClient.h"

@implementation EmailRegisterController

-(BOOL)rightPassword:(NSString*)pass {
    return YES;
}

- (IBAction)registerButtonAction:(id)sender {
    if (
        (![self.nameField.text isEqualToString:@""]) &&
        (![self.emailField.text isEqualToString:@""]) &&
        (![self.passwordField.text isEqualToString:@""]) &&
        (![self.confirmPasswordField.text isEqualToString:@""]) ) {
        
        if ([self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
            
            if ([self rightPassword:self.passwordField.text]) {
                SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameEmail];
                SNSocialNetwork* network = [fabric getSocialNetwork];
                network.username = self.nameField.text;
                network.useremail = self.emailField.text;
                network.userid = self.passwordField.text;
                
                [network logInWithCompletionHandler:^{
                    [SNClient signUpWithEmail:network WithCompletionHandler:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
                        network.isLoggedIn = YES;
                    }];
                }];
                
            } else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Password is incorrect"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            
            
            
            
            
            
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Password and confirm password are not equal"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
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
