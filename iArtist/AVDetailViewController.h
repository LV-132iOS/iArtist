//
//  AVDetailViewController.h
//  iArtist
//
//  Created by Andrii V. on 31.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVPicture.h"
#import "AVAuthor.h"

@interface AVDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *mainView;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) AVPicture *inputPicture;

@property (strong, nonatomic) AVAuthor *pictureAuthor;

@property (strong, nonatomic) NSDictionary *paintingData;

@end
