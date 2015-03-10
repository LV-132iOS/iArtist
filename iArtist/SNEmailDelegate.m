//
//  SNEmailDelegate.m
//  iArtist
//
//  Created by Vitalii Zamirko on 3/7/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNEmailDelegate.h"

@implementation SNEmailDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"Succeed"
                                                                   message:@"Succesfully sent"
                                                                  delegate:self cancelButtonTitle:@"OK"
                                                         otherButtonTitles: nil];
            
            [alter show];
            self.block();
        }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
