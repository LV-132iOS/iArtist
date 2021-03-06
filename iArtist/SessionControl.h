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
-(BOOL)checkInternetConnection;
-(NSString*)checkSession:(NSString*)sessionName;
-(NSString*)currentSocialNetwork;
-(void)refresh;
-(void)reset;

+(id)sharedManager;

@end
