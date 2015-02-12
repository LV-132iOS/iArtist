//
//  VKDelegate.m
//  iArtist
//
//  Created by Vitalii Zamirko on 2/5/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "VKDelegate.h"

@implementation VKDelegate

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError{
    
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken{
    
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError{
    
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller{
    
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"loggedInWithVkontakte"] == NO) {
        [defaults setBool:YES forKey:@"loggedInWithVkontakte"];
        [defaults setBool:YES forKey:@"loggedIn"];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:nil];
        NSLog(@"User logged in");
    }
    NSLog(@"User is in log in mode");
    
    NSLog(@"Now we have information to pass");
    
    if ([defaults boolForKey:@"informationSent"] == NO){
        [[[VKApi users] get:@{ VK_API_FIELDS : @"first_name,last_name" }]
         executeWithResultBlock:^(VKResponse *response) {
             NSLog(@"%@",response);
             NSString* localString = [[NSString alloc] init];
             localString = @"vk";
             localString = [localString stringByAppendingString:newToken.userId];
             [defaults setObject:localString forKey:@"id"];
             localString = [[response.json[0][@"first_name"]
                            stringByAppendingString:@" " ]
                            stringByAppendingString:response.json[0][@"last_name"]];
             [defaults setObject:localString forKey:@"username"];
             localString = newToken.email;
             [defaults setObject:localString forKey:@"useremail"];
             NSLog(@"username = %@", [defaults objectForKey:@"username"]);
             [[NSNotificationCenter defaultCenter] postNotificationName:@"SendInfo" object:nil];
             
         } errorBlock:^(NSError *error) {
             NSLog(@"Error: %@", error);
         }];

        
        
    }
    

    
}
 
- (BOOL)vkSdkIsBasicAuthorization{
    return NO;
}
@end
