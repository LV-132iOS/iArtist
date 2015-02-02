//
//  AVSession.h
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 27.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVPicture.h"

@interface AVSession : NSObject

@property (strong, nonatomic) NSString *sessionName;
@property (strong, nonatomic) NSArray *arrayOfPictures;

+ (AVSession *) sessionInit;

@end
