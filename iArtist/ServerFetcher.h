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
- (void)GetPictureThumbWithID:(NSString*)_id callback:(void (^)(UIImage* responde))callback;
- (void)GetPictureWithID:(NSString*)_id callback:(void (^)(UIImage* responde))callback;
- (void)reloadDB;
- (void)FetchArtists;
- (NSMutableArray*)GetLikesForUser:(NSString*)_id;
- (void)GetNewsForUser:(NSString *)_id
              callback:(void (^)(NSMutableArray* responde))callback;
- (void)GenerateQueryForTag:(NSString*)querry;
- (void)RunQueryWithcallback:(void (^)(NSMutableArray* responde))callback;
- (void)GenerateQueryForPrice:(int)min :(int)max;
- (void)GenerateQueryForSize:(NSString*)querry;
- (NSDictionary *)Paintingdic;
- (NSString*)PutLikes:(NSString*)_id;
- (void)GetLikesCount:(NSString *)_id callback:(void (^)(NSString *responde))callback;
- (BOOL)BecomeAFollower:(NSString *)Artist;
- (BOOL)CheckIsFollowing:(NSString *)_id;
- (void)GenerateQueryForMaterial:(NSString*)querry;
- (void)GenerateQueryForArtist:(NSString*)querry;
- (void)GenerateQueryForColor:(NSString*)querry;
- (void)getPictureThumbWithSizeAndID:(NSString*)_id size:(NSNumber *)size callback:(void (^)(UIImage* responde))callback;
+ (ServerFetcher *)sharedInstance;


@end

