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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.AllArtistData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return self.Ids.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AVTableViewCell" forIndexPath:indexPath];

     self.CurrentPainting = [self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    // NSLog(@"%@",[self.CurrentPainting valueForKey:@"_id"]);
    // NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[self.CurrentArtist valueForKeyPath:@"thumbnail"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    // UIImage *img = [UIImage imageWithData:imageData];
    cell.pictureName.text = [self.CurrentPainting valueForKey:@"title"];
    cell.newsDescription.text = [self.CurrentPainting valueForKey:@"description"];
    cell.pictureTag.text = [(NSArray*)[self.CurrentPainting valueForKey:@"tags"] componentsJoinedByString:@"," ];
    cell.date.text = [self.CurrentPainting valueForKey:@"created_at"];
    //cell.authorName.text = []

    
    UIImage *img = [UIImage new];
    img = cell.pictureImage.image ;
  
    
       // NSLog(@"row %ld",indexPath.row);
       // NSLog(@"section %ld",indexPath.section);
    //if(cell.pictureImage.image == nil){
       //cell.pictureImage = [[UIImageView alloc]initWithImage:[[ServerFetcher sharedInstance]GetPictureThumbWithID:self.Ids[indexPath.row] ]];

    UIImage * im = self.ImagesArray[indexPath.row];
        UIImageView *imm = [[UIImageView alloc] initWithImage:im];
        imm.frame = CGRectMake(10, 10, 290, 290);
        [cell addSubview:imm];
 /*
         cell.pictureImage.image = [[ServerFetcher sharedInstance]GetPictureThumbWithID:self.Ids[0][indexPath.section][indexPath.row]];
          cell.pictureName.text = [self.AllArtistData[i] valueForKeyPath:[(NSArray*)[NSString stringWithFormat:@"paintings.%ld",indexPath.row]objectAtIndex:indexPath.row]];
         cell.authorName.text = [self.AllArtistData[indexPath.section] valueForKey:@"name"];
         NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[self.AllArtistData[indexPath.section] valueForKeyPath:@"thumbnail"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
         UIImage *img = [UIImage imageWithData:imageData];
         cell.authorImage.image = img;     [[AVNewsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AVTableViewCell"];
         
         */
        cell.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
    
        //cell.authorImage.image = img;
        
        
        //cell.authorName.text = [self.CurrentArtist valueForKey:@"name"];
        

  
    
    
    
    // Configure the cell...
    
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

- (IBAction)backReturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
