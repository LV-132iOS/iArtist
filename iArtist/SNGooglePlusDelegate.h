//
//  SNGooglePlusDelegate.h
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNSocialNetworkDelegate.h"
#import <GooglePlus/GooglePlus.h> 
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface SNGooglePlusDelegate : SNSocialNetworkDelegate <GPPSignInDelegate>

@end
