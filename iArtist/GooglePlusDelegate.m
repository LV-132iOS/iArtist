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
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"flagForGoogleShare"] isEqualToString:@"yes"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IAgoogleShare object:nil];
    } else {
        if (!error) {
            //getting singleton object
            GPPSignIn* signIn = [GPPSignIn sharedInstance];
            //creating info for user
            NSString* localString = [@"g+" stringByAppendingString:signIn.userID];
            [defaults setObject:localString forKey:IAid];
            [defaults setObject:signIn.googlePlusUser.displayName forKey:IAusername];
            [defaults setObject:signIn.userEmail forKey:IAuseremail];
            //send info to server
            NSDictionary* info = @{ @"with": @"Google" };
            [[NSNotificationCenter defaultCenter] postNotificationName:IAsendInfo object:nil userInfo:info];
        } else{
            NSLog(@"Error wih Google %@", [error localizedDescription]);
        }
        
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
