//
//  SNClient.m
//  TestingSN
//
//  Created by Admin on 04.03.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SNClient.h"

@implementation SNClient

+(SNSocialNetworkFabric *)getFabricWithName:(NSString *)SNname {
    if ([SNname isEqualToString:SNnameFacebook]) {
        return (SNSocialNetworkFabric*)[[SNFacebookFabric alloc] init];
    } else if ([SNname isEqualToString:SNnameTwitter]) {
        return (SNSocialNetworkFabric*)[[SNTwitterFabric alloc] init];
    } else if ([SNname isEqualToString:SNnameGooglePlus]) {
        return (SNSocialNetworkFabric*)[[SNGooglePlusFabric alloc] init];
    } else if ([SNname isEqualToString:SNnameVkontakte]) {
        return (SNSocialNetworkFabric*)[[SNVkontakteFabric alloc] init];
    } else if ([SNname isEqualToString:SNnameEmail]) {
        return (SNSocialNetworkFabric*)[[SNEmailFabric alloc] init];
    } else {
        return Nil;
    }
}


+(void) logInWithSocialNetwork:(SNSocialNetwork*)network WithCompletionHandler:(void(^)())handler{
    
     NSDictionary* dataToPassDic;
    if ([network.socialName isEqualToString:@"Twitter"]) {
        dataToPassDic = @{
                          @"_id" : network.userid,
                          @"username" : network.username,
                          @"grant_type" : @"client_credentials"
                        };
    } else {
        dataToPassDic = @{
                          @"_id" : network.userid,
                          @"username" : network.username,
                          @"useremail" : network.useremail,
                          @"grant_type" : @"client_credentials"
                        };
    }
    //and convert dictionary to proper type
    NSData* dataToPass = [NSJSONSerialization dataWithJSONObject:dataToPassDic
                                                         options:0
                                                           error:nil];
    //current url for request
    NSURL* url = [NSURL URLWithString:@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/social_network/login"];
    //creating request to use it with dataTask
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    //preparing session and request
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    request.HTTPMethod = @"POST";
    request.HTTPBody = dataToPass;
    //request.timeoutInterval = 20;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //creating data task
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,                                                                                                  NSURLResponse *response,                                                                                                  NSError *error) {
                                                    //logging received response
                                                    NSLog(@"%@",response);
                                                    
                                                    
                                                    if (!error) {
                                                        NSMutableDictionary * innerJson = [NSJSONSerialization
                                                                                           JSONObjectWithData:data
                                                                                           options:kNilOptions
                                                                                           error:nil
                                                                                           ];
                                                        [CDManager setServerTokenToKeychain:[innerJson valueForKey:@"access_token"]];
                                                        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        NSLog(@"%@", str);
                                                        handler();
                                                        
                                                    } else {
                                                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed to send info"
                                                                                                        message:@"Please, re-login later"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                        [alert show];
                                                    }
                                                    
                                                }];
    //sending data task
    
    [dataTask resume];
}

+(void)signUpWithEmail:(SNSocialNetwork *)network WithCompletionHandler:(void(^)())handler {
    NSDictionary* dataToPassDic =  @{
                          @"username" : network.username,
                          @"grant_type" : @"client_credentials"
                          };
  
    //and convert dictionary to proper type
    NSData* dataToPass = [NSJSONSerialization dataWithJSONObject:dataToPassDic
                                                         options:0
                                                           error:nil];
    //current url for request
    NSURL* url = [NSURL URLWithString:@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/signup"];
    //creating request to use it with dataTask
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    //preparing session and request
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    request.HTTPMethod = @"POST";
    request.HTTPBody = dataToPass;
    //request.timeoutInterval = 20;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:network.username forHTTPHeaderField:@"username"];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", network.useremail, network.userid];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    //creating data task
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,                                                                                                  NSURLResponse *response,                                                                                                  NSError *error) {
                                                    //logging received response
                                                    NSLog(@"%@",response);
                                                    
                                                    
                                                    if (!error) {
                                                        NSMutableDictionary * innerJson = [NSJSONSerialization
                                                                                           JSONObjectWithData:data
                                                                                           options:kNilOptions
                                                                                           error:nil
                                                                                           ];
                                                        [CDManager setServerTokenToKeychain:[innerJson valueForKey:@"access_token"]];
                                                        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        NSLog(@"%@", str);
                                                        handler();
                                                        
                                                    } else {
                                                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed to send info"
                                                                                                        message:@"Please, re-login later"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                        [alert show];
                                                    }
                                                    
                                                }];
    //sending data task
    
    [dataTask resume];
}

