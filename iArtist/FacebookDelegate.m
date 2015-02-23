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
    
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user{
    //if we here - then there is no errors
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //prevent from multiple throws
    if ([defaults boolForKey:@"informationSent"] == NO ) {
        //creactig info for user
        NSString* locString = [@"fb" stringByAppendingString:[user objectForKey:@"id"]];
        [defaults setObject:locString forKey:@"id"];
        [defaults setObject:[user objectForKey:@"name"] forKey:@"username"];
        [defaults setObject:[user objectForKey:@"email"] forKey:@"useremail"];
        //send info to server
        NSDictionary* info = @{ @"with": @"Facebook" };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SendInfo" object:nil userInfo:info];

    }
 }

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    // If the user should perform an action outside of your app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"User cancelled login");
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    //show alert message if needed
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
