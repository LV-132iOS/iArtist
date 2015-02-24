//
//  FacebookDelegate.m
//  iArtist
//
//  Created by Admin on 01.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "FacebookDelegate.h"

@implementation FacebookDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"loggedInWithFacebook"] == NO) {
        [defaults setBool:YES forKey:@"loggedInWithFacebook"];
        [defaults setBool:YES forKey:@"loggedIn"];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:nil];
        NSLog(@"User logged in");
    }
    NSLog(@"User is in log in mode");
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user{
    //1. check if user with such ID already exist
    //2. if no - create new user account at local DB and server
    //3. if yes - download all user`s info
    NSLog(@"Now we have information to pass");
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"informationSent"] == NO){
    NSString* localString = [[NSString alloc] init];
    localString = @"fb";
    localString = [localString stringByAppendingString:[user objectForKey:@"id"]];
    [defaults setObject:localString forKey:@"id"];
    localString = [user objectForKey:@"name"];
    [defaults setObject:localString forKey:@"username"];
    localString = [user objectForKey:@"email"];
    [defaults setObject:localString forKey:@"useremail"];   
    NSLog(@"username = %@", [defaults objectForKey:@"username"]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SendInfo" object:nil];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"loggedInWithFacebook"] == YES) {
        [defaults setBool:NO forKey:@"loggedInWithFacebook"];
        [defaults setBool:NO forKey:@"loggedIn"];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedOut" object:nil];
    }
    NSLog(@"User is in log out mode");
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    // If the user should perform an action outside of your app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        [defaults setBool:NO forKey:@"loggedInWithFacebook"];
        [defaults setBool:NO forKey:@"loggedIn"];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedOut" object:nil];
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"User cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
