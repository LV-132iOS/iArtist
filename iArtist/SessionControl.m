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
#import "SNClient.h"
@interface SessionControl(){
    Reachability *Reachable;
    BOOL isOK;
    BOOL isOKSocial;
    NSString* currentSocial;
    // = ^void() {};
}

@end




@implementation SessionControl
//method to get object form anywhere
+(id)sharedManager {
    static SessionControl *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    [sharedMyManager refreshWithCompletionHandler:nil];
    return sharedMyManager;
}
//initing singleton
- (id)init {
    if (self = [super init]) {
        isOK = NO;
        isOKSocial = NO;
        currentSocial = @"none";
        Reachable = [Reachability reachabilityWithHostname:@"ec2-54-93-36-107.eu-central-1.compute.amazonaws.com"];
        //     self.blockName = ^void() { NSLog(@"basic");};
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
-(BOOL)checkInternetConnectionWithHandler:(void(^)())handler{
    NSDictionary* dict;
    if ([Reachable isReachable]) {
        dict = @{ @"OK" : @"1" };
    } else dict = @{ @"OK" : @"0" };
    [self updateSessionInfo:dict AndHandler:handler];
    return [Reachable isReachable];
    
}
//check if social network session is active
-(NSString*)checkSession:(NSString *)sessionName {
    if ([currentSocial isEqualToString:sessionName]) {
        return isOKSocial? @"yes" : @"no";
    } else return @"nil";
}
//update info
-(void)updateSessionInfo:(NSDictionary*)dict AndHandler:(void(^)())handler {
    NSString* locString = [dict objectForKey:@"OK"];
    if ([locString isEqualToString:@"1"]) {
        isOK = YES;
        NSLog(@"Server OK");
    } else {
        isOK = NO;
        NSLog(@"Server not OK");
    }
    if (handler != nil)
        handler();
}

-(void)updateSocialNetworkSessionInfoWithInfo:(NSDictionary*)dictionary AndHandler:(void(^)())handler {
    NSString* locString = [dictionary objectForKey:@"OK"];
    currentSocial = [dictionary objectForKey:@"social"];
    if ([locString isEqualToString:@"1"]) {
        isOKSocial = YES;
        NSLog(@"social ok");
    } else {
        isOKSocial = NO;
        NSLog(@"social not ok");
    }
    if (handler != nil)
        handler();
}

-(NSString*)currentSocialNetwork {
    return currentSocial;
}

-(void)refreshWithCompletionHandler:(void (^)())handler{
    [self checkInternetConnectionWithHandler:nil];
    NSString* sn = [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedInWith"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if ([sn isEqualToString:@"Facebook"]) {
            SNSocialNetworkFabric *fabric = [SNClient getFabricWithName:SNnameFacebook];
            SNSocialNetwork *network = [fabric getSocialNetwork];
            NSLog(@"previously logged in with %@", network.socialName);
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
                //            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSocialNetworkSessionInfo"
                //                                                                object:nil
                //                                                              userInfo:locDictionary];
                
                [self updateSocialNetworkSessionInfoWithInfo:locDictionary AndHandler:handler];
                
            }];
        } else
            if ([sn isEqualToString:@"Twitter"]){
                  SNSocialNetworkFabric *fabric = [SNClient getFabricWithName:SNnameTwitter];
                  SNSocialNetwork *network = [fabric getSocialNetwork];
                NSLog(@"previously logged in with %@", network.socialName);
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
                                                              //            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSocialNetworkSessionInfo"
                                                              //                                                                object:nil
                                                              //                                                              userInfo:locDictionary];
                                                              
                                                              [self updateSocialNetworkSessionInfoWithInfo:locDictionary AndHandler:handler];
                                                          }];
            } else
                if ([sn isEqualToString:@"GooglePlus"]){
                    //check if session is valid be sending a request that needs authorization
                    SNSocialNetworkFabric *fabric = [SNClient getFabricWithName:SNnameGooglePlus];
                    SNSocialNetwork *network = [fabric getSocialNetwork];
                    NSLog(@"previously logged in with %@", network.socialName);
                    GPPSignIn *signIn = [GPPSignIn sharedInstance];
                    NSLog(@"%hhd", [signIn hasAuthInKeychain]);
                    network.delegate.block = nil;
                    [signIn trySilentAuthentication];
                    
                    if (signIn.authentication == nil) {
                        NSDictionary* locDictionary = @{ @"OK" : @"0",
                                           @"social" : @"Google"};
                         [self updateSocialNetworkSessionInfoWithInfo:locDictionary AndHandler:handler];
                    } else {
                        
                        
                    GTLServicePlus* plusService = [signIn plusService];
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
                                //            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSocialNetworkSessionInfo"
                                //                                                                object:nil
                                //                                                              userInfo:locDictionary];
                                
                                [self updateSocialNetworkSessionInfoWithInfo:locDictionary AndHandler:handler];
                            }];
                    }
                } else
                    if ([sn isEqualToString:@"Vkontakte"]){
                        
                        SNSocialNetworkFabric *fabric = [SNClient getFabricWithName:SNnameVkontakte];
                        SNSocialNetwork *network = [fabric getSocialNetwork];
                        NSLog(@"previously logged in with %@", network.socialName);
                        
                        VKRequest * audioReq = [[VKApi users] get];
                        [audioReq executeWithResultBlock:^(VKResponse * response) {
                            NSDictionary* locDictionary;
                            locDictionary = @{ @"OK" : @"1",
                                               @"social" : @"Vkontakte"};
                            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSocialNetworkSessionInfo"
                            //                                                                object:nil
                            //                                                              userInfo:locDictionary];
                            
                            [self updateSocialNetworkSessionInfoWithInfo:locDictionary AndHandler:handler];
                            
                        } errorBlock:^(NSError * error) {
                            NSDictionary* locDictionary;
                            locDictionary = @{ @"OK" : @"0",
                                               @"social" : @"Vkontakte"};
                            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSocialNetworkSessionInfo"
                            //                                                                object:nil
                            //                                                              userInfo:locDictionary];
                            
                            [self updateSocialNetworkSessionInfoWithInfo:locDictionary AndHandler:handler];
                        }];
                    }
                    else
                        if ([sn isEqualToString:@"Email"]){
                            NSDictionary* locDictionary;
                            locDictionary = @{ @"OK" : @"1",
                                               @"social" : @"Email"};
                            [self updateSocialNetworkSessionInfoWithInfo:locDictionary AndHandler:handler];
                        }
                        else {
                            NSDictionary* locDictionary;
                            locDictionary = @{ @"OK" : @"0",
                                               @"social" : @"none"};
                            [self updateSocialNetworkSessionInfoWithInfo:locDictionary AndHandler:handler];
                        }
    });
  
}


-(void)reset{
    isOK = NO;
    isOKSocial = NO;
    currentSocial = @"none";
}

@end

