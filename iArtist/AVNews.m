//
//  AVNews.m
//  iArtist
//
//  Created by Andrii V. on 02.02.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "AVNews.h"
#import "AVPictureViewController.h"

@interface AVNews () <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UITableView *newsTable;

@end

@implementation AVNews

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
    self.AllPaintingData = Paintingdic;
    self.newsTable.tableHeaderView = tableHeader;
    self.urls =  [[ServerFetcher sharedInstance]GetNewsForUser:[defaults valueForKey:@"id"]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.session.arrayOfPictures count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.CurrentPainting = [self.AllPaintingData valueForKey:[NSString stringWithFormat:@"%@",indexPath]];
    self.CurrentArtist = [self.AllPaintingData valueForKeyPath:[NSString stringWithFormat:@"%@.artistId",indexPath]];
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[self.CurrentArtist valueForKey:@"thumbnail"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [UIImage imageWithData:imageData];

    
    AVNewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AVTableViewCell" forIndexPath:indexPath];
    
    cell.pictureImage.image = [[ServerFetcher sharedInstance]GetPictureThumbWithID:[self.urls objectAtIndex:indexPath.row]];
    


    
    cell.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.authorImage.image = img;
    
    cell.pictureName.text = [self.CurrentPainting valueForKey:@"title"];
    
    cell.authorName.text = [self.CurrentArtist valueForKey:@"name"];
    
    cell.tag = indexPath.row;
    // Configure the cell...
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.session = self.session;
    
    if ([segue.identifier isEqualToString:@"FromNewsToPicture"]) {
        ((AVPictureViewController *)segue.destinationViewController).urls = self.urls;
        ((AVPictureViewController *)segue.destinationViewController).AllPaintingData = self.AllPaintingData;

        //((AVPictureViewController *)segue.destinationViewController).intputPictureIndex = ((AVNewsTableCell *)sender).tag;
        dataManager.index = ((AVNewsTableCell *)sender).tag;
        
    }
    if ([segue.identifier isEqualToString:@"News Cart"]) {
        
        
        
        
    }
    
}

- (IBAction)backReturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
