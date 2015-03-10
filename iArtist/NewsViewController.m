//
//  AVNews.m
//  iArtist
//
//  Created by Andrii V. on 02.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "NewsViewController.h"
#import "iCaruselViewController.h"
#import "ArtistViewController.h"

@interface NewsViewController () <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UITableView *newsTable;
@property (strong, nonatomic) NSMutableArray *AllArtistData;
@property (strong, nonatomic) __block NSMutableArray *Ids;
@property (strong,nonatomic) NSMutableArray *ImagesArray;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation NewsViewController

NSInteger indexDelete;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self blurImage];
    self.dataArray = [NSMutableArray new];
    
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
    
    
    
    void (^callback)(NSMutableArray*) = ^(NSMutableArray* array){
        [self setIds:array];
        
        self.AllArtistData = [[NSMutableArray alloc] initWithArray:[[ServerFetcher sharedInstance]artistdic]];
        
        //self.AllPaintingData = [[ServerFetcher sharedInstance]Paintingdic];
        
        
        for (NSInteger i = 0;  i < self.AllArtistData.count; i++) {
            [self.dataArray addObject:[NSNull null]];
        }
        [self.newsTable reloadData];
    };
    
    [[ServerFetcher sharedInstance]GetNewsForUser:[defaults valueForKey:@"id"] callback:callback];
    
    // NSLog(@"%@",self.AllArtistData);
    //  NSLog(@"%@",self.AllPaintingData);
    
    
    self.newsTable.tableHeaderView = tableHeader;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
        return self.AllArtistData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AVTableViewCell" forIndexPath:indexPath];
    
    
    self.CurrentPainting = [self.AllArtistData objectAtIndex:indexPath.row];
    
    cell.picture = self.CurrentPainting;
    cell.author = [self.CurrentPainting valueForKey:@"artistId"];
    
    [cell reloadCell];
    
    cell.tag = indexPath.row;
    
    if ([self.dataArray objectAtIndex:indexPath.row] == [NSNull null]) {
        cell.loadPictureIndicator.hidden = NO;
        [cell.loadPictureIndicator megaInit];
        [cell.loadPictureIndicator startAnimating];
        [[ServerFetcher sharedInstance]getPictureThumbWithSizeAndID:[self.CurrentPainting valueForKey:@"_id"]
                                                               size:@200
                                                           callback:^(UIImage *responde) {
            [cell.loadPictureIndicator stopAnimating];
            cell.loadPictureIndicator.hidden = YES;
            cell.pictureImage.image = responde;
            cell.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
                                                               
            cell.pictureImage.hidden = NO;
            if (responde != nil) {
                [self.dataArray replaceObjectAtIndex:indexPath.row withObject:responde];
            }
            
                                                               
            }];
    } else {
        cell.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
        cell.pictureImage.image = [self.dataArray objectAtIndex:indexPath.row];
        cell.pictureImage.hidden = NO;
    }
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.session = self.session;
    
   
    
   
    
    if ([segue.identifier isEqualToString:@"NewsToICarusel"]) {
        NewsTableViewCell *currentCell =  ((NewsTableViewCell *)sender);
         NSInteger index = ([self.newsTable indexPathForCell:currentCell]).row;
        dataManager.index = ((NewsTableViewCell *)sender).tag;
        for (int i = 0;i<self.AllArtistData.count;i++){
            NSString *str =[NSString stringWithFormat:@"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com/paintings/files/%@?thumb=preview",[self.AllArtistData[i] valueForKey:@"_id"]];
            [self.urls addObject:str];
            [self.AllPaintingData setObject:self.AllArtistData[i] forKey:[NSString stringWithFormat: @"%d",i]];
        }
        ((iCaruselViewController *)segue.destinationViewController).urls = self.urls;
        ((iCaruselViewController *)segue.destinationViewController).AllPaintingData = self.AllPaintingData;
        ((iCaruselViewController *)segue.destinationViewController).index = index;
    }
    if ([segue.identifier isEqualToString:@"NewsAuthor"]) {
        NewsTableViewCell *currentCell =  (NewsTableViewCell *)((((UIButton *)sender).superview).superview);
        ((ArtistViewController *)segue.destinationViewController).CurrentArtist = currentCell.author;
        ((ArtistViewController *)segue.destinationViewController).img = currentCell.authorImage.image;

    }
    
    
}


- (IBAction)shouldUnfolowAutor:(id)sender {
    NewsTableViewCell *currentCell =  (NewsTableViewCell *)((((UIButton *)sender).superview).superview);
    
    indexDelete = [self.newsTable indexPathForCell:currentCell].row;

    
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
        self.CurrentPainting = [self.AllArtistData objectAtIndex:indexDelete];
        
        NSDictionary *artist = [self.CurrentPainting valueForKey:@"artistId"];
        NSString *artistId = [artist valueForKey:@"_id"];
        
        NSMutableArray *indexPaths = [NSMutableArray new];
        NSMutableIndexSet *indexes = [NSMutableIndexSet new];
        for (NSInteger i = 0; i < [self.AllArtistData count]; i++) {
            
            NSDictionary *newArtist = [[self.AllArtistData objectAtIndex:i]valueForKey:@"artistId"];
            
            if ([artistId isEqual:[newArtist valueForKey:@"_id"]]) {
 
                [indexes addIndex:i];
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }
        
        [self.AllArtistData removeObjectsAtIndexes:indexes];
        [self.dataArray removeObjectsAtIndexes:indexes];
        [[ServerFetcher sharedInstance]BecomeAFollower:artistId
                                              callback:^(BOOL responde) {
                                              //    NSLog(@"Unfollow Ok");
        }];

        [self.newsTable deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (IBAction)backReturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
