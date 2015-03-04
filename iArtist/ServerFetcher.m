
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

//static NSString * const BaseURLString = @"http://10.4.48.126/";
static NSString * const BaseURLString = @"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/";
static dispatch_group_t downloadGroup;
static  AFHTTPSessionManager *manager;
static NSString *querystring;
@interface ServerFetcher ()
@property (nonatomic,assign) dispatch_group_t downloadGroup;
@end

@implementation ServerFetcher


- (NSString *)appedAcceseTockenToString:(NSString*)string {
    NSString *token = @"NLG4XMFE70L6U6UHkF/EGQToMVisckAIXBXwNmiOvWs=";
    token = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)token,
                                                                                     NULL,
                                                                                     (CFStringRef)@"+",kCFStringEncodingUTF8));

    string = [string stringByAppendingString:[@"?access_token=" stringByAppendingString:token]];
    return string;
}

-(NSDictionary *)Paintingdic{
    @synchronized(self){return Paintingdic;}
}

-(NSMutableArray *)artistdic{
    @synchronized(self){return Artistdic;}
}


 - (void)getPictureThumbWithSizeAndID:(NSString*)_id size:(NSNumber *)size callback:(void (^)(UIImage* responde))callback
{
    
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"paintings/files/%@?thumb=%@", _id ,size]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             UIImage *image;
             image = (UIImage*)responseObject;
             callback(image);
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             
             
         }];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    
}
- (void)GenerateQueryForTag:(NSString*)querry{
        dispatch_group_enter(downloadGroup);
        NSString *querryStr = [NSString stringWithFormat:@"{ \"tags\": \"%@\" }",querry];
        querryStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                         (CFStringRef)querryStr,
                                                                                         NULL,
                                                                                         (CFStringRef)@"!*();':@&=+$,/?%#[]{}",kCFStringEncodingUTF8));
        
        querystring = querryStr;
           dispatch_group_leave(downloadGroup);

   
   }

- (void)GenerateQueryForMaterial:(NSString*)querry{
    dispatch_group_enter(downloadGroup);
    NSString *querryStr = [NSString stringWithFormat:@"{ \"materials\": \"%@\" }",querry];
    querryStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)querryStr,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*();':@&=+$,/?%#[]{}",kCFStringEncodingUTF8));
    
    querystring = querryStr;
    dispatch_group_leave(downloadGroup);

}

- (void)GenerateQueryForArtist:(NSString*)querry{
    dispatch_group_enter(downloadGroup);

    NSString *querryStr = [NSString stringWithFormat:@"{ \"Artist\": \"%@\" }",querry];
    querryStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)querryStr,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*();':@&=+$,/?%#[]{}",kCFStringEncodingUTF8));
    
    querystring = querryStr;
    dispatch_group_leave(downloadGroup);

}
- (void)GenerateQueryForColor:(NSString*)querry{
    dispatch_group_enter(downloadGroup);

    NSString *querryStr = [NSString stringWithFormat:@"{ \"Color\": \"%@\" }",querry];
    querryStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                            (CFStringRef)querryStr,
                                                                                            NULL,
                                                                                            (CFStringRef)@"!*();':@&=+$,/?%#[]{}",kCFStringEncodingUTF8));

    querystring = querryStr;
    dispatch_group_leave(downloadGroup);

}




- (void)GenerateQueryForPrice:(int)min :(int)max{
    dispatch_group_enter(downloadGroup);

    NSString *querryStr = [NSString stringWithFormat:@"{ \"price\": {\"\$gte\":%d,\"\$lte\":%d} }",min,max];
    querryStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)querryStr,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*();':@&=+$,/?%#[]{}",kCFStringEncodingUTF8));
    
    querystring = querryStr;
    dispatch_group_leave(downloadGroup);

}



- (void)GenerateQueryForSize:(NSString*)querry{
    dispatch_group_enter(downloadGroup);

    NSString *querryStr = [NSString stringWithFormat:@"{ \"size\": \"%@\" }",querry];
    querryStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)querryStr,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*();':@&=+$,/?%#[]{}",kCFStringEncodingUTF8));
    
    querystring = querryStr;
    dispatch_group_leave(downloadGroup);

    
}





- (void)RunQueryWithcallback:(void (^)(NSMutableArray* responde))callback;
{
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    Paintingdic = [[NSMutableDictionary alloc]init];
    NSMutableArray *urls = [[NSMutableArray alloc]init];
    if (querystring == nil) {
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER);

    }
    else{
  
    NSString *str = [@"paintings/db?query=" stringByAppendingString:querystring] ;
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            for (int i = 0; i<((NSArray*)responseObject).count; i++)
            {
                NSString *str = [BaseURLString stringByAppendingString:@"paintings/files/%@"];
                [Paintingdic setValue:((NSArray*)responseObject)[i] forKey:[NSString stringWithFormat:@"%d",i]];
                NSString *Urlstr = [NSString stringWithFormat:str,[Paintingdic valueForKeyPath:[NSString stringWithFormat:@"%d._id",i]]];
                Urlstr = [Urlstr stringByAppendingString:@"?thumb=preview"];
                NSLog(@"%@",Urlstr);
                [urls addObject:Urlstr];
                
            }
      
            callback(urls);
        
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);

    }];
  
    }
}

