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


@property (strong, nonatomic) IBOutlet UITableView *newsTable;
@property (strong, nonatomic) NSMutableArray *AllArtistData;
@property (strong, nonatomic) __block NSMutableArray *Ids;
@property (strong,nonatomic) NSMutableArray *ImagesArray;


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
    self.AllPaintingData = [[NSDictionary alloc]init];
    self.AllArtistData = [[NSMutableArray alloc]init];
    self.ImagesArray = [[NSMutableArray alloc]init];
    
    //    - (void)GetNewsForUser:(NSString *)_id
    //callback:(void (^)(NSMutableArray* responde))callback
    
    void (^callback)(NSMutableArray*) = ^(NSMutableArray* array){
        [self setIds:array];
        self.AllArtistData = [[ServerFetcher sharedInstance]artistdic];
        self.AllPaintingData = [[ServerFetcher sharedInstance]Paintingdic];
        
        for (int i=0; i<self.Ids.count;i++){
            
            //[self.ImagesArray addObject:([[ServerFetcher sharedInstance]GetPictureThumbWithID:self.Ids[i]])];
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
    
    return [self.Ids count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __block NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AVTableViewCell" forIndexPath:indexPath];
    
    self.CurrentPainting = [self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    for (NSDictionary *artist  in self.AllArtistData) {
        if ([[artist valueForKey:@"_id"]isEqual:[self.CurrentPainting valueForKey:@"artistId"]]) {
            self.CurrentArtist = artist;
        }
    }

    cell.pictureName.text = [self.CurrentPainting valueForKey:@"title"];
    cell.newsDescription.text = [self.CurrentPainting valueForKey:@"description"];
    cell.pictureTag.text = [(NSArray*)[self.CurrentPainting valueForKey:@"tags"] componentsJoinedByString:@"," ];
    cell.date.text = [self.CurrentPainting valueForKey:@"created_at"];
    
    [[ServerFetcher sharedInstance]getPictureThumbWithSizeAndID:[self.CurrentPainting valueForKey:@"_id"]size:@200 callback:^(UIImage *responde) {
        
            cell.pictureImage.image = responde;

            cell.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
            
            NSLog(@"%d Ok", indexPath.row);
       
    }];
 
    cell.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.tag = indexPath.row;
    cell.authorName.text = [self.CurrentArtist valueForKey:@"name"];
        
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[self.CurrentArtist valueForKey:@"thumbnail"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [UIImage imageWithData:imageData];
    cell.authorImage.image = img;
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.session = self.session;
    
    if ([segue.identifier isEqualToString:@"FromNewsToPicture"]) {
        ((iCaruselViewController *)segue.destinationViewController).urls = self.urls;
        ((iCaruselViewController *)segue.destinationViewController).AllPaintingData = self.AllPaintingData;
        
        //((AVPictureViewController *)segue.destinationViewController).intputPictureIndex = ((AVNewsTableCell *)sender).tag;
        dataManager.index = ((NewsTableViewCell *)sender).tag;
        
    }
    if ([segue.identifier isEqualToString:@"News Cart"]) {
        
        
        
    }
    
}
////////
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


- (void)reload{
    self.CurrentPainting = [self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld",(long)indexDelete]];
    
    for (NSDictionary *artist  in self.AllArtistData) {
        
        if ([[artist valueForKey:@"_id"]isEqual:[self.CurrentPainting valueForKey:@"artistId"]]) {
            self.CurrentArtist = artist;
        }
    }
    
    [[ServerFetcher sharedInstance]BecomeAFollower:[self.CurrentArtist valueForKey:@"_id"]];
    
    
    void (^callback)(NSMutableArray*) = ^(NSMutableArray* array){
        [self setIds:array];
        self.AllArtistData = [[ServerFetcher sharedInstance]artistdic];
        self.AllPaintingData = [[ServerFetcher sharedInstance]Paintingdic];
        
        NSLog(@"callback");
        for (int i=0; i<self.Ids.count;i++){
            
            //[self.ImagesArray addObject:([[ServerFetcher sharedInstance]GetPictureThumbWithID:self.Ids[i]])];
        }
        
        [self.newsTable reloadData];
    };
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[ServerFetcher sharedInstance]GetNewsForUser:[defaults valueForKey:@"id"] callback:callback];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)[self reload];
    
}
///////



- (IBAction)backReturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
