//
//  Artist+Create.h
//  DArt
//
//  Created by System Administrator on 1/13/15.
//  Copyright (c) 2015 System Administrator. All rights reserved.
//

#import "Artist.h"

@interface Artist (Create)
+(Artist *)CreateArtistinWithId:(NSDictionary*)artid inManagedobjectcontext:(NSManagedObjectContext *)context;
@end
