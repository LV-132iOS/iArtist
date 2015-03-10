//
//  SNSocialNetwork.h
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSocialNetworkDelegate.h"
#import "CDManager.h"

@class SNSocialNetworkDelegate;

@interface SNSocialNetwork : NSObject

//basic info

@property(nonatomic, strong) NSString *socialName;
@property(nonatomic,strong) SNSocialNetworkDelegate *delegate;
@property(nonatomic,strong) NSArray *permissions;
@property(nonatomic,strong) NSString *clientID;
@property(nonatomic, strong) NSString *clientSecret;
@property(nonatomic,strong) NSString *basicToken;
@property(nonatomic, strong) NSString *serverToken;
@property(nonatomic, assign) BOOL isLoggedIn;
@property(nonatomic,assign) BOOL isMainAuth;
@property(nonatomic,assign) BOOL isNotMainAuth;
@property(nonatomic,assign) BOOL isSharingGranted;

//when logged in

@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *userid;
@property(nonatomic, strong) NSString *useremail;



//class methods

+(id) sharedManager;

//general methods

-(void) logInWithCompletionHandler:(void(^)())handler;
-(void) logOutWithCompletionHandler:(void(^)())handler;
-(void) deleteAccountWithCompletionHandler:(void(^)())handler;
-(void) askForSharingWithCompletionHandler:(void(^)())handler;
-(void) shareInfo:(NSDictionary*)info withViewController:(UIViewController*)controller WithCompletionHandler:(void(^)())handler;



@end
