//
//  AVPictureViewController.h
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 27.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "AVPicture.h"
#import "Sesion.h"
#import "PreviewOnWallViewController.h"
#import "AVManager.h"
#import "NewsViewController.h"
#import "LikedViewController.h"
#import "FullSizePictureViewController.h"
#import "ServerFetcher.h"

#import <MessageUI/MessageUI.h>

@interface iCaruselViewController : UIViewController <iCarouselDelegate, iCarouselDataSource, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) AVPicture *currentPicture;

//@property (strong, nonatomic) Sesion *session;

@property (strong, nonatomic)AVManager *dataManager;

@property (nonatomic) NSUInteger index;


@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic, strong) NSDictionary *AllPaintingData;

@property(strong, nonatomic) MFMailComposeViewController *myMail;



@end



