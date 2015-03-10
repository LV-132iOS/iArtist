//
//  AVDetailViewController.h
//  iArtist
//
//  Created by Andrii V. on 31.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface FullSizePictureViewController : UIViewController<MFMailComposeViewControllerDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *mainView;

@property (strong, nonatomic) UIImageView *imageView;

@property(strong, nonatomic) MFMailComposeViewController *myMail;

@property (strong, nonatomic) NSDictionary *paintingData;

@property (strong, nonatomic) NSDictionary *artistData;

@property (strong, nonatomic) UIImage *ImageThumb;


@end
