//
//  LikedCollectionViewController.m
//  iArtist
//
//  Created by Admin on 28.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "LikedCollectionViewController.h"

@interface LikedCollectionViewController (){
        NSArray* arrayForCollectionCells;
}

@end

@implementation LikedCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    arrayForCollectionCells = @[ @"Nature1", @"Nature2", @"Portret", @"Nature3", @"Awesome Portret", @"Car", @"Car2", @"Portret2"];
    return arrayForCollectionCells.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //Returns a reusable cell object located by its identifier
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Picture Cell" forIndexPath:indexPath];
    // Returns the view whose tag matches the specified value.
    UIButton* button = (UIButton*)[cell viewWithTag:111];
    // Sets title for collection view` cells
    [button setTitle:[arrayForCollectionCells objectAtIndex:indexPath.row] forState:button.state];
    
    // making some visual improvements
    cell.layer.borderWidth = 4.0f;
    cell.layer.borderColor = ([UIColor whiteColor]).CGColor;
    cell.layer.cornerRadius = 40;
    
    return cell;
}


@end