- (NSMutableArray*)GetLikesForUser:(NSString *)_id
{
   
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
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
                Urlstr = [Urlstr stringByAppendingString:@"?thumb=preview"];
                NSLog(@"%@",Urlstr);
                [urls addObject:Urlstr];
                
            }
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            dispatch_semaphore_signal(semaphore);
            
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        return urls;
        }

    

- (void)GetNewsForUser:(NSString *)_id
              callback:(void (^)(NSMutableArray* responde))callback
{
    Paintingdic =[[NSMutableDictionary alloc]init];
    Artistdic = [[NSMutableArray alloc]init];
    __block NSMutableArray *ids = [[NSMutableArray alloc]init];
    NSString *str = [NSString stringWithFormat:@"%@/favorite_artists",_id];
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        Artistdic = (NSMutableArray *)responseObject;
        for (int i=0; i<Artistdic.count; i++) {
            for (int j=0; j<[((NSArray*)[Artistdic[i] valueForKey:@"paintings"]) count]; j++) {
                [ids addObject: [[((NSArray*)[Artistdic[i] valueForKey:@"paintings"]) objectAtIndex:j] valueForKey:@"_id" ]];
                [Paintingdic setObject:[((NSArray*)[Artistdic[i] valueForKey:@"paintings"]) objectAtIndex:j]forKey:[NSString stringWithFormat:@"%d",j]];
            }
            
        }
            callback(ids);
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);

        
    }];
}


- (BOOL)BecomeAFollower:(NSString *)_id{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block BOOL isFollowed = NO;
    NSString *userid = @"/favorite_artists/";
    [userid stringByAppendingString:_id];
    [self appedAcceseTockenToString:userid];
    [manager PUT:userid
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
    NSString *userid = @"/favorite_artists/";
    [userid stringByAppendingString:_id];
    [self appedAcceseTockenToString:userid];
    [manager GET:userid
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




- (void)PutLikes:(NSString*)_id callback:(void (^)(NSString *responde))callback
{
    

    __block NSString *responde;
    NSString *userid = @"/favorite_paintings/";
    userid = [userid stringByAppendingString:_id];
    userid = [self appedAcceseTockenToString:userid];
    [manager PUT:userid
  parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
      responde = [responseObject valueForKey:@"count"];
      dispatch_async(dispatch_get_main_queue(), ^{
          callback(responde);
      });

} failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@",error);

}];
}

- (void)GetLikesCount:(NSString *)_id callback:(void (^)(NSString *responde))callback
{
    
    __block NSString *count = [[NSString alloc]init];
    [manager GET:[NSString stringWithFormat:@"paintings/db/%@?likes=true",_id] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        count = [(NSDictionary *)responseObject objectForKey:@"count"];
        dispatch_async(dispatch_get_main_queue(), ^{
             callback(count);
        });
       

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);

    }];

}




+ (ServerFetcher *)sharedInstance{
    static ServerFetcher *singleton = nil;
    static dispatch_once_t predicate;
    
    dispatch_once( &predicate, ^{
        singleton = [[ServerFetcher alloc]init];
        downloadGroup = dispatch_group_create();
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURL *urllstr = [[NSURL alloc]initWithString:BaseURLString];
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:urllstr sessionConfiguration:config];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"image/png",@"text/html",nil];
    } );
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

   
    return singleton;
}


- (void)FetchArtists {
    //_artistdic = [[NSMutableDictionary alloc]init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    [manager GET:@"/artists/db/54d8e80de3ad4c9f15f3a653"
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
           // _artistdic = (NSDictionary*)responseObject;
             dispatch_semaphore_signal(semaphore);  
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             dispatch_semaphore_signal(semaphore);

             
             
         }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    
        
}


- (void)GetPictureWithID:(NSString*)_id callback:(void (^)(UIImage* responde))callback
{
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:[@"paintings/files/" stringByAppendingString:_id]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             UIImage *image;
             image = (UIImage*)responseObject;
             callback(image);
             manager.responseSerializer = [AFJSONResponseSerializer serializer];
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             
             
         }];
    
    
    
}

- (void)GetPictureThumbWithID:(NSString*)_id callback:(void (^)(UIImage* responde))callback
{
    
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"paintings/files/%@?thumb=preview", _id]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             UIImage *image;
             image = (UIImage*)responseObject;
             dispatch_sync(dispatch_get_main_queue(), ^{
                  callback(image);
             });
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             
             
         }];

    
    
    
}





@end
