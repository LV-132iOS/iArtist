//
//  BuyCartViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "BuyCartViewController.h"
#import "PaintingsTableViewDelegateAndDataSource.h"

@interface BuyCartViewController (){
    PaintingsTableViewDelegateAndDataSource* tableDelegate;
}

@end

@implementation BuyCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableDelegate = [[PaintingsTableViewDelegateAndDataSource alloc] init];
    self.cartTableView.delegate = tableDelegate;
    self.cartTableView.dataSource = tableDelegate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeViewAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
