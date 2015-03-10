
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
#import "AFHTTPRequestOperationManager.h"
#import "SNClient.h"
//static NSString * const BaseURLString = @"http://10.4.48.126/";
static NSString * const BaseURLString = @"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/";
static dispatch_group_t downloadGroup;
static  AFHTTPSessionManager *manager;
static NSString *querystring;
@interface ServerFetcher ()
@property (nonatomic,assign) dispatch_group_t downloadGroup;
@end
#pragma GCC diagnostic ignored "-Wwarning-flag"

@implementation ServerFetcher


- (NSString *)appedAcceseTockenToString:(NSString*)string {
    NSString *token = [SNClient getServerTokenFromKeychain];
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

- (void)getPictureThumbWithSizeAndID:(NSString*)_id size:(NSNumber *)size callback:(void (^)(UIImage* responde))callback
{   manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"paintings/files/%@?thumb=%@", _id ,size]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             UIImage *image;
             image = (UIImage*)responseObject;
             callback(image);
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}



- (void)RunQueryWithcallback:(void (^)(NSMutableArray* responde))callback;
{   manager.responseSerializer = [AFJSONResponseSerializer serializer];
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

- (void)GetLikesForUser:(NSString *)_id
               callback:(void (^)(NSMutableArray* responde))callback
{   manager.responseSerializer = [AFJSONResponseSerializer serializer];
    Paintingdic = [[NSMutableDictionary alloc]init];
    __block NSMutableArray *urls = [[NSMutableArray alloc]init];
    NSString *str = @"/favorite_paintings";
    str = [self appedAcceseTockenToString:str];
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            for (int i = 0; i<((NSArray*)responseObject).count; i++)
            {
                NSString *str = [BaseURLString stringByAppendingString:@"paintings/files/%@"];
                NSLog(@"%@",((NSArray*)responseObject)[i]);
                [Paintingdic setValue:((NSArray*)responseObject)[i] forKey:[NSString stringWithFormat:@"%d",i]];
                NSString *Urlstr = [NSString stringWithFormat:str,[Paintingdic valueForKeyPath:[NSString stringWithFormat:@"%d._id",i]]];
                Urlstr = [Urlstr stringByAppendingString:@"?thumb=preview"];
                [urls addObject:Urlstr];
            }
          callback(urls);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
    }];
}

    

- (void)GetNewsForUser:(NSString *)_id
              callback:(void (^)(NSMutableArray* responde))callback
{   manager.responseSerializer = [AFJSONResponseSerializer serializer];
    Paintingdic =[[NSMutableDictionary alloc]init];
    Artistdic = [[NSMutableArray alloc]init];
    __block NSMutableArray *ids = [[NSMutableArray alloc]init];
    NSString *str = @"/favorite_artists";
    str = [self appedAcceseTockenToString:str];
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        Artistdic = (NSMutableArray *)responseObject;
                    callback(ids);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)BecomeAFollower:(NSString *)_id
               callback:(void (^)(BOOL responde))callback
{
    __block BOOL isFollowed = NO;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *userid = @"/favorite_artists/";
    userid = [userid stringByAppendingString:_id];
    userid =[self appedAcceseTockenToString:userid];
    [manager PUT:userid
      parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
          if ([[responseObject valueForKey:@"result"] isEqualToString:@"true"] ) {
              isFollowed = YES;
          }
          dispatch_async(dispatch_get_main_queue(), ^{
              callback(isFollowed);
          });
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"%@",error);
      }];
}

- (void)CheckIsFollowing:(NSString *)_id
                callback:(void (^)(BOOL responde))callback
{
    __block BOOL isFollowed = NO;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *userid = @"/favorite_artists/";
    userid = [userid stringByAppendingString:_id];
    userid =[self appedAcceseTockenToString:userid];
    [manager GET:userid
      parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
          if ([[responseObject valueForKey:@"result"] isEqualToString:@"true"] ) {
              isFollowed = YES;
          }
          dispatch_async(dispatch_get_main_queue(), ^{
                callback(isFollowed);
          });
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"%@",error);
      }];
}

- (void)PutLikes:(NSString*)_id callback:(void (^)(NSString *responde))callback
{      __block NSString *responde;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
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
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
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

    } );
    return singleton;
}

- (void)search:(NSString*)searchString callback:(void (^)(NSArray *responde))callback{
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *str = [NSString stringWithFormat:@"?search=\"%@\"",searchString];
    str = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)str,
                                                                                     NULL,
                                                                                     (CFStringRef)@"",kCFStringEncodingUTF8));
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *responde = (NSArray *)responseObject;
        callback(responde);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)FetchArtistsWithID:(NSString*)_id callback:(void(^)(NSDictionary*responde))callback {
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[@"artists/db" stringByAppendingString:_id]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary * artistInfo = (NSDictionary*)responseObject;
             dispatch_async(dispatch_get_main_queue(), ^{
                 callback(artistInfo);
             });
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}


- (void)GetPictureWithID:(NSString*)_id callback:(void (^)(UIImage* responde))callback
{   manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:[@"paintings/files/" stringByAppendingString:_id]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             UIImage *image;
             NSLog(@"%@",responseObject);
             image = (UIImage*)responseObject;
             dispatch_async(dispatch_get_main_queue(), ^{
                 callback(image);
             });
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (void)CancelDownloads{
  
    [[manager session] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if (dataTasks.count != 0){
        for (int i = 0; i<dataTasks.count; i++) {
            [[dataTasks objectAtIndex:i] cancel];
        };
        };
    }];
}
- (void)GetPictureThumbWithID:(NSString*)_id callback:(void (^)(UIImage* responde))callback
{   manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"paintings/files/%@?thumb=preview", _id]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             UIImage *image;
             image = (UIImage*)responseObject;
             dispatch_async(dispatch_get_main_queue(), ^{
                  callback(image);

             });
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
         }];

}
@end
