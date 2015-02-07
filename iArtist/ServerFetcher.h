//
//  ServerFetcher.h
//  DArt
//
//  Created by Clark on 1/30/15.
//  Copyright (c) 2015 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
static  NSMutableDictionary *Artistdic;
@interface ServerFetcher : NSObject
//- (void)Fetch;
- (UIImage*)GetPictureWithID:(NSString*)_id toView:(UIView*)view;
- (void)reloadDB;
- (void)FetchArtists;
- (void)PutLikes;
- (void)GetLikes;
- (NSString*)GenerateQueryForTag:(NSString*)querry;
- (NSMutableDictionary*)RunQuery:(NSString*)queryString;
- (NSString*)GenerateQueryForPrice:(NSString*)querry;
- (NSString*)GenerateQueryForSize:(NSString*)querry;



@end
