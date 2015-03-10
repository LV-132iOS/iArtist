//
//  SNFacebookDelegate.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNFacebookDelegate.h"

@implementation SNFacebookDelegate

// Handles session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error complete:(void (^)())handler
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
       // [self userLoggedIn];
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // Success! Include your code to handle the results here
                NSString* localString = @"fb";
                localString = [localString stringByAppendingString:[result objectForKey:@"id"]];
                self.network.userid = localString;
                localString = [result objectForKey:@"name"];
                self.network.username = localString;
                localString = [result objectForKey:@"email"];
                self.network.useremail = localString;
                self.network.isLoggedIn = YES;
                handler();
                
            } else {

            }
        }];

        self.network.basicToken = session.accessTokenData.accessToken;
        
        //!
        for (NSString* str in session.accessTokenData.permissions) {
            if ([str isEqualToString:@"????"]) {
                self.network.isSharingGranted = YES;
            }
        }
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
       // [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"FB Error");
        
    }
}

@end
