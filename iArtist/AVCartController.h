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
static  NSMutableArray *PurchuasedImageArray;
static NSMutableArray *PurchuasedPaintingData;

@interface AVCartController : UIViewController<MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) AVManager *manager;

//@property (strong, nonatomic) AVSession *session;
@property (strong, nonatomic) NSMutableArray *ImageArray;

@property (strong, nonatomic) NSMutableDictionary *pictureInfo;

@property (nonatomic, strong) NSMutableArray *AllPaintingData;

@property(strong, nonatomic) MFMailComposeViewController *myMail;

@end
