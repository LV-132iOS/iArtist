//
//  SessionControl.h
//  iArtist
//
//  Created by Vitalii Zamirko on 2/8/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionControl : NSObject{
}

-(void)beginNotify;
-(BOOL)checkInternetConnectionWithHandler:(void(^)())handler;
-(NSString*)checkSession:(NSString*)sessionName;
-(NSString*)currentSocialNetwork;
-(void)refreshWithCompletionHandler:(void(^)())handler;
-(void)reset;

+(id)sharedManager;

typedef void (^compBlock)();


@end
