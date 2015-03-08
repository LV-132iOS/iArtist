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
        delegate.network.socialName = @"Facebook";
        delegate.network.clientID = @"fb1384822491823366";
        [FBLoginView class];
        
    });
    
    return sharedMyManager;
}

//general methods

-(void) logIn {
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
         [((SNFacebookDelegate*)self.delegate) sessionStateChanged:session state:state error:error];
         
         
     }];
    
}

-(void) logOut {
    [FBSession.activeSession closeAndClearTokenInformation];
    [CDManager deleteAccountInfoFromCD];
    SessionControl* control = [SessionControl sharedManager];
    [control reset];
}

-(void) deleteAccount {
    [self logOut];
    [CDManager deleteAccountInfoFromServer];
    
}

-(void) askForSharing {
    if (self.isSharingGranted == NO) {
        NSArray* scope = @[ @"publish_actions"];
        self.isNotMainAuth = YES;
        if ([FBSession activeSession].state !=FBSessionStateOpen ) {
            [FBSession openActiveSessionWithPublishPermissions:scope
                                               defaultAudience:FBSessionDefaultAudienceEveryone
                                                  allowLoginUI:YES
                                             completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                                 
                                             }];
        } else {
            [[FBSession activeSession] requestNewPublishPermissions:scope
                                                    defaultAudience:FBSessionDefaultAudienceEveryone
                                                  completionHandler:^(FBSession *session, NSError *error) {
                                                      
                                                  }];
        }
        
        
        //[FBSession ref]
        self.permissions = scope;
    }
}

-(void) shareInfo:(NSDictionary*)info withViewController:(UIViewController*)controller {
    
      
}

@end
