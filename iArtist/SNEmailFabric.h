//
//  SNEmailFabric.h
//  iArtist
//
//  Created by Vitalii Zamirko on 3/9/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNSocialNetworkFabric.h"
#import "SNEmailSocialNetwork.h"

@interface SNEmailFabric : SNSocialNetworkFabric
-(SNSocialNetwork *)getSocialNetwork;

-(SNSocialNetworkButton *)getSocialNetworkLoginButtonAtView:(UIView *)view withPosition:(CGPoint)position;

-(SNSocialNetworkButton *)getSocialNetworkShareButtonAtView:(UIView *)view withPosition:(CGPoint)position;

@end
