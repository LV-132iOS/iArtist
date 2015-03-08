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
        delegate.network.socialName = @"Vkontakte";
        delegate.network.clientID = @"4738060";
        [VKSdk initializeWithDelegate:delegate andAppId:delegate.network.clientID];
        [VKSdk wakeUpSession];
        
    });
    
    return sharedMyManager;
}

//general methods

-(void) logIn {
    NSArray* vkScope = @[ @"email"];
    self.isMainAuth = YES;
    self.permissions = vkScope;
    [VKSdk authorize:vkScope  revokeAccess:YES];
}

-(void) logOut {
    [VKSdk forceLogout];
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
    NSArray* vkScope = @[ @"email", @"wall"];
    self.isNotMainAuth = YES;
    self.permissions = vkScope;
    [VKSdk authorize:vkScope  revokeAccess:YES];
    }
}

-(void) shareInfo:(NSDictionary*)info withViewController:(UIViewController*)controller {
    VKShareDialogController * shareDialog = [VKShareDialogController new];
    VKUploadImage* locImage = [VKUploadImage uploadImageWithImage:[info valueForKey:@"image"]
                                                        andParams:[VKImageParameters pngImage]];
    
    shareDialog.dismissAutomatically = YES;
    shareDialog.text = [info valueForKey:@"text"];
    shareDialog.uploadImages = @[locImage];
    shareDialog.shareLink = [[VKShareLink alloc] initWithTitle:@"Picture on the wall"
                                                          link:[info valueForKey:@"url"]];
    [controller presentViewController:shareDialog animated:YES completion:nil];
}


@end
