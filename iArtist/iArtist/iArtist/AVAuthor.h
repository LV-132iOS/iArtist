//
//  AVAuthor.h
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 15.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AVAuthor : NSObject

@property (strong, nonatomic) NSArray *pictures;

@property (strong, nonatomic) UIImage *authorsPhoto;

@property (strong, nonatomic) NSString *authorsName;

@property (strong, nonatomic) UIView *authorsDescriptions;

@property (strong, nonatomic) NSString *authorsType;

@end
