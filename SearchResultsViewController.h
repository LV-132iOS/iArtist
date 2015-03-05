//
//  SearchResultsViewController.h
//  iArtist
//
//  Created by Clark on 3/5/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController :UIViewController<UITableViewDataSource, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ArtistsTV;
@property (weak, nonatomic) IBOutlet UITableView *PaintingsTV;
@property(nonatomic,strong) NSString *searchString;
@end
