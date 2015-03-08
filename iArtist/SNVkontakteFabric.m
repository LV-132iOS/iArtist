//
//  SNVkontakteFabric.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNVkontakteFabric.h"

@implementation SNVkontakteFabric

-(SNSocialNetwork *)getSocialNetwork {
    SNVkontakteSocialNetwork *network = [SNVkontakteSocialNetwork sharedManager];
    return network;
}

-(SNSocialNetworkButton *)getSocialNetworkLoginButtonAtView:(UIView *)view withPosition:(CGPoint)position {
    return Nil;
}

-(SNSocialNetworkButton *)getSocialNetworkShareButtonAtView:(UIView *)view withPosition:(CGPoint)position {
    return Nil;
}

@end
