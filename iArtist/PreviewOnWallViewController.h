//
//  AVPainterViewController.h
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 26.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetWallPopoverTableViewController.h"
#import "AVPicture.h"
#import "Wall.h"
#import "Sesion.h"
#import "iCaruselViewController.h"
#import "AVManager.h"
#import <MessageUI/MessageUI.h>

@interface PreviewOnWallViewController : UIViewController <UIGestureRecognizerDelegate, UIPopoverControllerDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *roomImage;
@property (strong, nonatomic) IBOutlet UIImageView *pictureImage;
@property (strong, nonatomic) Sesion *session;
@property (strong, nonatomic) AVPicture *currentPicture;
@property (strong, nonatomic) Wall *currentWall;
@property (strong, nonatomic) AVManager *dataManager;
@property (nonatomic) NSInteger pictureIndex;
@property (nonatomic, strong) NSDictionary *AllPaintingData;
@property (strong,nonatomic) NSMutableArray *ImageArray;
@property (nonatomic, strong) NSDictionary *CurrentPainting;
@property (nonatomic, strong) NSDictionary *CurrentArtist;
@property(strong, nonatomic) MFMailComposeViewController *myMail;

extern NSString *const BackToiCaruselViewController;

- (void) hideViews;
- (void) pushVies;

@end
