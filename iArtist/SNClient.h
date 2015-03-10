//
//  SNClient.h
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSocialNetworkFabric.h"
#import "SNFacebookFabric.h"
#import "SNTwitterFabric.h"
#import "SNGooglePlusFabric.h"
#import "SNVkontakteFabric.h"
#import "SNEmailFabric.h"
#import "SSKeychain.h"
#import "ServerFetcher.h"

static NSString* const SNnameFacebook = @"Facebook";
static NSString* const SNnameTwitter = @"Twitter";
static NSString* const SNnameVkontakte = @"Vkontakte";
static NSString* const SNnameGooglePlus = @"GooglePlus";
static NSString* const SNnameEmail = @"Email";

@interface SNClient : NSObject

+(SNSocialNetworkFabric*) getFabricWithName:(NSString*)SNname;
+(void) logInWithSocialNetwork:(SNSocialNetwork*)network WithCompletionHandler:(void(^)())handler;
+(void) signUpWithEmail:(SNSocialNetwork*)network WithCompletionHandler:(void(^)())handler;
+(void) logInWithEmail:(SNSocialNetwork*)network WithCompletionHandler:(void(^)())handler;
+(void) logoutWithSN:(SNSocialNetwork*)network WithCompletionHandler:(void(^)())handler;
+(void) deleteSNAccount:(SNSocialNetwork*)network WithCompletionHandler:(void(^)())handler;
+(NSString*) getServerTokenFromKeychain;

@end