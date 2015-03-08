//
//  SNVkontakteDelegate.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNVkontakteDelegate.h"

@implementation SNVkontakteDelegate
- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError{
    //this should never be called
    NSLog(@"User need to enter VK captcha");
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken{
    //this should never be called because our tokens live for eternity
    NSLog(@"VK token has expired");
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError{
    //if user denied - do nothing, its his willing
    NSLog(@"USer denied access to VK");
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller{
    //this should not be ever called
    NSLog(@"Vk try to present uiwebview in app");
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken{
    // new token means new log in to app
    //if it is called thnen there is no error with vk login
    //getting additional info about user
    [[[VKApi users] get:@{ VK_API_FIELDS : @"first_name,last_name" }]
     executeWithResultBlock:^(VKResponse *response) {
         //creating id for user
         NSString* localString = @"vk";
         localString = [localString stringByAppendingString:newToken.userId];
         self.network.userid = localString;
         //creating name for user
         localString = [[response.json[0][@"first_name"]
                         stringByAppendingString:@" " ]
                        stringByAppendingString:response.json[0][@"last_name"]];
         self.network.username = localString;
         //writing email to defaults
         self.network.useremail = newToken.email;
         
         self.network.isLoggedIn = YES;
         self.network.basicToken = newToken.accessToken;
         
         //!
         for (NSString* str in newToken.permissions) {
             if ([str isEqualToString:@"wall"]) {
                 self.network.isSharingGranted = YES;
             }
         }
         
     } errorBlock:^(NSError *error) {
         //something went wrong, do nothing
         NSLog(@"Error with getting user info from VK: %@", [error localizedDescription]);
     }];
}


- (BOOL)vkSdkIsBasicAuthorization{
    return NO;
}

@end
