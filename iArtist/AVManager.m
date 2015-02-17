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
    wall2.wallPicture = [UIImage imageNamed:@"room10.jpg"];
    wall2.distanceToWall = @2;
    AVWall *wall3 = [AVWall new];
    wall3.wallPicture = [UIImage imageNamed:@"room3.jpg"];
    wall3.distanceToWall = @1;
    AVWall *wall4 = [AVWall new];
    wall4.wallPicture = [UIImage imageNamed:@"room11.jpg"];
    wall4.distanceToWall = @1.5;
    AVWall *wall5 = [AVWall new];
    wall5.wallPicture = [UIImage imageNamed:@"room5.jpg"];
    wall5.distanceToWall = @2;
    AVWall *wall6 = [AVWall new];
    wall6.wallPicture = [UIImage imageNamed:@"room12.jpg"];
    wall6.distanceToWall = @3;
    AVWall *wall7 = [AVWall new];
    wall7.wallPicture = [UIImage imageNamed:@"room13.jpg"];
    wall7.distanceToWall = @2.5;
    AVWall *wall8 = [AVWall new];
    wall8.wallPicture = [UIImage imageNamed:@"room8.jpg"];
    wall8.distanceToWall = @2;
    AVWall *wall9 = [AVWall new];
    wall9.wallPicture = [UIImage imageNamed:@"room17.jpg"];
    wall9.distanceToWall = @2;
    AVWall *wall10 = [AVWall new];
    wall10.wallPicture = [UIImage imageNamed:@"room18.jpg"];
    wall10.distanceToWall = @2;
    AVWall *wall12 = [AVWall new];
    wall12.wallPicture = [UIImage imageNamed:@"room23.jpg"];
    wall12.distanceToWall = @2;
    AVWall *wall13 = [AVWall new];
    wall13.wallPicture = [UIImage imageNamed:@"room24.jpg"];
    wall13.distanceToWall = @3;
    AVWall *wall14 = [AVWall new];
    wall14.wallPicture = [UIImage imageNamed:@"room25.jpg"];
    wall14.distanceToWall = @3.5;
    AVWall *wall15 = [AVWall new];
    wall15.wallPicture = [UIImage imageNamed:@"room26.jpg"];
    wall15.distanceToWall = @1.5;
    AVWall *wall16 = [AVWall new];
    wall16.wallPicture = [UIImage imageNamed:@"room27.jpg"];
    wall16.distanceToWall = @1.5;
    AVWall *wall17 = [AVWall new];
    wall17.wallPicture = [UIImage imageNamed:@"room28.jpg"];
    wall17.distanceToWall = @2.5;
    AVWall *wall18 = [AVWall new];
    wall18.wallPicture = [UIImage imageNamed:@"room29.jpg"];
    wall18.distanceToWall = @2;
    
    self.wallArray = [NSMutableArray arrayWithObjects:wall1, wall2, wall3, wall4, wall5, wall6, wall7, wall8, wall9,
                      wall10, wall12, wall13, wall14, wall15, wall16, wall17, wall18 ,nil];
}


@end
