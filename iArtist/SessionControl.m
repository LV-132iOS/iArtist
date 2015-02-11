//
//  SessionControl.m
//  iArtist
//
//  Created by Vitalii Zamirko on 2/8/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SessionControl.h"
#import "Reachability.h"
#import <FacebookSDK/FacebookSDK.h>
#import <VKSdk/VKSdk.h>
#import <TwitterKit/TwitterKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
@interface SessionControl(){
    Reachability *Reachable;
    BOOL isOK;
    BOOL isOKSocial;
    NSString* currentSocial;
}

@end




@implementation SessionControl
//method to get object form anywhere
+(id)sharedManager {
    static SessionControl *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedMyManager
                                                 selector:@selector(updateSessionInfo:)
                                                     name:@"UpdateSessionInfo"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedMyManager
                                                 selector:@selector(updateSocialNetworkSessionInfo:)
                                                     name:@"UpdateSocialNetworkSessionInfo"
                                                   object:nil];
    });
    [sharedMyManager refresh];
    return sharedMyManager;
}
//initing singleton
- (id)init {
    if (self = [super init]) {
        isOK = NO;
        isOKSocial = NO;
        currentSocial = @"none";
        Reachable = [Reachability reachabilityWithHostname:@"ec2-54-93-36-107.eu-central-1.compute.amazonaws.com:8080/"];
        // Internet is reachable
        Reachable.reachableBlock = ^(Reachability*reach)
        {
            // Update the UI on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Server OK");
                NSDictionary* locDic  = @{ @"OK" : @"1" };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSessionInfo" object:nil userInfo:locDic];
            });
        };
        
        // Internet is not reachable
        Reachable.unreachableBlock = ^(Reachability*reach)
        {
            // Update the UI on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Server not OK");
                NSDictionary* locDic  = @{ @"OK" : @"0" };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSessionInfo" object:nil userInfo:locDic];
                NSDictionary* locDictionary;
                locDictionary = @{ @"OK" : @"0" };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSocialNetworkSessionInfo"
                                                                    object:nil
                                                                  userInfo:locDictionary];
            });
        };
    }
    return self;
}
//begin notify
-(void)beginNotify{
    [Reachable startNotifier];
}
//end notify
-(void)endNotify {
    [Reachable stopNotifier];
}
//check if our server is available
-(BOOL)checkInternetConnection{
    return [Reachable isReachable];
}
//check if social network session is active
-(NSString*)checkSession:(NSString *)sessionName {
    if ([currentSocial isEqualToString:sessionName]) {
        return isOKSocial? @"yes" : @"no";
    } else return @"nil";
}
//update info
-(void)updateSessionInfo:(NSNotification*)notification {
    NSString* locString = [notification.userInfo objectForKey:@"OK"];
    if ([locString isEqualToString:@"1"]) {
        isOK = YES;
    } else {
        isOK = NO;
    }
}

-(void)updateSocialNetworkSessionInfo:(NSNotification*)notification {
    NSString* locString = [notification.userInfo objectForKey:@"OK"];
    currentSocial = [notification.userInfo objectForKey:@"social"];
    if ([locString isEqualToString:@"1"]) {
        isOKSocial = YES;
    } else {
        isOKSocial = NO;
    }
}

-(NSString*)currentSocialNetwork {
    return currentSocial;
}

-(void)refresh{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"loggedInWithFacebook"]) {
        
        FBSession* session = [FBSession activeSession];
        
        [session refreshPermissionsWithCompletionHandler:^(FBSession *session, NSError *error) {
            NSDictionary* locDictionary;
            if (error) {
                locDictionary = @{ @"OK" : @"0",
                                   @"social" : @"Facebook" };
                
            } else{
                locDictionary = @{ @"OK" : @"1",
                                   @"social" : @"Facebook" };
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSocialNetworkSessionInfo"
                                                                object:nil
                                                              userInfo:locDictionary];
        }];
    }
    if ([defaults boolForKey:@"loggedInWithTwitter"]){
        //there is no simple way to check if session is active, so I need to send smth to Twitter to get some response
        [[[Twitter sharedInstance] APIClient] loadUserWithID:[[Twitter sharedInstance] session].userID
                                                  completion:^(TWTRUser *user, NSError *error) {
                                                      NSDictionary* locDictionary;
                                                      if (error) {
                                                          locDictionary = @{ @"OK" : @"0",
                                                                             @"social" : @"Twitter"};
                                                      } else{
                                                          locDictionary = @{ @"OK" : @"1",
                                                                             @"social" : @"Twitter"};
                                                      }
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSocialNetworkSessionInfo"
                                                                                                          object:nil
                                                                                                        userInfo:locDictionary];
                                                  }];
    }
    if ([defaults boolForKey:@"loggedInWithGoogle"]){
        //check if session is valid be sending a request that needs authorization
        
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
        plusService.retryEnabled = YES;
        [plusService setAuthorizer: signIn.authentication];
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    NSDictionary* locDictionary;
                    if (error) {
                        locDictionary = @{ @"OK" : @"0",
                                           @"social" : @"Google"};
                        
                    } else {
                        locDictionary = @{ @"OK" : @"1",
                                           @"social" : @"Google"};
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSocialNetworkSessionInfo"
                                                                        object:nil
                                                                      userInfo:locDictionary];
                }];
    }
    if ([defaults boolForKey:@"loggedInWithVkontakte"]){
        [VKSdk wakeUpSession];
        VKRequest * audioReq = [[VKApi users] get];
        [audioReq executeWithResultBlock:^(VKResponse * response) {
            NSDictionary* locDictionary;
            locDictionary = @{ @"OK" : @"1",
                               @"social" : @"Vkontakte"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSocialNetworkSessionInfo"
                                                                object:nil
                                                              userInfo:locDictionary];
            
        } errorBlock:^(NSError * error) {
            NSDictionary* locDictionary;
            locDictionary = @{ @"OK" : @"0",
                               @"social" : @"Vkontakte"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSocialNetworkSessionInfo"
                                                                object:nil
                                                              userInfo:locDictionary];
        }];
    }
}

@end

