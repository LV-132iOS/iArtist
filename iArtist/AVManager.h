//
//  AVManager.h
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 29.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sesion.h"
#import "Wall.h"

@interface AVManager : NSObject

@property (strong, nonatomic) Sesion * session;

@property (nonatomic) NSInteger index;

@property (strong, nonatomic) Wall *wallImage;

@property (strong, nonatomic) NSMutableArray *wallArray;

@property (strong, nonatomic) NSArray *arrayOfUrlPicture;

+(AVManager *) sharedInstance;

- (void)wallArrayInit;

@end
