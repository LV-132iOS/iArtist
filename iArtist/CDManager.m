//
//  CDManager.m
//  TestingSN
//
//  Created by Admin on 06.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "CDManager.h"
#import "AppDelegate.h"
#import "SessionControl.h"
#import "SDImageCache.h"
#import <CoreData/CoreData.h>

@implementation CDManager

+(void)deleteAccountInfoFromCD {
   
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    //current url for request
    //NSURL* url = [NSURL URLWithString:[@"http://192.168.103.5/" stringByAppendingString:[defaults objectForKey:@"id"]] ];
    //creating request to use it with dataTask
    //preparing session and request
    NSFetchRequest *CDPicturerequest = [[NSFetchRequest alloc]initWithEntityName:@"Picture"];
    CDPicturerequest.predicate = nil;
    NSArray *Pictureresults = [context executeFetchRequest:CDPicturerequest error:NULL];
    for (NSManagedObject * picture in Pictureresults) {
        [context deleteObject:picture];
    }
    NSError *saveError = nil;
    NSFetchRequest *CDArtistrequest = [[NSFetchRequest alloc]initWithEntityName:@"Artist"];
    CDArtistrequest.predicate = nil;
    NSArray *Artistresults = [context executeFetchRequest:CDArtistrequest error:NULL];
    for (NSManagedObject * artist in Artistresults) {
        [context deleteObject:artist];
    }
    [context save:&saveError];
    [[SDImageCache sharedImageCache]clearDisk];
    
    [self deleteServerTokenFromKeychain];

}

+(void) deleteAccountInfoFromServerWithCompletionHandler:(void(^)())handler{
    
//       //current url for request
//    NSURL* url = [NSURL URLWithString:[@"http://192.168.103.5/" stringByAppendingString:[defaults objectForKey:@"id"]] ];
//    NSURL* url = [NSURL URLWithString:[@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/" stringByAppendingString:[defaults objectForKey:@"id"]] ];
//    //creating request to use it with dataTask
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
//    //preparing session and request
//    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
//    request.HTTPMethod = @"DELETE";
//    
//    //request.timeoutInterval = 20;
//    //creating data task
//    
//    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
//                                                completionHandler:^(NSData *data,
//                                                                    NSURLResponse *response,
//                                                                    NSError *error) {
//                                                    logging received response
//                                                    NSLog(@"%@",response);
//                                                    if(!error) handler();
//                                                    
//                                                    
//                                                }];
//    //sending data task
//    
//    [dataTask resume];
    
    [self deleteServerTokenFromKeychain];
}

+(void) setServerTokenToKeychain:(NSString*) string {
    [SSKeychain setPassword:string forService:@"SS.iArtist.serverToken" account:@"useraccount"];
}

+(void) deleteServerTokenFromKeychain {
    [SSKeychain deletePasswordForService:@"SS.iArtist.serverToken" account:@"useraccount"];
}


@end
