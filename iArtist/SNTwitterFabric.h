//
//  SNTwitterFabric.h
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNSocialNetworkFabric.h"
#import "SNTwitterSocialNetwork.h"

@interface SNTwitterFabric : SNSocialNetworkFabric

-(SNSocialNetwork *)getSocialNetwork;

-(SNSocialNetworkButton *)getSocialNetworkLoginButtonAtView:(UIView *)view withPosition:(CGPoint)position;

-(SNSocialNetworkButton *)getSocialNetworkShareButtonAtView:(UIView *)view withPosition:(CGPoint)position;

@end
