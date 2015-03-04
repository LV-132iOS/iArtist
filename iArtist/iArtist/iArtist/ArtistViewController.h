//
//  ArtistViewController.h
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageOfArtist;
@property (strong, nonatomic) IBOutlet UILabel *nameOfArtist;
@property (strong, nonatomic) IBOutlet UILabel *locationOfArtist;
@property (strong, nonatomic) IBOutlet UITextView *descriptionOfArtist;

@end
