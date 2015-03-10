//
//  SNEmailSocialNetwork.m
//  iArtist
//
//  Created by Vitalii Zamirko on 3/7/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNEmailSocialNetwork.h"
#import "SessionControl.h"

@implementation SNEmailSocialNetwork

+(id) sharedManager {
    static SNEmailSocialNetwork *sharedMyManager = nil;
    static SNEmailDelegate *delegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        delegate = [[SNEmailDelegate alloc] init];
        sharedMyManager.delegate = delegate;
        delegate.network = sharedMyManager;
        delegate.network.socialName = @"Email";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        sharedMyManager.userid = [defaults objectForKey:@"userid"];
        sharedMyManager.username = [defaults objectForKey:@"username"];
        sharedMyManager.useremail = [defaults objectForKey:@"useremail"];
    });
    
    return sharedMyManager;
}

//general methods

-(void) logInWithCompletionHandler:(void (^)())handler {
    self.isMainAuth = YES;
    handler();
}

-(void) logOutWithCompletionHandler:(void (^)())handler {
    [CDManager deleteAccountInfoFromCD];
    SessionControl* control = [SessionControl sharedManager];
    [control reset];
    handler();
}

-(void) deleteAccount {
    [CDManager deleteAccountInfoFromServerWithCompletionHandler:nil];
    
}

-(void) askForSharingWithCompletionHandler:(void (^)())handler {
    handler();
}

-(void) shareInfo:(NSDictionary*)info withViewController:(UIViewController*)controller WithCompletionHandler:(void (^)())handler {
    if ([MFMailComposeViewController canSendMail] == YES)
        
    {
        // Set up
        self.delegate.block = handler;
        self.myMail = [[MFMailComposeViewController alloc] init];
        self.myMail.mailComposeDelegate = (SNEmailDelegate*) self.delegate;
        // Set the subject
        [self.myMail setSubject:@"Look what a great thing I want you to look at"];
        // To recipients
        [self.myMail setToRecipients:nil];
        // Include an attachment
        NSData *imageData = UIImagePNGRepresentation([info valueForKey:@"image"]);
        [self.myMail addAttachmentData:imageData
                              mimeType:@"image/png"
                              fileName:@"tag"];
        

        
        [self.myMail setMessageBody:[info valueForKey:@"text"]
                             isHTML:YES];
        
        // Display the view controller
        
        [controller presentViewController:self.myMail
                           animated:YES
                         completion:nil];
    }
    
    else
        
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Something bad with your e-mail options"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
        
        [alert show];
    }
}


@end
