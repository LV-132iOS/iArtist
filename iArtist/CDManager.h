//
//  CDManager.h
//  TestingSN
//
//  Created by Admin on 06.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Security/Security.h> 
#import "SSKeychain.h"

@interface CDManager : NSObject

+(void) deleteAccountInfoFromCD;

+(void) deleteAccountInfoFromServer;

+(void) setServerTokenToKeychain:(NSString*) string;
+(void) deleteServerTokenFromKeychain;

@end
