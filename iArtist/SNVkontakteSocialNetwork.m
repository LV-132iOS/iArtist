//
//  SNVkontakteSocialNetwork.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNVkontakteSocialNetwork.h"
#import "SessionControl.h"

@implementation SNVkontakteSocialNetwork

+(id) sharedManager {
    static SNVkontakteSocialNetwork *sharedMyManager = nil;
    static SNVkontakteDelegate *delegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        delegate = [[SNVkontakteDelegate alloc] init];
        sharedMyManager.delegate = delegate;
        delegate.network = sharedMyManager;
        sharedMyManager.socialName = @"Vkontakte";
        sharedMyManager.clientID = @"4738060";
        [VKSdk initializeWithDelegate:delegate andAppId:sharedMyManager.clientID];
        [VKSdk wakeUpSession];
        
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
    NSArray* vkScope = @[ @"email"];
    self.isMainAuth = YES;
    self.permissions = vkScope;
    [VKSdk authorize:vkScope  revokeAccess:YES];
}

-(void) logOutWithCompletionHandler:(void(^)())handler {
    self.isLoggedIn = NO;
    self.isMainAuth = NO;
    [VKSdk forceLogout];
    [CDManager deleteAccountInfoFromCD];
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
    self.delegate.block = handler;
    NSArray* vkScope = @[ @"email", @"wall"];
    self.isNotMainAuth = YES;
    self.permissions = vkScope;
    [VKSdk authorize:vkScope  revokeAccess:YES];
    } else {
        handler();
    }
}

-(void) shareInfo:(NSDictionary*)info withViewController:(UIViewController*)controller WithCompletionHandler:(void(^)())handler {
    VKShareDialogController * shareDialog = [VKShareDialogController new];
    VKUploadImage* locImage = [VKUploadImage uploadImageWithImage:[info valueForKey:@"image"]
                                                        andParams:[VKImageParameters pngImage]];
    
    shareDialog.dismissAutomatically = YES;
    shareDialog.text = [info valueForKey:@"text"];
    shareDialog.uploadImages = @[locImage];
    shareDialog.shareLink = [[VKShareLink alloc] initWithTitle:@"Picture on the wall"
                                                          link:[info valueForKey:@"url"]];
    [controller presentViewController:shareDialog animated:YES completion:handler];
}


@end
