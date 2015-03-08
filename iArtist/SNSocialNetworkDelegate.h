//
//  SNSocialNetworkDelegate.h
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSocialNetwork.h"

@class SNSocialNetwork;

@interface SNSocialNetworkDelegate : NSObject

@property(nonatomic,strong) SNSocialNetwork *network;

@end
