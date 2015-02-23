//
//  NewsFeedViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsFeedTableViewController.h"

@interface NewsFeedViewController (){
    NewsFeedTableViewController* tableViewController;
}

@end

@implementation NewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableViewController = [[NewsFeedTableViewController alloc] init];
    self.newsTableView.delegate = tableViewController;
    self.newsTableView.dataSource = tableViewController;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeViewAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
