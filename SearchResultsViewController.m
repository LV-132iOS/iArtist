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
    [super viewDidLoad];
    self.AllPaintingsData = [[NSArray alloc]init];
    self.ArtistsTV.tableHeaderView = [self titleInit:@"Artist"];
    self.PaintingsTV.tableHeaderView = [self titleInit:@"Paintings"];
    [self addObserver:self forKeyPath:@"searchString" options:NSKeyValueObservingOptionNew context:NULL];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
        [[ServerFetcher sharedInstance]search:_searchString callback:^(NSArray *responde) {
            if (responde.count == 0){
                self.AllPaintingsData = nil;
                [self.ArtistsTV reloadData];
                [self.PaintingsTV reloadData];
                return;
            }
           
            self.AllPaintingsData = (NSArray*)responde[0];
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
   if(self.AllPaintingsData.count == 0)
       return 0;
    else
        return self.AllPaintingsData.count;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.ArtistsTV){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Artists" forIndexPath:indexPath];
    cell.textLabel.text = @"Artist";
        return cell;
    } else {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Paintings" forIndexPath:indexPath];
    cell.textLabel.text = [[self.AllPaintingsData objectAtIndex:indexPath.row] valueForKey:@"title"];
    
    return cell;
    }
}

@end
