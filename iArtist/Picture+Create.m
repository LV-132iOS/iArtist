//
//  Picture+Create.m
//  DArt
//
//  Created by System Administrator on 1/13/15.
//  Copyright (c) 2015 System Administrator. All rights reserved.
//

#import "Picture+Create.h"
#import "Artist+Create.h"
#import "AppDelegate.h"


@implementation Picture (Create)
+(Picture *)CreatePictureWithData:(NSDictionary *)data inManagedobjectcontext:(NSManagedObjectContext *)context
{
    Picture *picture = nil;
    NSString *_id = [data valueForKeyPath: @"_id"];
   // NSLog(@"%@",data);
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
        picture.id_ = [data valueForKeyPath:[NSString stringWithFormat:@"_id" ]];
        picture.title = [data valueForKeyPath:[NSString stringWithFormat:@"title"]];
        picture.descript = [data valueForKeyPath:[NSString stringWithFormat:@"description" ]];
        picture.size = [data valueForKeyPath:[NSString stringWithFormat:@"size" ]];
        picture.realsize = [data valueForKeyPath:[NSString stringWithFormat:@"realsize"]];
        picture.thumbnailURL = [NSString stringWithFormat:@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/paintings/%@?thumb=preview",_id];
        picture.orginURL = [NSString stringWithFormat:@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/paintings/%@",_id];
        picture.price = [data valueForKeyPath:[NSString stringWithFormat:@"price" ]];
        picture.materials = [data valueForKey:@"materials"];
        picture.genre = [data valueForKey:@"genre"];
        picture.tags = [[data valueForKey:@"tags"]componentsJoinedByString:@","];
        picture.owner = [Artist CreateArtistinWithId:[data valueForKeyPath:[NSString stringWithFormat:@"artistId" ]] inManagedobjectcontext:context];
        NSLog(@"%@",picture);
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    }

    return picture;
}
@end