+(void)logInWithEmail:(SNSocialNetwork *)network WithCompletionHandler:(void (^)())handler {
    NSDictionary* dataToPassDic =  @{
                                     @"grant_type" : @"client_credentials"
                                     };
    
    //and convert dictionary to proper type
    NSData* dataToPass = [NSJSONSerialization dataWithJSONObject:dataToPassDic
                                                         options:0
                                                           error:nil];
    //current url for request
    NSURL* url = [NSURL URLWithString:@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/login"];
    //creating request to use it with dataTask
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    //preparing session and request
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    request.HTTPMethod = @"POST";
    request.HTTPBody = dataToPass;
    //request.timeoutInterval = 20;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  //  [request addValue:network.username forHTTPHeaderField:@"username"];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", network.useremail, network.userid];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    //creating data task
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,                                                                                                  NSURLResponse *response,                                                                                                  NSError *error) {
                                                    //logging received response
                                                    NSLog(@"%@",response);
                                                    
                                                    
                                                    if (!error) {
                                                        NSMutableDictionary * innerJson = [NSJSONSerialization
                                                                                           JSONObjectWithData:data
                                                                                           options:kNilOptions
                                                                                           error:nil
                                                                                           ];
                                                        [CDManager setServerTokenToKeychain:[innerJson valueForKey:@"access_token"]];
                                                        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        NSLog(@"%@", str);
                                                        
                                                        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                                        int responseStatusCode = [httpResponse statusCode];
                                                        
                                                        if (responseStatusCode == 200) {
                                                              handler();
                                                        } else {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                                message:@"Incorrect credentials"
                                                                                                               delegate:nil
                                                                                                      cancelButtonTitle:@"OK"
                                                                                                      otherButtonTitles:nil];
                                                                [alert show];
                                                            });
                   
                                                        }
                                                        
                                                      
                                                        
                                                    } else {
                                                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed to send info"
                                                                                                        message:@"Please, re-login later"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                        [alert show];
                                                    }
                                                    
                                                }];
    //sending data task
    
    [dataTask resume];

}

+(void) logoutWithSN:(SNSocialNetwork *)network WithCompletionHandler:(void (^)())handler {
    //current url for request
    ServerFetcher* fet = [ServerFetcher sharedInstance];
    NSString *locString = [fet appedAcceseTockenToString:@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/logout"];
    NSURL* url = [NSURL URLWithString:locString];
    //creating request to use it with dataTask
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    //preparing session and request
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    request.HTTPMethod = @"POST";
    //request.timeoutInterval = 20;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
//creating data task
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,                                                                                                  NSURLResponse *response,                                                                                                  NSError *error) {
                                                    //logging received response
                                                    NSLog(@"%@",response);
                                                    
                                                    
                                                    if (!error) {
                                                        NSMutableDictionary * innerJson = [NSJSONSerialization
                                                                                           JSONObjectWithData:data
                                                                                           options:kNilOptions
                                                                                           error:nil
                                                                                           ];
                                                        [CDManager deleteServerTokenFromKeychain];
                                                        NSLog(@"%@", innerJson);
                                                        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        NSLog(@"%@", str);
                                                        handler();
                                                        
                                                    } else {
                                                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed to send info"
                                                                                                        message:@"Please, re-login later"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                        [alert show];
                                                    }
                                                    
                                                }];
    //sending data task
    
    [dataTask resume];
}

+(void) deleteSNAccount:(SNSocialNetwork*)network WithCompletionHandler:(void (^)())handler {
    //current url for request
    ServerFetcher* fet = [ServerFetcher sharedInstance];
    NSString *locString = [fet appedAcceseTockenToString:@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/me"];
    NSURL* url = [NSURL URLWithString:locString];
    //creating request to use it with dataTask
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    //preparing session and request
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    request.HTTPMethod = @"DELETE";
    //request.timeoutInterval = 20;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //creating data task
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,                                                                                                  NSURLResponse *response,                                                                                                  NSError *error) {
                                                    //logging received response
                                                    NSLog(@"%@",response);
                                                    
                                                    
                                                    if (!error) {
                                                        NSMutableDictionary * innerJson = [NSJSONSerialization
                                                                                           JSONObjectWithData:data
                                                                                           options:kNilOptions
                                                                                           error:nil
                                                                                           ];
                                                        [CDManager deleteServerTokenFromKeychain];
                                                        NSLog(@"%@", innerJson);
                                                        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        NSLog(@"%@", str);
                                                        handler();
                                                        
                                                    } else {
                                                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed to send info"
                                                                                                        message:@"Please, re-login later"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                        [alert show];
                                                    }
                                                    
                                                }];
    //sending data task
    
    [dataTask resume];
}

+(NSString*) getServerTokenFromKeychain {
    return [SSKeychain passwordForService:@"SS.iArtist.serverToken" account:@"useraccount"];
}

@end
