//
//  ServerFetcher.h
//  DArt
//
//  Created by Clark on 1/30/15.
//  Copyright (c) 2015 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Delegate
@property (nonatomic,strong)NSMutableDictionary *Paintings;

@end
static  NSMutableDictionary *Paintingdic;
static NSMutableArray *urls;
@interface ServerFetcher : NSObject
@property (nonatomic, strong) NSDictionary *Paintingdic;
@property (nonatomic, strong) NSDictionary *artistdic;
@property (nonatomic, strong) UIImage *image;
- (UIImage*)GetPictureThumbWithID:(NSString*)_id;
- (UIImage*)GetPictureWithID:(NSString*)_id;
- (void)reloadDB;
- (void)FetchArtists;
- (NSString *)GetLikes:(NSString*)_id;
-(id)init;
- (void)GenerateQueryForTag:(NSString*)querry;
- (NSMutableArray*)RunQuery;
- (void)GenerateQueryForPrice:(int)min :(int)max;
- (void)GenerateQueryForSize:(NSString*)querry;
-(NSDictionary *)Paintingdic;
- (void)PutLikes:(NSString*)_id;
+ (ServerFetcher *)sharedInstance;


@end
