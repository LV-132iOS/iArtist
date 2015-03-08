//
//  SNFacebookFabric.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNFacebookFabric.h"

@implementation SNFacebookFabric

-(SNSocialNetwork *)getSocialNetwork {
    SNFacebookSocialNetwork *network = [SNFacebookSocialNetwork sharedManager];
    return network;
}

-(SNSocialNetworkButton *)getSocialNetworkLoginButtonAtView:(UIView *)view withPosition:(CGPoint)position {
    return Nil;
}

-(SNSocialNetworkButton *)getSocialNetworkShareButtonAtView:(UIView *)view withPosition:(CGPoint)position {
    return Nil;
}

@end
