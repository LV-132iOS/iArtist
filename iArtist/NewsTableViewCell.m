//
//  AVNewsTableCell.m
//  iArtist
//
//  Created by Andrii V. on 02.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "ServerFetcher.h"

@interface NewsTableViewCell()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadPictureIndicator;

@end

@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) reloadCell{
    [self.loadPictureIndicator startAnimating];
    self.loadPictureIndicator.transform = CGAffineTransformMakeScale(4, 4);
    self.loadPictureIndicator.hidesWhenStopped = YES;
    
    self.pictureImage.hidden = YES;
    self.pictureName.text = [self.picture valueForKey:@"title"];
    self.newsDescription.text = [self.picture valueForKey:@"description"];
    self.pictureTag.text = [(NSArray*)[self.picture valueForKey:@"tags"] componentsJoinedByString:@","];
    
    NSString *partOne = [[self.picture valueForKey:@"created_at"]substringToIndex:10];
    NSRange range = (NSRange){.location = 14,.length = 8};
    NSString *partSecond = [[self.picture valueForKey:@"created_at"]substringWithRange:range];
    
    self.date.text = [[partOne stringByAppendingString:@"  "]stringByAppendingString:partSecond];
    
    
    
    [[ServerFetcher sharedInstance]getPictureThumbWithSizeAndID:[self.picture valueForKey:@"_id"]size:@200 callback:^(UIImage *responde) {
        self.pictureImage.image = responde;
        self.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.loadPictureIndicator stopAnimating];
        self.pictureImage.hidden = NO;
    }];
    
    self.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
    self.authorName.text = [self.author valueForKey:@"name"];
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[self.author valueForKey:@"thumbnail"] options:
                         NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [UIImage imageWithData:imageData];
    self.authorImage.image = img;
}

@end
