
//  ServerFetcher.m
//  DArt
//
//  Created by Clark on 1/30/15.
//  Copyright (c) 2015 System Administrator. All rights reserved.
//

#import "ServerFetcher.h"
#import "AFNetworking.h"
#import "Picture+Create.h"
#import "AppDelegate.h"

static NSString * const BaseURLString = @"http://192.168.103.5/";
//static NSString * const BaseURLString = @"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/";
static  AFHTTPSessionManager *manager;
static NSString *querystring;



@interface ServerFetcher ()

@end

@implementation ServerFetcher

-(NSDictionary *)Paintingdic{
    @synchronized(self){return Paintingdic;}
}


- (void)GenerateQueryForTag:(NSString*)querry{
    NSString *querryStr = [NSString stringWithFormat:@"{ \"tags\": \"%@ 11\" }",querry];
    querryStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                            (CFStringRef)querryStr,
                                                                                            NULL,
                                                                                            (CFStringRef)@"!*();':@&=+$,/?%#[]{}",kCFStringEncodingUTF8));

    querystring = querryStr;
}




- (void)GenerateQueryForPrice:(int)min :(int)max{
#pragma warning (push)
#pragma warning (disable : unknown escape sequence '\$')
    NSString *querryStr = [NSString stringWithFormat:@"{ \"price\": {\"\$gte\":%d,\"\$lte\":%d} }",min,max];
#pragma warning (pop)

    querryStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)querryStr,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*();':@&=+$,/?%#[]{}",kCFStringEncodingUTF8));
    
    querystring = querryStr;
}



- (void)GenerateQueryForSize:(NSString*)querry{
    NSString *querryStr = [NSString stringWithFormat:@"{ \"realsize\": \"%@\" }",querry];
    querryStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)querryStr,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*();':@&=+$,/?%#[]{}",kCFStringEncodingUTF8));
    
    querystring = querryStr;
}





- (NSMutableArray*)RunQuery
{
    if (querystring == nil) {
        return nil;
    }
    else{
    Paintingdic = [[NSMutableDictionary alloc]init];
    NSMutableArray *urls = [[NSMutableArray alloc]init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSString *str = [@"paintings/db?query=" stringByAppendingString:querystring] ;
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            for (int i = 0; i<((NSArray*)responseObject).count; i++)
            {
                NSString *str = [BaseURLString stringByAppendingString:@"paintings/files/%@"];
                [Paintingdic setValue:((NSArray*)responseObject)[i] forKey:[NSString stringWithFormat:@"%d",i]];
                NSString *Urlstr = [NSString stringWithFormat:str,[Paintingdic valueForKeyPath:[NSString stringWithFormat:@"%d._id",i]]];
                Urlstr = [Urlstr stringByAppendingString:@"?thumb=true"];
                NSLog(@"%@",Urlstr);
                [urls addObject:Urlstr];
                
            }
        
       // [Picture CreatePictureWithData:dic inManagedobjectcontext:((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext ];
       dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
       dispatch_semaphore_signal(semaphore);

    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return urls;
  
    }
}

- (NSMutableArray*)GetLikesForUser:(NSString *)_id
{
    
        Paintingdic = [[NSMutableDictionary alloc]init];
        NSMutableArray *urls = [[NSMutableArray alloc]init];
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        NSString *str = [NSString stringWithFormat:@"%@/favorite_paintings",_id];
        [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            for (int i = 0; i<((NSArray*)responseObject).count; i++)
            {
                NSString *str = [BaseURLString stringByAppendingString:@"paintings/files/%@"];
                [Paintingdic setValue:((NSArray*)responseObject)[i] forKey:[NSString stringWithFormat:@"%d",i]];
                NSString *Urlstr = [NSString stringWithFormat:str,[Paintingdic valueForKeyPath:[NSString stringWithFormat:@"%d._id",i]]];
                Urlstr = [Urlstr stringByAppendingString:@"?thumb=true"];
                NSLog(@"%@",Urlstr);
                [urls addObject:Urlstr];
                
            }
            NSLog(@"%@",urls);

            
            // [Picture CreatePictureWithData:dic inManagedobjectcontext:((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext ];
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            dispatch_semaphore_signal(semaphore);
            
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        return urls;
        }

- (NSMutableArray*)GetNewsForUser:(NSString *)_id
{
    
    Artistdic = [[NSMutableDictionary alloc]init];
    NSMutableArray *urls = [[NSMutableArray alloc]init];
   //  __block NSMutableDictionary *Paintingids =[[NSMutableArray alloc]init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSString *str = [NSString stringWithFormat:@"%@/favorite_artists",_id];
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        for (int i = 0; i<((NSArray*)responseObject).count; i++)
        {
            //NSString *str = [BaseURLString stringByAppendingString:@"paintings/files/%@"];
          //  [Artistdic setValue:((NSArray*)responseObject)[i] forKey:[NSString stringWithFormat:@"%d",i]];
         // [Paintingids insertObject:<#(id)#> atIndex:<#(NSUInteger)#>  (NSArray*)[Artistdic valueForKeyPath:[NSString stringWithFormat:@"%d.paintings",i]];
//            Urlstr = [Urlstr stringByAppendingString:@"?thumb=true"];
//            NSLog(@"%@",Urlstr);
//            [urls addObject:Urlstr];
            
        }
        NSLog(@"%@",Artistdic);
        
        
        // [Picture CreatePictureWithData:dic inManagedobjectcontext:((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext ];
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(semaphore);
        
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return urls;
}

- (BOOL)BecomeAFollower:(NSString *)_id{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block BOOL isFollowed = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userid = [defaults objectForKey:@"id"];
    userid = [userid stringByAppendingString:@"/favorite_artists/"];
    [manager PUT:[userid stringByAppendingString:_id]
      parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
          if ([[responseObject valueForKey:@"result"] isEqualToString:@"true"] ) {
              isFollowed = YES;
          }
          dispatch_semaphore_signal(semaphore);
          
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"%@",error);
          dispatch_semaphore_signal(semaphore);
          
      }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return isFollowed;
}

- (BOOL)CheckIsFollowing:(NSString *)_id{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block BOOL isFollowed = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userid = [defaults objectForKey:@"id"];
    userid = [userid stringByAppendingString:@"/favorite_artists/"];
    [manager GET:[userid stringByAppendingString:_id]
      parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
          if ([[responseObject valueForKey:@"result"] isEqualToString:@"true"] ) {
              isFollowed = YES;
          }
          dispatch_semaphore_signal(semaphore);
          
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"%@",error);
          dispatch_semaphore_signal(semaphore);
          
      }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return isFollowed;
}




