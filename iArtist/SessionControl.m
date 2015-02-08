//
//  SessionControl.m
//  iArtist
//
//  Created by Vitalii Zamirko on 2/8/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SessionControl.h"
#import "Reachability.h"
@interface SessionControl(){
    Reachability *Reachable;
}

@end

@implementation SessionControl

-(void)beginNotify{
    Reachable = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    Reachable.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Server OK");
        });
    };
    
    // Internet is not reachable
    Reachable.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Server not OK");
        });
    };
    
    [Reachable startNotifier];
}

-(BOOL)checkInternetConnection{
    return [Reachable isReachable];
}

@end
