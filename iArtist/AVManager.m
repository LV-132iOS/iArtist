//
//  AVManager.m
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 29.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import "AVManager.h"

@implementation AVManager


+( AVManager *) sharedInstance{
    
    static AVManager* singleton = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        singleton = [self new];
    } );

    return singleton;
}


@end
