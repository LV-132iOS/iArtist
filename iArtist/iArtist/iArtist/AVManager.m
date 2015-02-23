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

- (void)wallArrayInit{
    AVWall *wall1 = [AVWall new];
    wall1.wallPicture = [UIImage imageNamed:@"room1.jpg"];
    wall1.distanceToWall = @1;
    AVWall *wall2 = [AVWall new];
    wall2.wallPicture = [UIImage imageNamed:@"room2.jpg"];
    wall2.distanceToWall = @6;
    AVWall *wall3 = [AVWall new];
    wall3.wallPicture = [UIImage imageNamed:@"room3.jpg"];
    wall3.distanceToWall = @1;
    AVWall *wall4 = [AVWall new];
    wall4.wallPicture = [UIImage imageNamed:@"room4.jpg"];
    wall4.distanceToWall = @3;
    AVWall *wall5 = [AVWall new];
    wall5.wallPicture = [UIImage imageNamed:@"room5.jpg"];
    wall5.distanceToWall = @2;
    AVWall *wall6 = [AVWall new];
    wall6.wallPicture = [UIImage imageNamed:@"room6.jpg"];
    wall6.distanceToWall = @4;
    AVWall *wall7 = [AVWall new];
    wall7.wallPicture = [UIImage imageNamed:@"room7.jpg"];
    wall7.distanceToWall = @1;
    AVWall *wall8 = [AVWall new];
    wall8.wallPicture = [UIImage imageNamed:@"room8.jpg"];
    wall8.distanceToWall = @2;
    AVWall *wall9 = [AVWall new];
    wall9.wallPicture = [UIImage imageNamed:@"room9.jpg"];
    wall9.distanceToWall = @8;
    self.wallArray = [NSMutableArray arrayWithObjects:wall1, wall2, wall3, wall4, wall5, wall6, wall7, wall8, wall9, nil];
}


@end
