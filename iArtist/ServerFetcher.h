//
//  ServerFetcher.h
//  DArt
//
//  Created by Clark on 1/30/15.
//  Copyright (c) 2015 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

static  NSMutableDictionary *Paintingdic;
static  NSMutableArray *Artistdic;

static NSMutableArray *urls;
@interface ServerFetcher : NSObject
@property (nonatomic, strong) NSDictionary  *Paintingdic;
@property (nonatomic, strong) NSMutableArray  *artistdic;
@property (nonatomic, strong) UIImage       *image;
- (void)GetPictureWithID:(NSString*)_id callback:(void (^)(UIImage* responde))callback;
- (UIImage*)GetPictureWithID:(NSString*)_id;
- (void)reloadDB;
- (void)FetchArtists;
- (NSMutableArray*)GetLikesForUser:(NSString*)_id;
- (void)GetNewsForUser:(NSString *)_id
              callback:(void (^)(NSMutableArray* responde))callback;
- (void)GenerateQueryForTag:(NSString*)querry;
- (NSMutableArray*)RunQuery;
- (void)GenerateQueryForPrice:(int)min :(int)max;
- (void)GenerateQueryForSize:(NSString*)querry;
- (NSDictionary *)Paintingdic;
- (NSString*)PutLikes:(NSString*)_id;
- (NSString*)GetLikesCount:(NSString*)_id;
- (BOOL)BecomeAFollower:(NSString *)Artist;
- (BOOL)CheckIsFollowing:(NSString *)_id;
- (void)GenerateQueryForMaterial:(NSString*)querry;
- (void)GenerateQueryForArtist:(NSString*)querry;
- (void)GenerateQueryForColor:(NSString*)querry;

- (UIImage*)GetPictureThumbWithID:(NSString*)_id;


+ (ServerFetcher *)sharedInstance;


@end

