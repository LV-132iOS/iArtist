//
//  SNGooglePlusSocialNetwork.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNGooglePlusSocialNetwork.h"

@implementation SNGooglePlusSocialNetwork


+(id) sharedManager {
    static SNGooglePlusSocialNetwork *sharedMyManager = nil;
    static SNGooglePlusDelegate *delegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        delegate = [[SNGooglePlusDelegate alloc] init];
        sharedMyManager.delegate = delegate;
        delegate.network = sharedMyManager;
        sharedMyManager.socialName = @"GooglePlus";
        sharedMyManager.clientID = @"151071407108-tdf2fd0atjggs26i68tepgupb0501k8u.apps.googleusercontent.com";
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        signIn.shouldFetchGooglePlusUser = YES;
        signIn.shouldFetchGoogleUserEmail = YES;
        signIn.shouldFetchGoogleUserID = YES;
        signIn.clientID = sharedMyManager.clientID;
        
        // Uncomment one of these two statements for the scope you chose in the previous step
        //signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
        signIn.scopes = @[ @"profile" ];            // "profile" scope
        
        // Optional: declare signIn.actions, see "app activities"
        signIn.delegate = (id) sharedMyManager.delegate;
        signIn.attemptSSO = YES;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        sharedMyManager.userid = [defaults objectForKey:@"userid"];
        sharedMyManager.username = [defaults objectForKey:@"username"];
        sharedMyManager.useremail = [defaults objectForKey:@"useremail"];
        
    });
    
    return sharedMyManager;
}

//general methods

-(void) logInWithCompletionHandler:(void(^)())handler {
    self.delegate.block = handler;
    NSArray* scope = @[ @"profile"];
    self.isMainAuth = YES;
    self.permissions = scope;
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    [signIn authenticate];

}

-(void) logOutWithCompletionHandler:(void(^)())handler {
    self.isLoggedIn = NO;
    self.isMainAuth = NO;
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    [signIn signOut];
    [CDManager deleteAccountInfoFromCD];
    SessionControl* control = [SessionControl sharedManager];
    [control reset];
    handler();
}

-(void) deleteAccountWithCompletionHandler:(void(^)())handler {
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    [signIn disconnect];
    [self logOutWithCompletionHandler:^{
      //  NSLog(@"account deleted");
    }];
    [CDManager deleteAccountInfoFromServerWithCompletionHandler:handler];
    
}

-(void) askForSharingWithCompletionHandler:(void(^)())handler {
    if (self.isSharingGranted == NO) {
        self.delegate.block = handler;
        NSArray* scope = @[ kGTLAuthScopePlusLogin ];
        self.permissions = scope;
        self.isNotMainAuth = YES;
        GPPSignIn* signIn = [GPPSignIn sharedInstance];
        signIn.scopes = scope;
        
        [signIn authenticate];
        self.delegate.block = handler;
        
    }
}

-(void) shareInfo:(NSDictionary*)info withViewController:(UIViewController*)controller WithCompletionHandler:(void(^)())handler {

    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    
    // This line will fill out the title, description, and thumbnail from
    // the URL that you are sharing and includes a link to that URL.
   // [shareBuilder setURLToShare:[info valueForKey:@"url"]];
    [shareBuilder attachImage:[info valueForKey:@"image"]];
    [shareBuilder setPrefillText:[info valueForKey:@"text"]];
    [shareBuilder open];
}



@end
