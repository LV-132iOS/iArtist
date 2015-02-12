//
//  AVPopoverTableViewController.h
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 16.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVWall.h"
#import "AVImagePickerController.h"

@interface AVPopoverTableViewController : UITableViewController <UICollectionViewDelegate, UICollectionViewDataSource,
UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate>

extern NSString *const AVDidSelectWall;

@property (strong, nonatomic) AVImagePickerController *imagePickerController;

@property (strong, nonatomic) NSNumber *distanceToWall;

@property (strong, nonatomic) UIImage *wallImage;

@property (nonatomic, weak) IBOutlet UITableViewCell *importPhotoStaticCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *takeNewPhotoStaticCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *collectionViewStaticCell;

@end

