//
//  Artist+Create.m
//  DArt
//
//  Created by System Administrator on 1/13/15.
//  Copyright (c) 2015 System Administrator. All rights reserved.
//

#import "Artist+Create.h"
#import "Picture+Create.h"
#import "ServerFetcher.h"

@implementation Artist (Create)

+(Artist *)CreateArtistinWithId:(NSDictionary*)artid inManagedobjectcontext:(NSManagedObjectContext *)context;
{
  
    Artist *artist = nil;
   
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    request.predicate = [NSPredicate predicateWithFormat:@"id_=%@", artid];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if(matches.count > 1 || !matches || error)
    {
        //handle error
    }
    else if ([matches count])
        artist = [matches firstObject];
    else
    {
        artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:context];
       // artist.id_ = artid;
        
        artist.name = [artid valueForKeyPath:@"name"];
        artist.biography = [artid valueForKeyPath:@"bipgraphy"];
        artist.location = [artid valueForKeyPath:@"location"];
        artist.email = [artid valueForKeyPath:@"email"];
        NSLog(@"%@",artist);

            }
    return artist;
    
}
@end
