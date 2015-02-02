//
//  AVPopoverTableViewController.m
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 16.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import "AVPopoverTableViewController.h"
#import "AVViewControllerBetweenPopoverAndPikerView.h"

NSString *const AVDidSelectWall = @"AVDidSelectWall";

@interface AVPopoverTableViewController ()

@end

@implementation AVPopoverTableViewController

NSArray *arrayOfWals;

#pragma mark initialization
//initialization walls
- (void) initWals{
    
    AVWall *wall1 = [AVWall new];
    wall1.wallPicture = [UIImage imageNamed:@"room1.jpg"];
    wall1.distanceToWall = @1;
    AVWall *wall2 = [AVWall new];
    wall2.wallPicture = [UIImage imageNamed:@"room2.jpg"];
    wall2.distanceToWall = @6;
    AVWall *wall3 = [AVWall new];
    wall3.wallPicture = [UIImage imageNamed:@"room3.jpg"];
    wall3.distanceToWall = @1;
    AVWall *wall4 = [AVWall new];
    wall4.wallPicture = [UIImage imageNamed:@"room4.jpg"];
    wall4.distanceToWall = @3;
    AVWall *wall5 = [AVWall new];
    wall5.wallPicture = [UIImage imageNamed:@"room5.jpg"];
    wall5.distanceToWall = @2;
    AVWall *wall6 = [AVWall new];
    wall6.wallPicture = [UIImage imageNamed:@"room6.jpg"];
    wall6.distanceToWall = @4;
    AVWall *wall7 = [AVWall new];
    wall7.wallPicture = [UIImage imageNamed:@"room7.jpg"];
    wall7.distanceToWall = @1;
    AVWall *wall8 = [AVWall new];
    wall8.wallPicture = [UIImage imageNamed:@"room8.jpg"];
    wall8.distanceToWall = @2;
    AVWall *wall9 = [AVWall new];
    wall9.wallPicture = [UIImage imageNamed:@"room9.jpg"];
    wall9.distanceToWall = @8;
    arrayOfWals = @[wall1, wall2, wall3, wall4, wall5, wall6, wall7, wall8, wall9];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initWals];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark collection view data source
//it is just one section in cillection view
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//number of cells in collection view
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrayOfWals count];
}
//we put picture from a data to the cell
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                           forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    
    AVWall *wall = [arrayOfWals objectAtIndex:indexPath.row];
    UIImage *image = wall.wallPicture;
    
    imageView.image = image;
    
    return cell;
}
//here we put chosen wal wrom a collection view to a notification
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AVWall *selectedWall = [arrayOfWals objectAtIndex:indexPath.row];
    
    NSDictionary *newDictionary = @{@"wall": selectedWall};
    [[NSNotificationCenter defaultCenter]postNotificationName:AVDidSelectWall object:nil userInfo:newDictionary];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark image picker controller delegate
//this metod is for click on cansel button on image picker controller
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//this method is called for chosen image by image picker controller
//we input image and distsnce for wall
//for intput distance for wall we create another controller
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    self.wallImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    AVViewControllerBetweenPopoverAndPikerView *inputDistanceController =
        [AVViewControllerBetweenPopoverAndPikerView new];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        inputDistanceController = [self.storyboard instantiateViewControllerWithIdentifier:@"InputDistanceToCamera"];
    } else {
        inputDistanceController = [self.storyboard instantiateViewControllerWithIdentifier:@"InputDistance"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectDistanceToWall:)
                                                 name:AVDidSelectDistanceToWall
                                               object:nil];
    [inputDistanceController view];
    [picker pushViewController:inputDistanceController animated:YES];
    
    inputDistanceController.background.image = [info valueForKey:UIImagePickerControllerOriginalImage];
}

#pragma mark table view delegate
//this delegate mathod is called for chosen static cells
//for first two cells we create image picker controller whith different style
//for last cell - collection view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *theCellClicked = [self.tableView cellForRowAtIndexPath:indexPath];
    if (theCellClicked == self.importPhotoStaticCell) {
        
        self.imagePickerController = [AVImagePickerController new];

        self.imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.imagePickerController.delegate = self;
        [self presentViewController:self.imagePickerController
                           animated:YES
                         completion:nil];
    }
    if (theCellClicked == self.takeNewPhotoStaticCell) {
        
        self.imagePickerController = [AVImagePickerController new];
        
        self.imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

        [self presentViewController:self.imagePickerController
                           animated:YES
                         completion:nil];
    }
    if (theCellClicked == self.collectionViewStaticCell) {
        
    }
}

// notification here we post notification with chosen wall
- (void) selectDistanceToWall:(NSNotification *)notification{
    self.distanceToWall = [notification.userInfo valueForKey:@"distance"];
    
    AVWall *selectedWall = [AVWall new];
    selectedWall.wallPicture = self.wallImage;
    
    selectedWall.distanceToWall = self.distanceToWall;
    
    NSDictionary *newDictionary = @{@"wall" :selectedWall};
    [[NSNotificationCenter defaultCenter]postNotificationName:AVDidSelectWall object:nil userInfo:newDictionary];
    
}

@end
