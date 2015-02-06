//
//  AVSession.m
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 27.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import "AVSession.h"

@implementation AVSession

+ (AVSession *) sessionInit{
    AVSession *newSession = [AVSession new];
    
    AVAuthor *author1 = [AVAuthor new];
    AVAuthor *author2 = [AVAuthor new];
    
    AVPicture *picture1 = [AVPicture new];
    picture1.pictureImage = [UIImage imageNamed:@"picture1.jpg"];
    picture1.pictureAuthor = author1;
    picture1.prise = 100;
    picture1.pictureName = @"picture1.jpg";
    picture1.pictureSize = (CGSize){.width = picture1.pictureImage.size.width, .height = picture1.pictureImage.size.height};
    picture1.numberOfLiked = 10;
    AVPicture *picture2 = [AVPicture new];
    picture2.pictureImage = [UIImage imageNamed:@"picture2.jpg"];
    picture2.pictureAuthor = author2;
    picture2.prise = 200;
    picture2.numberOfLiked = 20;
    picture2.pictureName = @"picture2.jpg";
    picture2.pictureSize = picture2.pictureImage.size;
    AVPicture *picture3 = [AVPicture new];
    picture3.pictureImage = [UIImage imageNamed:@"picture3.jpg"];
    picture3.pictureAuthor = author1;
    picture3.prise = 300;
    picture3.numberOfLiked = 30;
    picture3.pictureName = @"picture3.jpg";
    picture3.pictureSize = picture3.pictureImage.size;
    AVPicture *picture4 = [AVPicture new];
    picture4.pictureImage = [UIImage imageNamed:@"picture4.jpg"];
    picture4.pictureAuthor = author2;
    picture4.prise = 50;
    picture4.numberOfLiked = 40;
    picture4.pictureName = @"picture4.jpg";
    picture4.pictureSize = picture4.pictureImage.size;
    AVPicture *picture5 = [AVPicture new];
    picture5.pictureImage = [UIImage imageNamed:@"picture5.jpg"];
    picture5.pictureAuthor = author1;
    picture5.prise = 150;
    picture5.numberOfLiked = 50;
    picture5.pictureName = @"picture5.jpg";
    picture5.pictureSize = picture5.pictureImage.size;
    AVPicture *picture6 = [AVPicture new];
    picture6.pictureImage = [UIImage imageNamed:@"picture6.jpg"];
    picture6.pictureAuthor = author1;
    picture6.prise = 120;
    picture6.numberOfLiked = 60;
    picture6.pictureName = @"picture6.jpg";
    picture6.pictureSize = picture6.pictureImage.size;
    AVPicture *picture7 = [AVPicture new];
    picture7.pictureImage = [UIImage imageNamed:@"picture7.jpg"];
    picture7.pictureAuthor = author2;
    picture7.prise = 250;
    picture7.numberOfLiked = 100;
    picture7.pictureName = @"picture7.jpg";
    picture7.pictureSize = picture7.pictureImage.size;
    AVPicture *picture8 = [AVPicture new];
    picture8.pictureImage = [UIImage imageNamed:@"picture8.jpg"];
    picture8.pictureAuthor = author2;
    picture8.prise = 90;
    picture8.numberOfLiked = 70;
    picture8.pictureName = @"picture8.jpg";
    picture8.pictureSize = picture8.pictureImage.size;
    AVPicture *picture9 = [AVPicture new];
    picture9.pictureImage = [UIImage imageNamed:@"picture9.jpg"];
    picture9.pictureAuthor = author1;
    picture9.prise = 10;
    picture9.numberOfLiked = 80;
    picture9.pictureName = @"picture9.jpg";
    picture9.pictureSize = picture9.pictureImage.size;
    
    author1.authorsPhoto = [UIImage imageNamed:@"person.png"];
    author1.authorsName = @"Painter ONE";
    author1.pictures = @[picture1, picture3, picture5, picture6, picture9];
    author1.authorsType = @"Modern";
    
    author2.authorsPhoto = [UIImage imageNamed:@"person.png"];
    author2.authorsName = @"Painter Second";
    author2.pictures = @[picture2, picture4, picture7, picture8];
    author2.authorsType = @"Old style";
    
    newSession.arrayOfPictures = @[picture1, picture2, picture3, picture4, picture5, picture6, picture7, picture8, picture9];
    newSession.sessionName = @"Session one";
    
    return newSession;
}

@end
