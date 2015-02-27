//
//  AVNews.m
//  iArtist
//
//  Created by Andrii V. on 02.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "NewsViewController.h"
#import "iCaruselViewController.h"

@interface NewsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView    *newsTable;
@property (strong, nonatomic)          NSMutableArray *AllArtistData;
@property (strong, nonatomic) __block  NSMutableArray *Ids;
@property (strong,nonatomic)           NSMutableArray *ImagesArray;

@end

@implementation NewsViewController

NSInteger indexDelete;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self blurImage];
    UILabel *tableHeader = [[UILabel alloc] initWithFrame:(CGRect)
                            {.origin.x = 482,.origin.y = 0,.size.height = 60,.size.width = 60}];
    tableHeader.text = @"News";
    tableHeader.textColor = [UIColor blackColor];
    tableHeader.textAlignment = NSTextAlignmentCenter;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.urls = [[NSMutableArray alloc]init];
    self.AllPaintingData = [[NSMutableDictionary alloc]init];
    self.AllArtistData = [[NSMutableArray alloc]init];
    self.ImagesArray = [[NSMutableArray alloc]init];
    self.paintingData = [NSMutableArray new];
    void (^callback)(NSMutableArray*) = ^(NSMutableArray* array){
        [self setIds:array];
        self.AllArtistData = [NSMutableArray arrayWithArray:[[ServerFetcher sharedInstance]artistdic]];
        self.AllPaintingData = [NSMutableDictionary dictionaryWithDictionary:[[ServerFetcher sharedInstance]Paintingdic]];
        self.paintingData = [[ServerFetcher sharedInstance]paitingDic];
        [self.newsTable reloadData];
    };
    [[ServerFetcher sharedInstance]GetNewsForUser:[defaults valueForKey:@"id"] callback:callback];
    self.newsTable.tableHeaderView = tableHeader;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)blurImage
{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.view.frame;
    [self.view addSubview:visualEffectView];
    [self.view sendSubviewToBack:visualEffectView];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.paintingData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __block NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AVTableViewCell" forIndexPath:indexPath];
    NSLog(@"%d",indexPath.row);
    self.CurrentPainting = [self.paintingData objectAtIndex:indexPath.row];
    for (NSDictionary *artist  in self.AllArtistData) {
        if ([[artist valueForKey:@"_id"]isEqual:[self.CurrentPainting valueForKey:@"artistId"]]) {
            self.CurrentArtist = artist;
        }
    }
    cell.picture = self.CurrentPainting;
    cell.author = self.CurrentArtist;
    [cell reloadCell];
    cell.tag = indexPath.row;
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.session = self.session;
    if ([segue.identifier isEqualToString:@"FromNewsToPicture"]) {
        ((iCaruselViewController *)segue.destinationViewController).urls = self.urls;
        ((iCaruselViewController *)segue.destinationViewController).AllPaintingData = self.AllPaintingData;
        dataManager.index = ((NewsTableViewCell *)sender).tag;
    }
    if ([segue.identifier isEqualToString:@"News Cart"]) {
    }
}

- (IBAction)shouldUnfolowAutor:(id)sender {
    NewsTableViewCell *currentCell =  (NewsTableViewCell *)((((UIButton *)sender).superview).superview);
    indexDelete = currentCell.tag;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You clicked on unfollow Author"
                                                    message:@"Do you realy want to unfollow Author?"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Ok",nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        self.CurrentPainting = [self.paintingData objectAtIndex:indexDelete];
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (NSInteger i = 0; i < [self.AllArtistData count]; i++) {
            NSDictionary *artist = [self.AllArtistData objectAtIndex:i];
            if ([[artist valueForKey:@"_id"]isEqual:[self.CurrentPainting valueForKey:@"artistId"]]) {
                [self.AllArtistData removeObjectAtIndex:i];
            }
        }
        NSMutableIndexSet *indexes = [NSMutableIndexSet new];
        for (NSInteger i = 0; i < [self.paintingData count];i++){
            NSDictionary *painting = [NSDictionary dictionaryWithDictionary:[self.paintingData objectAtIndex:i]];
            if ([[painting valueForKey:@"artistId"]isEqual:[self.CurrentPainting valueForKey:@"artistId"]]) {
                [indexes addIndex:i];
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }
        [self.paintingData removeObjectsAtIndexes:indexes];
        [[ServerFetcher sharedInstance]BecomeAFollower:[self.CurrentPainting valueForKey:@"artistId"]];
        [self.newsTable deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (IBAction)backReturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
