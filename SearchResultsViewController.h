//
//  SearchResultsViewController.h
//  iArtist
//
//  Created by Clark on 3/5/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *searchString;

@interface SearchResultsViewController :UIViewController<UITableViewDataSource, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ArtistsTV;
@property (weak, nonatomic) IBOutlet UITableView *PaintingsTV;
@property (strong, nonatomic) NSArray *AllPaintingsData;
@property(nonatomic,strong) NSString *searchString;
@end
