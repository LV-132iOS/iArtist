//
//  Picture.h
//  iArtist
//
//  Created by Clark on 3/10/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist;

@interface Picture : NSManagedObject

@property (nonatomic, retain) NSString * descript;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * id_;
@property (nonatomic, retain) NSString * materials;
@property (nonatomic, retain) NSString * orginURL;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * realsize;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Artist *owner;

@end
