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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.session.arrayOfPictures count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AVNewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AVTableViewCell" forIndexPath:indexPath];
    
    AVPicture *picture = [self.session.arrayOfPictures objectAtIndex:indexPath.row];
    
    AVAuthor *author = picture.pictureAuthor;
    
    cell.pictureImage.image = picture.pictureImage;
    cell.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.authorImage.image = author.authorsPhoto;
    
    cell.pictureName.text = picture.pictureName;
    
    //cell.pictureTag;
    
    cell.authorName.text = author.authorsName;
    
    //cell.newsDescription;
    cell.tag = indexPath.row;
    // Configure the cell...
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AVManager *dataManager = [AVManager sharedInstance];
    dataManager.session = self.session;
    
    if ([segue.identifier isEqualToString:@"FromNewsToPicture"]) {
        ((AVPictureViewController *)segue.destinationViewController).session = self.session;
        ((AVPictureViewController *)segue.destinationViewController).intputPictureIndex = ((AVNewsTableCell *)sender).tag;
        dataManager.index = ((AVNewsTableCell *)sender).tag;
    }
}

- (IBAction)backReturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
