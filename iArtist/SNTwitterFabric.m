//
//  SNTwitterFabric.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNTwitterFabric.h"

@implementation SNTwitterFabric

-(SNSocialNetwork *)getSocialNetwork {
    SNTwitterSocialNetwork *network = [SNTwitterSocialNetwork sharedManager];
    return network;
}

-(SNSocialNetworkButton *)getSocialNetworkLoginButtonAtView:(UIView *)view withPosition:(CGPoint)position {
    return Nil;
}

-(SNSocialNetworkButton *)getSocialNetworkShareButtonAtView:(UIView *)view withPosition:(CGPoint)position {
    return Nil;
}

@end
