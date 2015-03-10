//
//  SNFacebookSocialNetwork.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNFacebookSocialNetwork.h"
#import "SessionControl.h"

@implementation SNFacebookSocialNetwork

+(id) sharedManager {
    static SNFacebookSocialNetwork *sharedMyManager = nil;
    static SNFacebookDelegate *delegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        delegate = [[SNFacebookDelegate alloc] init];
        sharedMyManager.delegate = delegate;
        delegate.network = sharedMyManager;
        sharedMyManager.socialName = @"Facebook";
        sharedMyManager.clientID = @"fb1384822491823366";
        [FBLoginView class];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        sharedMyManager.userid = [defaults objectForKey:@"userid"];
        sharedMyManager.username = [defaults objectForKey:@"username"];
        sharedMyManager.useremail = [defaults objectForKey:@"useremail"];
        
    });
    
    return sharedMyManager;
}

//general methods

-(void) logInWithCompletionHandler:(void (^)())handler {
    NSArray* fbScope = @[ @"public_profile", @"email"];
    self.isMainAuth = YES;
    self.permissions = fbScope;
    
    // Open a session showing the user the login UI
    // You must ALWAYS ask for public_profile permissions when opening a session
    [FBSession openActiveSessionWithReadPermissions:fbScope
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [((SNFacebookDelegate*)self.delegate) sessionStateChanged:session
                                                             state:state
                                                             error:error
                                                          complete:handler];
         
         
     }];
    
}

-(void) logOutWithCompletionHandler:(void (^)())handler {
    self.isLoggedIn = NO;
    self.isMainAuth = NO;
    [[FBSession activeSession] closeAndClearTokenInformation];
    FBSession.activeSession = nil;
    [CDManager deleteAccountInfoFromCD];
    SessionControl* control = [SessionControl sharedManager];
    [control reset];
    handler();
}

-(void) deleteAccountWithCompletionHandler:(void (^)())handler {
    [self logOutWithCompletionHandler:^{
        [CDManager deleteAccountInfoFromServerWithCompletionHandler:handler];

    }];
    
}

-(void) askForSharingWithCompletionHandler:(void (^)())handler {
    if (self.isSharingGranted == NO) {
//        NSArray* scope = @[ @"publish_actions"];
//        self.isNotMainAuth = YES;
//        if ([FBSession activeSession].state !=FBSessionStateOpen ) {
//            [FBSession openActiveSessionWithPublishPermissions:scope
//                                               defaultAudience:FBSessionDefaultAudienceEveryone
//                                                  allowLoginUI:YES
//                                             completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                                                 if (!error) handler();
//                                             }];
//        } else {
//            [[FBSession activeSession] requestNewPublishPermissions:scope
//                                                    defaultAudience:FBSessionDefaultAudienceEveryone
//                                                  completionHandler:^(FBSession *session, NSError *error) {
//                                                      if (!error) handler();
//                                                  }];
//        }
//        
//        
//        //[FBSession ref]
//        self.permissions = scope;
        handler();
    }
}

-(void) shareInfo:(NSDictionary*)info withViewController:(UIViewController*)controller WithCompletionHandler:(void (^)())handler {
   
    
      
}

@end
