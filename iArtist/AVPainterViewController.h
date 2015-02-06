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

@interface AVPainterViewController : UIViewController <UIGestureRecognizerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIViewController *pictureController;

@property (strong, nonatomic) IBOutlet UIImageView *roomImage;

@property (strong, nonatomic) IBOutlet UIImageView *pictureImage;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipe;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipe;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;

@property (strong, nonatomic) IBOutlet UIToolbar *upToolBar;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBarBatton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraBurButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionBarBautton;

@property (strong, nonatomic) IBOutlet UILabel *titleOfPicture;

@property (strong, nonatomic) IBOutlet UIView *authorsView;

@property (strong, nonatomic) IBOutlet UILabel *authorsName;
@property (strong, nonatomic) IBOutlet UILabel *authorsType;
@property (strong, nonatomic) IBOutlet UIImageView *authorsImage;

@property (strong, nonatomic) IBOutlet UIView *priceView;

@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *pictureSize;

@property (strong, nonatomic) AVSession *session;

@property (strong, nonatomic) AVPicture *currentPicture;

@property (strong, nonatomic) AVPicture *previousPicture;

@property (strong, nonatomic) AVPicture *nextPicture;

@property (strong, nonatomic) AVWall *currentWall;

@property (strong, nonatomic) AVAuthor *currentAuthor;

@property (strong, nonatomic) AVManager *dataManager;

@property (nonatomic) NSInteger pictureIndex;

- (void) hideViews;

- (void) pushVies;

@end
