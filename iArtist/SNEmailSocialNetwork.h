//
//  SNEmailSocialNetwork.h
//  iArtist
//
//  Created by Vitalii Zamirko on 3/7/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNSocialNetwork.h"
#import "SNEmailDelegate.h"

@interface SNEmailSocialNetwork : SNSocialNetwork
@property(strong, nonatomic) MFMailComposeViewController *myMail;

@end
