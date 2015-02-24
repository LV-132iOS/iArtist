//
//  Picture+Create.h
//  DArt
//
//  Created by System Administrator on 1/13/15.
//  Copyright (c) 2015 System Administrator. All rights reserved.
//

#import "Picture.h"

@interface Picture (Create)
@property (nonatomic,strong) NSArray *arr;
+(Picture *)CreatePictureWithData:(NSDictionary *)data inManagedobjectcontext:(NSManagedObjectContext *)context;
@end
