//
//  BuyCartViewController.h
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface BuyCartViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *cartTableView;
@property(strong, nonatomic) MFMailComposeViewController *myMail;

@end
