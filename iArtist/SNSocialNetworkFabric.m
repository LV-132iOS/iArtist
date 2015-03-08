//
//  SocialNetworkFabric.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNSocialNetworkFabric.h"

#define needToRewrite()    @throw ([NSException exceptionWithName:@"Usnig abstract class" reason:@"Method must be overwritten" userInfo:nil]);

@implementation SNSocialNetworkFabric

-(SNSocialNetwork*) getSocialNetwork{
    needToRewrite();
}

-(SNSocialNetworkButton *)getSocialNetworkLoginButtonAtView:(UIView *)view withPosition:(CGPoint)position {
    needToRewrite();
}

-(SNSocialNetworkButton*) getSocialNetworkShareButtonAtView:(UIView*)view withPosition:(CGPoint)position {
    needToRewrite();
}


@end
