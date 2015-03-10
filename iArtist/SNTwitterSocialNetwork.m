//
//  SNTwitterSocialNetwork.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNTwitterSocialNetwork.h"
#import "SNClient.h"
#import "SessionControl.h"
#import <Fabric/Fabric.h>

@implementation SNTwitterSocialNetwork

+(id) sharedManager {
    static SNTwitterSocialNetwork *sharedMyManager = nil;
    static SNTwitterDelegate *delegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        delegate = [[SNTwitterDelegate alloc] init];
        sharedMyManager.delegate = delegate;
        delegate.network = sharedMyManager;
        sharedMyManager.socialName = @"Twitter";
        sharedMyManager.clientID = @"y8DNDO0szLitsLoo4tsVJWnwm";
        
        sharedMyManager.clientSecret = @"2APu9hHFWBuUI7YlFIYG9JJOYuaKTEAtDWeAvnAwmvrmhM7Ict";
        [[Twitter sharedInstance] startWithConsumerKey:sharedMyManager.clientID
                                        consumerSecret:sharedMyManager.clientSecret];
        [Fabric with:@[TwitterKit]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        sharedMyManager.userid = [defaults objectForKey:@"userid"];
        sharedMyManager.username = [defaults objectForKey:@"username"];
        sharedMyManager.useremail = [defaults objectForKey:@"useremail"];
        
    });
    
    return sharedMyManager;
}

//general methods

-(void) logInWithCompletionHandler:(void(^)())handler {
    NSArray* scope = @[ @"none"];
    self.isMainAuth = YES;
    self.permissions = scope;
    
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         
         if (session) {
             self.userid = [@"tw" stringByAppendingString:session.userID];
             self.username = session.userName;
             [SNClient logInWithSocialNetwork:self WithCompletionHandler:^{
                 self.isLoggedIn = YES;
             }];
             handler();
         } else {
          //   NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
}

-(void) logOutWithCompletionHandler:(void(^)())handler {
    self.isLoggedIn = NO;
    self.isMainAuth = NO;
    [CDManager deleteAccountInfoFromCD];
    [[Twitter sharedInstance] logOut];
    SessionControl* control = [SessionControl sharedManager];
    [control reset];
    handler();
}

-(void) deleteAccountWithCompletionHandler:(void(^)())handler {
    [self logOutWithCompletionHandler:^{
     //   NSLog(@"account deleted");
    }];
    [CDManager deleteAccountInfoFromServerWithCompletionHandler:handler];
    
}

-(void) askForSharingWithCompletionHandler:(void(^)())handler {
    if (self.isSharingGranted == NO) {
        handler();
    }
}

-(void) shareInfo:(NSDictionary*)info withViewController:(UIViewController*)controller WithCompletionHandler:(void(^)())handler {
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    [composer setText:[info valueForKey:@"text"]];
    [composer setImage:[info valueForKey:@"image"]];
    
    [composer showWithCompletion:^(TWTRComposerResult result) {
        handler();
        if (result == TWTRComposerResultCancelled) {
         //   NSLog(@"Tweet composition cancelled");
        }
        else {
         //   NSLog(@"Sending Tweet!");
        }
    }];
    
}


@end
