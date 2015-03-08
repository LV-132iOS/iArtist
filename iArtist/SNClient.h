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
#import "SSKeychain.h"

static NSString* const SNnameFacebook = @"Facebook";
static NSString* const SNnameTwitter = @"Twitter";
static NSString* const SNnameVkontakte = @"Vkontakte";
static NSString* const SNnameGooglePlus = @"GooglePlus";

@interface SNClient : NSObject

+(SNSocialNetworkFabric*) getFabricWithName:(NSString*)SNname;
+(void) logInWithSocialNetwork:(SNSocialNetwork*)network;
+(void) signUpWithEmail:(SNSocialNetwork*)network;
+(void) logInWithEmail:(SNSocialNetwork*)network;
+(NSString*) getServerTokenFromKeychain;

@end
