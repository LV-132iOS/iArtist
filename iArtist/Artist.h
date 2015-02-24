//
//  Artist.h
//  DArt
//
//  Created by Clark on 2/6/15.
//  Copyright (c) 2015 System Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Picture;

@interface Artist : NSManagedObject

@property (nonatomic, retain) NSString * biography;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * id_;
@property (nonatomic, retain) NSSet *picturesbyartist;
@end

@interface Artist (CoreDataGeneratedAccessors)

- (void)addPicturesbyartistObject:(Picture *)value;
- (void)removePicturesbyartistObject:(Picture *)value;
- (void)addPicturesbyartist:(NSSet *)values;
- (void)removePicturesbyartist:(NSSet *)values;

@end
