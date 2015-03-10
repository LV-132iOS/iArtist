//
//  SNEmailFabric.m
//  iArtist
//
//  Created by Vitalii Zamirko on 3/9/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNEmailFabric.h"

@implementation SNEmailFabric

-(SNSocialNetwork *)getSocialNetwork {
    SNEmailSocialNetwork *network = [SNEmailSocialNetwork sharedManager];
    return network;
}

-(SNSocialNetworkButton *)getSocialNetworkLoginButtonAtView:(UIView *)view withPosition:(CGPoint)position {
    return Nil;
}

-(SNSocialNetworkButton *)getSocialNetworkShareButtonAtView:(UIView *)view withPosition:(CGPoint)position {
    return Nil;
}

@end
