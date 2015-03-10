//
//  SNGooglePlusDelegate.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNGooglePlusDelegate.h"

@implementation SNGooglePlusDelegate

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
//    NSLog(@"Received error %@ and auth object %@",error, auth);
//    NSString* localString = [@"g+" stringByAppendingString:signIn.userID];
//    [defaults setObject:localString forKey:@"id"];
//    [defaults setObject:signIn.googlePlusUser.displayName forKey:@"username"];
//    [defaults setObject:signIn.userEmail forKey:@"useremail"];
    self.network.isLoggedIn = YES;
    GPPSignIn* signIn = [GPPSignIn sharedInstance];
    self.network.userid = [@"g+" stringByAppendingString:[auth.properties valueForKey:@"user_id"]];
    self.network.username = signIn.googlePlusUser.displayName;
    self.network.useremail = signIn.userEmail;
    if (self.block != nil) self.block();
}

@end
