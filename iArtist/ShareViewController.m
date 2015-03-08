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

}

@end

static NSString * const kClientId = @"151071407108-tdf2fd0atjggs26i68tepgupb0501k8u.apps.googleusercontent.com";


@implementation ShareViewController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoogleShare) name:@"GoogleShare" object:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareWithFacebook:(id)sender {
    // Check if the Facebook app is installed and we can present the share dialog
    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameFacebook];
    SNSocialNetwork* network = [fabric getSocialNetwork];
//    [network askForSharing];
//    
//    dispatch_queue_t q = dispatch_queue_create("lbl", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(q, ^{
//        while (network.isSharingGranted == NO) {
//            
//        }
    
        NSDictionary* dic = @{@"image": self.imageToShare,
                              @"text": self.headString,
                              @"url": self.urlToPass
                              };
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [network shareInfo:dic withViewController:[self presentingViewController]];
//    });

   
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
    signIn = [GPPSignIn sharedInstance];
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,
                     kGTLAuthScopePlusUserinfoEmail,
                     nil];
    signIn.attemptSSO = YES;
    if (signIn.delegate == nil) {
     //   delegateG = [[GooglePlusDelegate alloc] init];
      //  signIn.delegate = delegateG;
    }
    
    if ([signIn authentication]) {
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        [shareBuilder setPrefillText:self.headString];
        [shareBuilder attachImage:self.imageToShare];
        [shareBuilder open];
        
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You need to login first."
                                                        message:@"Do you want to log in?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}

- (IBAction)shareWithVkontakte:(id)sender {
//    VKShareDialogController * shareDialog = [VKShareDialogController new]; 
//    VKUploadImage* locImage = [VKUploadImage uploadImageWithImage:self.imageToShare
//                                                        andParams:[VKImageParameters pngImage]];
//    
//    shareDialog.dismissAutomatically = YES;
//    shareDialog.text = self.headString;
//    shareDialog.uploadImages = @[locImage];
//    shareDialog.shareLink = [[VKShareLink alloc] initWithTitle:@"Picture on the wall"
//                                                          link:self.urlToPass];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [[self presentingViewController] presentViewController:shareDialog animated:YES completion:nil];
    SNSocialNetworkFabric* fabric = [SNClient getFabricWithName:SNnameVkontakte];
    SNSocialNetwork* network = [fabric getSocialNetwork];
    [network askForSharing];
 
    dispatch_queue_t q = dispatch_queue_create("lbl", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(q, ^{
        while (network.isSharingGranted == NO) {
            
        }

        
        NSDictionary* dic = @{@"image": self.imageToShare,
                             @"text": self.headString,
                             @"url": self.urlToPass
                              };
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [network shareInfo:dic withViewController:[self presentingViewController]];
    });
    
    
}

#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"yes" forKey:@"flagForGoogleShare"];
        [signIn authenticate];
    }
}

-(void)GoogleShare {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    signIn = [GPPSignIn sharedInstance];
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,
                     kGTLAuthScopePlusUserinfoEmail,
                     nil];
    signIn.attemptSSO = YES;
            id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
            [shareBuilder setPrefillText:self.headString];
            [shareBuilder attachImage:self.imageToShare];
            [shareBuilder open];
        [defaults setObject:@"no" forKey:@"flagForGoogleShare"];
}

- (void)shareWithTwitter:(NSNotification*)notification {
    TWTRComposer* composer = [[TWTRComposer alloc] init];
    
    
    [composer setText:self.headString];
    [composer setImage:self.imageToShare];
    [composer setURL:self.urlToPass];
    
    [composer showWithCompletion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
}

+(void) setServerTokenToKeychain:(NSString*) string{
    
}

@end
