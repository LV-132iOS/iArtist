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

//class methods

+(id) sharedManager {
   needToRewrite()
}

//general methods

-(void) logInWithCompletionHandler:(void(^)())handler; {
    needToRewrite()
}

-(void) logOutWithCompletionHandler:(void(^)())handler; {
    needToRewrite()
}

-(void) deleteAccountWithCompletionHandler:(void(^)())handler; {
    needToRewrite()
}

-(void) askForSharingWithCompletionHandler:(void(^)())handler; {
    needToRewrite()
}

-(void) shareInfo:(NSDictionary*)info withViewController:(UIViewController*)controller WithCompletionHandler:(void(^)())handler;{
    needToRewrite()
}


@end
