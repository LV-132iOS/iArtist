//
//  VKDelegate.m
//  iArtist
//
//  Created by Vitalii Zamirko on 2/5/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "VKDelegate.h"

@interface VKDelegate(){
    NSUserDefaults* defaults;
}

@end

@implementation VKDelegate

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
    //if it is called then there is no error with vk login
    defaults = [NSUserDefaults standardUserDefaults];
    //getting additional info about user
    [[[VKApi users] get:@{ VK_API_FIELDS : @"first_name,last_name" }]
     executeWithResultBlock:^(VKResponse *response) {
         //creating id for user
         NSString* localString = @"vk";
         localString = [localString stringByAppendingString:newToken.userId];
         [defaults setObject:localString forKey:@"id"];
         //creating name for user
         localString = [[response.json[0][@"first_name"]
                         stringByAppendingString:@" " ]
                        stringByAppendingString:response.json[0][@"last_name"]];
         [defaults setObject:localString forKey:@"username"];
         //writing email to defaults
         [defaults setObject:newToken.email forKey:@"useremail"];
           //send info to server
         NSDictionary* info = @{ @"with": @"Vkontakte" };
         [[NSNotificationCenter defaultCenter] postNotificationName:@"SendInfo" object:nil userInfo:info];
     } errorBlock:^(NSError *error) {
         //something went wrong, do nothing
         NSLog(@"Error with getting user info from VK: %@", [error localizedDescription]);
     }];
}


- (BOOL)vkSdkIsBasicAuthorization{
    return NO;
}
@end
