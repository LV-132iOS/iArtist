//
//  AVDetailViewController.h
//  iArtist
//
//  Created by Andrii V. on 31.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FullSizePictureViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *mainView;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIImage *ImageThumb;

@property (strong, nonatomic) NSDictionary *paintingData;

@property (strong, nonatomic) NSDictionary *artistData;

@property (strong, nonatomic) UIImage *ImageThumb;


@end
