//
//  LoginViewController.h
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <TwitterKit/TwitterKit.h>
#import <GooglePlus/GooglePlus.h>

static NSString * const kClientId = @"151071407108-tdf2fd0atjggs26i68tepgupb0501k8u.apps.googleusercontent.com";

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet GPPSignInButton *signWithGoogle;
@property (weak, nonatomic) IBOutlet UIButton *signWithVkontakte;

@end
