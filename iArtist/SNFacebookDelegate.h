//
//  SNFacebookDelegate.h
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNSocialNetworkDelegate.h"
#import <FacebookSDK/FacebookSDK.h> 


@interface SNFacebookDelegate : SNSocialNetworkDelegate

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error complete:(void(^)())handler;
@end
