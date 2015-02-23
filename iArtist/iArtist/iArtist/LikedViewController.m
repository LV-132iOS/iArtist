//
//  LikedViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "LikedViewController.h"
#import "LikedCollectionViewController.h"

@interface LikedViewController (){
    LikedCollectionViewController* collectionViewController;
}

@end

@implementation LikedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    collectionViewController = [[LikedCollectionViewController alloc] init];
    
    self.likedCollectionView.delegate = collectionViewController;
    self.likedCollectionView.dataSource = collectionViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeViewAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
