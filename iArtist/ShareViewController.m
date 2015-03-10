//
//  ShareViewController.m
//  iArtist
//
//  Created by Vitalii Zamirko on 2/6/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController (){
    GPPSignIn *signIn;
    MessageDelegate* mDelegate;
}

@end

static NSString * const kClientId = @"151071407108-tdf2fd0atjggs26i68tepgupb0501k8u.apps.googleusercontent.com";


@implementation ShareViewController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    mDelegate = [[MessageDelegate alloc] init];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    mDelegate = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareWithFacebook:(id)sender {
 /*
    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameFacebook];
    SNSocialNetwork* network = [fabric getSocialNetwork];
    [network askForSharingWithCompletionHandler:^{
        
        NSDictionary* dic = @{@"image": self.imageToShare,
                              @"text": self.headString,
                              @"url": self.urlToPass
                              };
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [network shareInfo:dic withViewController:[self presentingViewController] WithCompletionHandler:nil];
        
    }];
*/
   
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


- (IBAction)shareWithGooglePlus:(id)sender {
    
    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameGooglePlus];
    SNSocialNetwork* network = [fabric getSocialNetwork];
    [network askForSharingWithCompletionHandler:^{
        NSDictionary* dic = @{@"image": self.imageToShare,
                              @"text": self.headString,
                              @"url": self.urlToPass
                              };
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [network shareInfo:dic withViewController:[self presentingViewController] WithCompletionHandler:nil];
        
    }];
}

- (IBAction)shareWithVkontakte:(id)sender {

    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameVkontakte];
    SNSocialNetwork* network = [fabric getSocialNetwork];
    [network askForSharingWithCompletionHandler:^{
        NSDictionary* dic = @{@"image": self.imageToShare,
                              @"text": self.headString,
                              @"url": self.urlToPass
                              };
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [network shareInfo:dic withViewController:[self presentingViewController] WithCompletionHandler:nil];
        
    }];
}

- (IBAction)shareWithTwitter:(id)sender {
    
    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameTwitter];
    SNSocialNetwork* network = [fabric getSocialNetwork];
    [network askForSharingWithCompletionHandler:^{
        NSDictionary* dic = @{@"image": self.imageToShare,
                              @"text": self.headString,
                              @"url": self.urlToPass
                              };
        
        
        [network shareInfo:dic withViewController:[self presentingViewController] WithCompletionHandler:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }];
}

- (IBAction)shareWithEmail:(id)sender {
    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameEmail];
    SNSocialNetwork* network = [fabric getSocialNetwork];
    [network askForSharingWithCompletionHandler:^{
        NSDictionary* dic = @{@"image": self.imageToShare,
                              @"text": self.headString,
                              @"url": self.urlToPass
                              };
        
        
        [network shareInfo:dic withViewController:self WithCompletionHandler:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }];
}

- (IBAction)shareWithMessages:(id)sender {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device doesn't support SMS!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = mDelegate;
    [messageController setBody:self.headString];
   

    NSData *imageData = UIImageJPEGRepresentation(self.imageToShare, 1.0);
    
    [messageController addAttachmentData:imageData
                          typeIdentifier:@"image/jpeg"
                                filename:@"Art"];

    [self presentViewController:messageController animated:YES completion:nil];

}


@end
