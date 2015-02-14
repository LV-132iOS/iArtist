//
//  AVPainterViewController.h
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 26.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVPopoverTableViewController.h"
#import "AVPicture.h"
#import "AVWall.h"
#import "AVSession.h"
#import "AVPictureViewController.h"
#import "AVManager.h"

//#import <QuartzCore/QuartzCore.h>


@interface AVPainterViewController : UIViewController <UIGestureRecognizerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *roomImage;
@property (strong, nonatomic) IBOutlet UIImageView *pictureImage;
@property (strong, nonatomic) AVSession *session;
@property (strong, nonatomic) AVPicture *currentPicture;
@property (strong, nonatomic) AVWall *currentWall;
@property (strong, nonatomic) AVManager *dataManager;
@property (nonatomic) NSInteger pictureIndex;
@property (nonatomic, strong) NSDictionary *AllPaintingData;
@property (strong,nonatomic) NSMutableArray *ImageArray;
@property (nonatomic, strong) NSDictionary *CurrentPainting;
@property (nonatomic, strong) NSDictionary *CurrentArtist;



- (void) hideViews;
- (void) pushVies;

@end
