//
//  AVCartController.h
//  iArtist
//
//  Created by Andrii V. on 04.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVManager.h"
#import "AVSession.h"
#import <MessageUI/MessageUI.h>

@interface AVCartController : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) AVManager *manager;

//@property (strong, nonatomic) AVSession *session;
@property (strong, nonatomic) NSMutableArray *pictureArray;

@property(strong, nonatomic) MFMailComposeViewController *myMail;

@end
