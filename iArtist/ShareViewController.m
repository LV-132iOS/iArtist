//
//  ShareViewController.m
//  iArtist
//
//  Created by Vitalii Zamirko on 2/6/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "ShareViewController.h"
#import <GoogleOpenSource/GTLPlusConstants.h>
#import "GooglePlusDelegate.h"

static NSString * const kClientId = @"151071407108-tdf2fd0atjggs26i68tepgupb0501k8u.apps.googleusercontent.com";


@interface ShareViewController (){
    GooglePlusDelegate* GDelegate;
}

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareWithTwitter"
                                                                    object:nil];
    }];
}

- (IBAction)shareWithGooglePlus:(id)sender {
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,
                     kGTLAuthScopePlusUserinfoEmail,
                     nil];
    signIn.attemptSSO = YES;
    
    [signIn trySilentAuthentication];

    if ([signIn authentication]) {
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        [shareBuilder setPrefillText:@"Achievement unlocked! I just scored 99 points. Can you beat me?"];
        [shareBuilder attachImage:self.imageToShare];
        [shareBuilder open];
    } else {
        [signIn authenticate];
    }
    

    
    
}

- (IBAction)shareWithVkontakte:(id)sender {
    VKShareDialogController * shareDialog = [VKShareDialogController new]; //1
    VKUploadImage* locImage = [VKUploadImage uploadImageWithImage:self.imageToShare
                                                        andParams:[VKImageParameters pngImage]];
    
    shareDialog.dismissAutomatically = YES;
    shareDialog.text = self.headString; //2
    shareDialog.uploadImages = @[locImage]; //3
    shareDialog.shareLink = [[VKShareLink alloc] initWithTitle:@"Picture on the wall"
                                                          link:self.urlToPass]; //4
//    [shareDialog setCompletionHandler:^(VKShareDialogControllerResult result) {
//        [[self presentedViewController] dismissViewControllerAnimated:YES completion:nil];
//    }]; //5
//    [self presentViewController:shareDialog animated:YES completion:nil]; //6
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self presentingViewController] presentViewController:shareDialog animated:YES completion:nil];
    
}

@end
