//
//  SNSocialNetwork.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNSocialNetwork.h"

#define needToRewrite()    @throw ([NSException exceptionWithName:@"Usnig abstract class" reason:@"Method must be overwritten" userInfo:nil]);

@implementation SNSocialNetwork

-(void)setIsLoggedIn:(BOOL)isLoggedIn {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoggedInChanged" object:nil];
    _isLoggedIn = isLoggedIn;
}


//class methods

+(id) sharedManager {
   needToRewrite()
}

//general methods

-(void) logIn {
    needToRewrite()
}

-(void) logOut {
    needToRewrite()
}

-(void) deleteAccount {
    needToRewrite()
}

-(void) askForSharing {
    needToRewrite()
}

-(void) shareInfo:(NSDictionary*)info withViewController:(UIViewController*)controller {
    needToRewrite()
}


@end
