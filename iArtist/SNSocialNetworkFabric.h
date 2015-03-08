//
//  SocialNetworkFabric.h
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SNSocialNetwork.h"

@class SNSocialNetworkButton;

@interface SNSocialNetworkFabric : NSObject

-(SNSocialNetwork*) getSocialNetwork;

-(SNSocialNetworkButton*) getSocialNetworkLoginButtonAtView:(UIView*)view withPosition:(CGPoint)position;

-(SNSocialNetworkButton*) getSocialNetworkShareButtonAtView:(UIView*)view withPosition:(CGPoint)position;

@end
