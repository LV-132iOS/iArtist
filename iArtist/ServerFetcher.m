
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
static NSString * const BaseURLString = @"http://192.168.103.5:8080";
static  NSMutableDictionary *Paintingdic;


@interface ServerFetcher ()
@property (nonatomic,strong)  NSURLSessionConfiguration *config;
@property (nonatomic,strong)    NSURL *baseURL;
@property (nonatomic,strong)    AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableArray *Images;
@end

@implementation ServerFetcher




- (NSString*)GenerateQueryForTag:(NSString*)querry{
    NSString *querryStr = [NSString stringWithFormat:@"{ \"tags\": \"%@\" }",querry];
    querryStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                            (CFStringRef)querryStr,
                                                                                            NULL,
                                                                                            (CFStringRef)@"!*();':@&=+$,/?%#[]{}",kCFStringEncodingUTF8));

    return querryStr;
}

- (NSString*)GenerateQueryForPrice:(NSString*)querry{
    NSString *querryStr = [NSString stringWithFormat:@"{ \"price\": {\"\$lt\":%@} }",querry];
    querryStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)querryStr,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*();':@&=+$,/?%#[]{}",kCFStringEncodingUTF8));
    
    return querryStr;
}

- (NSString*)GenerateQueryForSize:(NSString*)querry{
    NSString *querryStr = [NSString stringWithFormat:@"{ \"size\": \"%@\" }",querry];
    querryStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)querryStr,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*();':@&=+$,/?%#[]{}",kCFStringEncodingUTF8));
    
    return querryStr;
}

- (NSMutableDictionary*)RunQuery:(NSString*)queryString
{
    NSMutableDictionary* dic;
    dic = [[NSMutableDictionary alloc]init];
    NSString *str = [@"paintings/db?query=" stringByAppendingString:queryString];
    [self.manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
            for (int i = 0; i<((NSArray*)responseObject).count; i++)
            {
                [Paintingdic setValue:((NSArray*)responseObject)[i] forKey:[NSString stringWithFormat:@"%d",i]];
              
                
            }
        for (int i = 0; i<((NSArray*)responseObject).count; i++)
        {
            [Paintingdic setValue:((NSArray*)responseObject)[i] forKey:[NSString stringWithFormat:@"%d",i]];
            
        }
        
        NSLog(@"%@",Paintingdic);
        [Picture CreatePictureWithData:Paintingdic inManagedobjectcontext:((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext ];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    return dic;
   
}

- (void)PutLikes{
[self.manager PUT:@"/tw719461997/favorite_paintings/54d0de6cf12ad4516e497ea8" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"%@",responseObject);
} failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@",error);
}];
}

-(void)GetLikes{
    [self.manager GET:@"/tw719461997/favorite_paintings" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(instancetype)init{
    self = [super init];
    _config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _baseURL = [NSURL URLWithString:BaseURLString];
    _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:_baseURL sessionConfiguration:_config];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //_manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //_manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return self;
}


- (void)FetchArtists {
    Artistdic = [[NSMutableDictionary alloc]init];
    [self.manager GET:@"/arstists"
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             for (int i = 0; i<((NSArray*)responseObject).count; i++)
             {
                 [Paintingdic setValue:((NSArray*)responseObject)[i] forKey:[NSString stringWithFormat:@"%d",i]];
                 
             }
             
             NSLog(@"%@",Paintingdic);
             
             
             
             [Picture CreatePictureWithData:Paintingdic inManagedobjectcontext:((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext ];
             
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             
             
         }];
    
        
}

/*- (void)Fetch {
    Paintingdic = [[NSMutableDictionary alloc]init];
    [self FetchArtists];

    [self.manager GET:@"/paintings/db"
           parameters:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {          
                  for (int i = 0; i<((NSArray*)responseObject).count; i++)
                  {
                      [Paintingdic setValue:((NSArray*)responseObject)[i] forKey:[NSString stringWithFormat:@"%d",i]];
           
                  }
                  
                  NSLog(@"%@",Paintingdic);
                 
                  
                  
                  [Picture CreatePictureWithData:Paintingdic inManagedobjectcontext:((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext ];
                  //[self reloadDB];
               
                  
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSLog(@"Error: %@", error);
                  
              }];
}*/
- (UIImage*)GetPictureWithID:(NSString*)_id toView:(UIView*)view;
{
    __block UIImage *image;
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
   self.manager.responseSerializer = [AFImageResponseSerializer serializer];
    [self.manager GET:[@"paintings/files/" stringByAppendingString:_id]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             image = (UIImage*)responseObject;
           
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             
         }];
    
 
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
