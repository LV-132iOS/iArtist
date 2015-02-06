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
#import "AVSession.h"
#import "AVPainterViewController.h"
#import "AVManager.h"
//#import "AVTestViewController.h"
#import "AVNews.h"
#import "AVLikedViewController.h"
#import "AVDetailViewController.h"

@interface AVPictureViewController : UIViewController <iCarouselDelegate, iCarouselDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;

@property (strong, nonatomic) IBOutlet iCarousel *pictureView;

@property (strong, nonatomic) IBOutlet UIToolbar *upToolBar;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBarBatton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionBarBautton;

@property (strong, nonatomic) IBOutlet UILabel *titleOfSession;
@property (strong, nonatomic) IBOutlet UIButton *authorButton;

@property (strong, nonatomic) IBOutlet UIButton *previewOnWallButton;

@property (strong, nonatomic) AVPicture *currentPicture;

@property (strong, nonatomic) AVSession *session;

@property (strong, nonatomic)  UILabel *authorsName;
@property (strong, nonatomic)  UILabel *authorsType;
@property (strong, nonatomic)  UIImageView *authorsImage;

@property (strong, nonatomic)  IBOutlet UILabel *price;
@property (strong, nonatomic)  IBOutlet UILabel *pictureSize;

@property (nonatomic) NSInteger intputPictureIndex;
@property (nonatomic) NSInteger pictureIndex;

@property (strong, nonatomic)AVManager *dataManager;

@property (strong, nonatomic) UIViewController *painterController;

@property (strong, nonatomic) IBOutlet UIButton *bigPicture;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;

@end

