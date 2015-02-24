//
//  Picture+Create.m
//  DArt
//
//  Created by System Administrator on 1/13/15.
//  Copyright (c) 2015 System Administrator. All rights reserved.
//

#import "Picture+Create.h"
#import "Artist+Create.h"


@implementation Picture (Create)
+(Picture *)CreatePictureWithData:(NSDictionary *)data inManagedobjectcontext:(NSManagedObjectContext *)context
{
    //NSLog(@"%@",  [data valueForKeyPath:@"1_id"]  );
    

    Picture *picture = nil;
    for (int i=0; i<data.count; i++){
        
    
    NSString *_id = [data valueForKeyPath:[NSString stringWithFormat:@"%d._id",i ]];
        NSLog(@"%@",_id);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Picture"];
    request.predicate = [NSPredicate predicateWithFormat:@"id_=%@", _id];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if(matches.count > 1 || !matches || error)
    {
        //handle error
    }
    else if ([matches count])
        picture = [matches firstObject];
    else
    {

        picture = [NSEntityDescription insertNewObjectForEntityForName:@"Picture" inManagedObjectContext:context];
        picture.id_ = [data valueForKeyPath:[NSString stringWithFormat:@"%d._id",i ]];
        picture.title = [data valueForKeyPath:[NSString stringWithFormat:@"%d.title",i ]];
        picture.descript = [data valueForKeyPath:[NSString stringWithFormat:@"%d.description",i ]];
        picture.size = [data valueForKeyPath:[NSString stringWithFormat:@"%d.size",i ]];
        picture.realsize = [data valueForKeyPath:[NSString stringWithFormat:@"%d.realsize",i ]];
        //picture.thumbnailURL = [data valueForKeyPath:[NSString stringWithFormat:@"%d.title",i ]];
        NSString* locString = [NSString stringWithFormat:@"/paintings/%@",_id];
        picture.orginURL = [data valueForKeyPath:[IAamazonServer stringByAppendingString:locString]];
        picture.price = [data valueForKeyPath:[NSString stringWithFormat:@"%d.price",i ]];
        
       // picture.owner = [Artist CreateArtistinWithId:[data valueForKeyPath:[NSString stringWithFormat:@"%d.artistId",i ]] inManagedobjectcontext:context];
      //  NSLog(@"%@",picture.title);
        //NSString *apple = @"Apple";
       // NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Picture"];
        //request.predicate = [NSPredicate predicateWithFormat:@"title = %@",apple];
        //NSError *error;
       // NSArray *matches = [context executeFetchRequest:request error:&error];
        //NSLog(@"%lu",(unsigned long)matches.count);

        
    }
    }

    return picture;
}
@end
