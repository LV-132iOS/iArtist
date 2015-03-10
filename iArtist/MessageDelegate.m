//
//  MessageDelegate.m
//  iArtist
//
//  Created by Vitalii Zamirko on 3/10/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "MessageDelegate.h"

@implementation MessageDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                   message:@"Failed to send SMS!"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
            [alert show];
            break;
        }
            
        case MessageComposeResultSent:
        {   if (self.block != nil) self.block();
            break;
        }
            
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
