//
//  AVDetailViewController.h
//  iArtist
//
//  Created by Andrii V. on 31.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AVDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *mainView;

@property (strong, nonatomic) UIImageView *imageView;


@property (strong, nonatomic) NSDictionary *paintingData;

@property (strong, nonatomic) NSDictionary *artistData;


@end
