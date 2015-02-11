//
//  ShareViewController.m
//  iArtist
//
//  Created by Vitalii Zamirko on 2/6/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ShareViewController.h"
#import "GooglePlusDelegate.h"

@interface ShareViewController (){
    GPPSignIn *signIn;
    GooglePlusDelegate* delegateG;
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

-(void)viewWillAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareWithFacebook:(id)sender {
    // Check if the Facebook app is installed and we can present the share dialog
    [self dismissViewControllerAnimated:YES completion:nil];
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = self.urlToPass;
    params.name = self.headString;
    params.linkDescription = @"I can choose a great art with iArtist!";
    params.picture = self.imageUrl;
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:nil
                                  description:params.linkDescription
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
            NSLog(@"%@", results);
        }];
    } else {
        //present feed dialog
        NSMutableDictionary *dictionaryParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       params.name, @"name",
                                       params.linkDescription, @"description",
                                       params.link.absoluteString, @"link",
                                       params.picture.absoluteString, @"picture",
                                       nil];
        
        
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:dictionaryParams
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
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

- (IBAction)shareWithTwitter:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.headString forKey:@"head"];
        [dic  setObject:self.urlToPass forKey:@"url"];
        [dic setObject:self.imageToShare forKey:@"image"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareWithTwitter" object:nil userInfo:dic];
    }];
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
        delegateG = [[GooglePlusDelegate alloc] init];
        signIn.delegate = delegateG;
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
    VKShareDialogController * shareDialog = [VKShareDialogController new]; 
    VKUploadImage* locImage = [VKUploadImage uploadImageWithImage:self.imageToShare
                                                        andParams:[VKImageParameters pngImage]];
    
    shareDialog.dismissAutomatically = YES;
    shareDialog.text = self.headString;
    shareDialog.uploadImages = @[locImage];
    shareDialog.shareLink = [[VKShareLink alloc] initWithTitle:@"Picture on the wall"
                                                          link:self.urlToPass];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self presentingViewController] presentViewController:shareDialog animated:YES completion:nil];
    
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

@end
