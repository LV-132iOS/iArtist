//
//  Picture.h
//  DArt
//
//  Created by Clark on 2/6/15.
//  Copyright (c) 2015 System Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist;

@interface Picture : NSManagedObject

@property (nonatomic, retain) NSString * descript;
@property (nonatomic, retain) NSString * id_;
@property (nonatomic, retain) NSString * orginURL;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * realsize;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) Artist *owner;

@end
