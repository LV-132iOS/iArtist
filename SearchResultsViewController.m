//
//  SearchResultsViewController.m
//  iArtist
//
//  Created by Clark on 3/5/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "ServerFetcher.h"

@implementation SearchResultsViewController

- (void)viewDidLoad
{
    self.ArtistsTV.tableHeaderView = [self titleInit:@"Artist"];
    self.PaintingsTV.tableHeaderView = [self titleInit:@"Paintings"];
    
    [[ServerFetcher sharedInstance]search:self.searchString callback:^(NSDictionary *responde) {
        [self.ArtistsTV reloadData];
        [self.PaintingsTV reloadData];
    }];
}

- (UILabel*)titleInit:(NSString*)str
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = str;
    return title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.ArtistsTV)
        return 10;
    else
        return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.ArtistsTV){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Artists" forIndexPath:indexPath];
    cell.textLabel.text = @"Artist";
        return cell;
    } else {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Paintings" forIndexPath:indexPath];
    cell.textLabel.text = @"picture";
    
    return cell;
    }
}

@end
