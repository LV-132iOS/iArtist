//
//  AVManager.h
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 29.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVSession.h"
#import "AVWall.h"

@interface AVManager : NSObject

@property (strong, nonatomic) AVSession * session;

@property (nonatomic) NSInteger index;

@property (strong, nonatomic) UIImage *wallImage;

@property (strong, nonatomic) NSMutableArray *wallArray;

@property (strong, nonatomic) NSArray *arrayOfUrlPicture;

+(AVManager *) sharedInstance;

- (void)wallArrayInit;

@end
