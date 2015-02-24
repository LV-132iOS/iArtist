//
//  FirstRunViewController.m
//  iArtist
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "FirstRunViewController.h"

@interface FirstRunViewController (){
    FirstRunCarouselDelegateAndDataSource* delegateAndDataSource;
}

@end

@implementation FirstRunViewController

@synthesize guideCarousel = _guideCarousel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.guideCarousel.type = iCarouselTypeRotary;
    delegateAndDataSource = [[FirstRunCarouselDelegateAndDataSource alloc] init];
    self.guideCarousel.dataSource = delegateAndDataSource;
    self.guideCarousel.delegate = delegateAndDataSource;
    self.guideCarousel.decelerationRate = 1.0f;
    self.guideCarousel.pagingEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)closeGuideButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)EmailSending:(id)sender {
    
    if ([MFMailComposeViewController canSendMail] == YES)
        
    {
        // Set up
        self.myMail = [[MFMailComposeViewController alloc] init];
        
        self.myMail.mailComposeDelegate = self;
        
        
        // Set the subject
        
        [self.myMail setSubject:@"My app feedback"];
        
        // To recipients
        
        NSArray *toResipients = [[NSArray alloc] initWithObjects:IAteamEmail, nil];
        
        [self.myMail setToRecipients:toResipients];
        
        // Add some text to message body
        
        NSString *sentFrom = @"Email sent from my app";
        
        [self.myMail setMessageBody:sentFrom
                             isHTML:YES];
        
        // Display the view controller
        
        [self presentViewController:self.myMail
                           animated:YES
                         completion:nil];
    }
    
    else
        
    {
        
        UIAlertView *errorAlter = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Your device can not send email"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
        
        [errorAlter show];
        
    }
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
                       
        case MFMailComposeResultSent:
        {
            
            UIAlertView *thanyouAlter = [[UIAlertView alloc] initWithTitle:@"Thank You"
                                                                   message:@"Thank you for your email"
                                                                  delegate:self cancelButtonTitle:@"OK"
                                                         otherButtonTitles: nil];
            
            [thanyouAlter show];
            
        }
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}

@end
