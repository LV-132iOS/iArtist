//
//  GooglePlusDelegate.m
//  iArtist
//
//  Created by Vitalii Zamirko on 2/2/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "GooglePlusDelegate.h"

@implementation GooglePlusDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error{
    if (!error) {
        NSLog(@"Description of received object %@", auth);
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults boolForKey:@"loggedInWithGoogle"] == NO) {
            [defaults setBool:YES forKey:@"loggedInWithGoogle"];
            [defaults setBool:YES forKey:@"loggedIn"];
            [defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:nil];
            
            NSLog(@"Now we have information to pass");
            NSString* localString = [[NSString alloc] init];
            GPPSignIn* signIn = [GPPSignIn sharedInstance];
            localString = signIn.googlePlusUser.displayName;
            [defaults setObject:localString forKey:@"username"];
            localString = signIn.userEmail;
            [defaults setObject:localString forKey:@"useremail"];
            NSLog(@"username = %@", [defaults objectForKey:@"username"]);
            
            NSLog(@"User logged in");
        }
    } else{
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to log in"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        NSLog(@"Error wih Google auth %@", [error localizedDescription]);
        
    }
}

- (void)didDisconnectWithError:(NSError *)error{
    if (!error) {
        //some code
    } else{
        NSLog(@"Error wih Google disconnect %@", [error localizedDescription]);
    }
}

@end
