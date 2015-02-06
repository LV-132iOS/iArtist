//
//  AVPicture.h
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 15.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AVAuthor.h"

@interface AVPicture : NSObject

@property (strong, nonatomic) NSString *pictureName;

@property (strong, nonatomic) UIImage *pictureImage;

@property (strong, nonatomic) AVAuthor *pictureAuthor;

@property (nonatomic) CGSize pictureSize;

@property (nonatomic) NSInteger prise;

@property (nonatomic) NSInteger numberOfLiked;

@end
