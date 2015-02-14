//
//  AVNews.h
//  iArtist
//
//  Created by Andrii V. on 02.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVManager.h"
#import "AVSession.h"
#import "AVNewsTableCell.h"

@interface AVNews : UIViewController

@property (strong, nonatomic) AVManager *dataManger;
@property (strong, nonatomic) AVSession *session;
@property (nonatomic, strong) NSDictionary *AllPaintingData;
@property (strong,nonatomic) NSMutableArray *ImageArray;
@property (nonatomic, strong) NSDictionary *CurrentPainting;
@property (nonatomic, strong) NSDictionary *CurrentArtist;
@property (nonatomic, strong) NSMutableArray *urls;


@end
