//
//  FirstRunViewController.h
//  iArtist
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "FirstRunCarouselDelegateAndDataSource.h"

@interface FirstRunViewController : UIViewController

@property (strong, nonatomic) IBOutlet iCarousel *guideCarousel;

@end
