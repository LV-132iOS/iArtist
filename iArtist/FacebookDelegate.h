//
//  FacebookDelegate.h
//  iArtist
//
//  Created by Admin on 01.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookDelegate : NSObject <FBLoginViewDelegate>

@end


/*
 // play with Twitter session
 if (!error) {
 //write user info to user defaults
 NSString*  localString = @"unavailable";
 [defaults setObject:session.userName forKey:@"username"];
 [defaults setObject:localString forKey:@"useremail"];
 //creating unique user id and write it to user defaults
 localString = @"tw";
 localString = [localString stringByAppendingString:session.userID];
 [defaults setObject:localString forKey:@"id"];
 [defaults synchronize];
 //if logged in successfully - then send info to server
 NSDictionary* info = @{ @"with": @"Twitter" };
 [[NSNotificationCenter defaultCenter] postNotificationName:@"SendInfo" object:nil userInfo:info];
 } else {
 //something went wrong with twitter log in, log error and do nothing
 NSLog(@"error: %@", [error localizedDescription]);
 }
*/