- (NSString*)PutLikes:(NSString*)_id{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userid = [defaults objectForKey:@"id"];
    __block NSString *responde;
    userid = [userid stringByAppendingString:@"/favorite_paintings/"];
    [manager PUT:[userid stringByAppendingString:_id]
  parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
      responde = [responseObject valueForKey:@"count"];
      dispatch_semaphore_signal(semaphore);

} failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@",error);
    dispatch_semaphore_signal(semaphore);

}];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return responde;
}

- (NSString*)GetLikesCount:(NSString *)_id{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block NSString *count = [[NSString alloc]init];
    [manager GET:[NSString stringWithFormat:@"paintings/db/%@?likes=true",_id] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",responseObject);
        count = [(NSDictionary *)responseObject objectForKey:@"count"];
        dispatch_semaphore_signal(semaphore);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(semaphore);

    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    return count;
}

-(id)init{
   
       return self;
    
}


+ (ServerFetcher *)sharedInstance{
    static ServerFetcher *singleton = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        singleton = [[ServerFetcher alloc]init];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURL *urllstr = [[NSURL alloc]initWithString:BaseURLString];
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:urllstr sessionConfiguration:config];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    } );


   
    return singleton;
}


- (void)FetchArtists {
    _artistdic = [[NSMutableDictionary alloc]init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    [manager GET:@"/artists/db/54d8e80de3ad4c9f15f3a653"
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             /*for (int i = 0; i<((NSArray*)responseObject).count; i++)
             {
                 [Paintingdic setValue:((NSArray*)responseObject)[i] forKey:[NSString stringWithFormat:@"%d",i]];
                 
             }*/
             
             _artistdic = (NSDictionary*)responseObject;
            
             dispatch_semaphore_signal(semaphore);

             
             //[Picture CreatePictureWithData:Paintingdic inManagedobjectcontext:((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext ];
             
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             dispatch_semaphore_signal(semaphore);

             
             
         }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    
        
}


- (UIImage*)GetPictureThumbWithID:(NSString*)_id
{
    __block UIImage *image;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:[@"paintings/files/" stringByAppendingString:[NSString stringWithFormat:@"%@?thumb=true",_id]]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             image = (UIImage*)responseObject;
             dispatch_semaphore_signal(semaphore);
            
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             dispatch_semaphore_signal(semaphore);

             
         }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return image;

    
    
}

- (UIImage*)GetPictureWithID:(NSString*)_id
{
    __block UIImage *image;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:[@"paintings/files/" stringByAppendingString:_id]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             image = (UIImage*)responseObject;
             dispatch_semaphore_signal(semaphore);
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             dispatch_semaphore_signal(semaphore);
             
             
         }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return image;
    
    
    
}


- (void)reloadDB
{
    int k = 0;
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Picture"];
    request.predicate = nil;
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    for (int i = 0;i <matches.count;i++)
    {
        for (int j = 0; j<Paintingdic.count; j++) {
            if([((Picture*)matches[i]).id_ isEqual:[Paintingdic valueForKeyPath:[NSString stringWithFormat:@"%d._id",j]]]){
                k++;
            }
        }
        if (k) {
             NSLog(@"OK");
        }
        else{
            [context deleteObject:matches[i]];
        }
    
    }

}




@end
