//
//  AVNewsTableCell.h
//  iArtist
//
//  Created by Andrii V. on 02.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVPicture.h"
#import "AVAuthor.h"
#import "ActivityIndicator.h"

@interface NewsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView  *pictureImage;
@property (strong, nonatomic) IBOutlet UIImageView  *authorImage;
@property (strong, nonatomic) IBOutlet UILabel      *pictureName;
@property (strong, nonatomic) IBOutlet UILabel      *pictureTag;
@property (strong, nonatomic) IBOutlet UILabel      *authorName;
@property (strong, nonatomic) IBOutlet UITextView   *newsDescription;
@property (weak, nonatomic)   IBOutlet UILabel      *date;
@property (strong, nonatomic)          NSDictionary *picture;
@property (strong, nonatomic)          NSDictionary *author;

@property (strong, nonatomic) IBOutlet ActivityIndicator *loadPictureIndicator;

- (void) reloadCell;

@end
