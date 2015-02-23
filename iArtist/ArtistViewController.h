//
//  ArtistViewController.h
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageOfArtist;
@property (strong, nonatomic) UIImage *img;
@property (strong, nonatomic) NSDictionary *CurrentArtist;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *descr;
@property (strong, nonatomic) NSString *followers;
@property (strong, nonatomic) NSString *tosell;
@property (weak, nonatomic) IBOutlet UILabel *nameOfArtist;
@property (weak, nonatomic) IBOutlet UILabel *locationOfArtist;
@property (weak, nonatomic) IBOutlet UITextView *descriptionOfArtist;
@property (weak, nonatomic) IBOutlet UILabel *Folowers;
@property (weak, nonatomic) IBOutlet UILabel *tosale;

@end
