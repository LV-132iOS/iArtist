//
//  AVCartCell.h
//  iArtist
//
//  Created by Andrii V. on 04.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CartTableViewCell : UITableViewCell <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *artistName;

@property (strong, nonatomic) IBOutlet UILabel *pictureName;

@property (strong, nonatomic) IBOutlet UILabel *picturePrise;

@property (strong, nonatomic) IBOutlet UIButton *removeButton;

@property (strong, nonatomic) IBOutlet UIButton *sendAMailButton;

@property (strong, nonatomic) IBOutlet UIImageView *pictureImage;

@property (strong, nonatomic) IBOutlet UILabel *addedDate;

@property(strong, nonatomic) MFMailComposeViewController *myMail;

@end
