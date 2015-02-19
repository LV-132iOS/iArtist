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
#import "AVNews.h"
#import "AVLikedViewController.h"
#import "AVDetailViewController.h"
#import "ServerFetcher.h"


@interface AVPictureViewController : UIViewController <iCarouselDelegate, iCarouselDataSource >

@property (strong, nonatomic) AVPicture *currentPicture;

@property (strong, nonatomic) AVSession *session;

@property (strong, nonatomic)AVManager *dataManager;

@property (nonatomic) NSUInteger index;


@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic, strong) NSDictionary *AllPaintingData;





@end



